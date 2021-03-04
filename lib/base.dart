import 'dart:convert' as cnvrt;

import 'dart:typed_data';

/// Contains base classes for 8bit codecs

/// Provides a simple, non chunkable decoder.
class BaseDecoder extends cnvrt.Converter<List<int>, String> {
  final String symbols;
  final int startIndex;
  final bool allowInvalid;

  /// Creates a new 8bit decoder.
  ///
  /// [symbols] contain all symbols different than UTF8 from the specified [startIndex] onwards.
  /// The length of the [symbols] need to be `255` / `0xFF` minus the [startIndex].
  /// Set [allowedInvalid] to true in case invalid characters sequences should be at least readable.
  const BaseDecoder(this.symbols, this.startIndex, {this.allowInvalid = false})
      : assert(symbols.length == 255 - startIndex);

  @override
  String convert(List<int> bytes, [int start = 0, int? end]) {
    end = RangeError.checkValidRange(start, end, bytes.length);
    List<int>? modified;
    for (var i = start; i < end; i++) {
      final byte = bytes[i];
      if ((byte & ~0xFF) != 0) {
        if (!allowInvalid) {
          throw FormatException('Invalid value in input: $byte at position $i');
        } else {
          modified ??= List.from(bytes);
          modified[i] = 0xFFFD; // unicode �
        }
      } else if (byte > startIndex) {
        final index = byte - (startIndex + 1);
        modified ??= List.from(bytes);
        modified[i] = symbols.codeUnitAt(index);
      }
    }
    return String.fromCharCodes(modified ?? bytes, start, end);
  }

  @override
  cnvrt.ByteConversionSink startChunkedConversion(Sink<String> sink) {
    cnvrt.StringConversionSink stringSink;
    if (sink is cnvrt.StringConversionSink) {
      stringSink = sink;
    } else {
      stringSink = cnvrt.StringConversionSink.from(sink);
    }
    return BaseDecoderSink(stringSink, allowInvalid, this);
  }
}

/// Provides a simple, non chunkable 8bit encoder.
class BaseEncoder extends cnvrt.Converter<String, List<int>> {
  final bool allowInvalid;
  final Map<int, int> encodingMap;
  final int startIndex;

  /// Creates a new encoder.
  ///
  /// Set [allowedInvalid] to true in case invalid characters should be translated to question marks.
  const BaseEncoder(this.encodingMap, this.startIndex,
      {this.allowInvalid = false});

  /// Static helper function to generate a conversion map from a symbols string.
  static Map<int, int> createEncodingMap(String symbols, int startIndex) {
    final runes = symbols.runes;
    final map = <int, int>{};
    var index = 0;
    if (runes.length != 255 - startIndex) {
      print(
          'WARNING: there are not ${255 - startIndex} symbols but ${runes.length} runes in the specified map - is the given startIndex $startIndex correct?');
    }
    for (final rune in runes) {
      if (rune != 0x3F) {
        // "?" denote an empty slot in the map
        final value = index + startIndex + 1;
        if (map.containsValue(value)) {
          final symbol = symbols.substring(index, index + 1);
          final firstIndex = symbols.indexOf(symbol);
          final lastIndex = symbols.lastIndexOf(symbol);
          throw FormatException(
              'Duplicate value $value for isoSymbols "$symbol" at index $index - in symbols to found at $firstIndex and $lastIndex');
        }
        if (value <= startIndex) {
          final symbol = symbols.substring(index, index + 1);
          throw FormatException(
              'Invalid value $value for "$symbol" at index $index');
        }
        map[rune] = value;
        print('\t$rune: $value,');
      }
      index++;
    }
    return map;
  }

  @override
  List<int> convert(String input, [int start = 0, int? end]) {
    var runesList = input.runes.toList(growable: false);
    end = RangeError.checkValidRange(start, end, runesList.length);
    if (start > 0 || end < runesList.length) {
      runesList = runesList.sublist(start, end);
    }
    for (var i = 0; i < runesList.length; i++) {
      final rune = runesList[i];
      if (rune > startIndex) {
        final value = encodingMap[rune];
        if (value == null) {
          if (!allowInvalid) {
            throw FormatException(
                'Invalid value in input: "${String.fromCharCode(rune)}" / ($rune) at index $i');
          } else {
            runesList[i] = 0x3F; // ?
          }
        } else {
          runesList[i] = value;
        }
      }
    }
    return runesList;
  }

  @override
  cnvrt.StringConversionSink startChunkedConversion(Sink<List<int>> sink) {
    cnvrt.ByteConversionSink byteSink;
    if (sink is cnvrt.ByteConversionSink) {
      byteSink = sink;
    } else {
      byteSink = cnvrt.ByteConversionSink.from(sink);
    }
    return BaseEncoderSink(byteSink, this);
  }
}

/// Decoder sink for chunked conversion.
///
/// Compare `BaseDecoder.startChunkedConversion(...)`.
class BaseDecoderSink extends cnvrt.ByteConversionSinkBase {
  final cnvrt.StringConversionSink sink;
  final bool allowInvalid;
  final BaseDecoder decoder;

  BaseDecoderSink(this.sink, this.allowInvalid, this.decoder);

  @override
  void close() {
    sink.close();
  }

  @override
  void add(List<int> chunk) {
    addSlice(chunk, 0, chunk.length, false);
  }

  @override
  void addSlice(List<int> source, int start, int end, bool isLast) {
    RangeError.checkValidRange(start, end, source.length);
    if (start == end) return;
    if (!allowInvalid && source is! Uint8List) {
      // List may contain value outside of the 0..255 range. If so, throw.
      // Technically, we could excuse Uint8ClampedList as well, but it unlikely
      // to be relevant.
      _checkValid8Bit(source, start, end);
    }
    _addSliceToSink(source, start, end, isLast);
  }

  void _addSliceToSink(List<int> source, int start, int end, bool isLast) {
    final sliceText = decoder.convert(source, start, end);
    sink.add(sliceText);
    if (isLast) {
      close();
    }
  }

  void _checkValid8Bit(List<int> source, int start, int end) {
    for (var i = start; i < end; i++) {
      var char = source[i];
      if (char < 0 || char > 0xff) {
        throw FormatException(
            'Source contains non-8-bit character code 0x${char.toRadixString(16)} at $i.',
            source,
            i);
      }
    }
  }
}

/// Encoder sink for chunked conversion.
///
/// Compare `BaseEncoder.startChunkedConversion(...)`.
class BaseEncoderSink extends cnvrt.StringConversionSinkBase {
  final cnvrt.ByteConversionSink sink;
  final BaseEncoder encoder;

  BaseEncoderSink(this.sink, this.encoder);

  @override
  void close() {
    sink.close();
  }

  @override
  void add(String chunk) {
    addSlice(chunk, 0, chunk.length, false);
  }

  @override
  void addSlice(String source, int start, int end, bool isLast) {
    RangeError.checkValidRange(start, end, source.length);
    if (start == end) return;

    final sliceData = encoder.convert(source, start, end);
    sink.add(sliceData);
    if (isLast) {
      close();
    }
  }
}
