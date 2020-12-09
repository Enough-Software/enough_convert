import 'dart:convert' as cnvrt;

/// Contains base classes for latin 2  to latin 16 / iso-8859-XX codecs

/// Provides a simple, non chunkable iso-8859-XX  decoder.
/// Note that the decoder directly modifies the data given in `convert(List<int> data)`,
/// in doubt create a new array first, e.g.
/// ```dart
/// decoder.convert([...data]);
/// ```
class BaseDecoder extends cnvrt.Converter<List<int>, String> {
  final String symbols;
  final int startIndex;
  final bool allowInvalid;

  /// Creates a new 8bit decoder.
  /// [symbols] contain all symbols different than UTF8 from the specified [startIndex] onwards.
  /// The length of the [symbols] need to be `255` / `0xFF` minus the [startIndex].
  /// Set [allowedInvalid] to true in case invalid characters sequences should be at least readable.
  const BaseDecoder(this.symbols, this.startIndex, {this.allowInvalid = false})
      : assert(symbols?.length == 255 - startIndex);

  @override
  String convert(List<int> bytes, [int start = 0, int end]) {
    end = RangeError.checkValidRange(start, end, bytes.length);
    if (end == null) {
      throw RangeError('Invalid range');
    }
    // note: this directly modifies the given data, so decoding the
    // same byte array twice will not work
    for (var i = start; i < end; i++) {
      final byte = bytes[i];
      if ((byte & ~0xFF) != 0) {
        if (!allowInvalid) {
          throw FormatException('Invalid value in input: $byte at position $i');
        } else {
          bytes[i] = 0xFFFD; // unicode �
        }
      } else if (byte > startIndex) {
        final index = byte - (startIndex + 1);
        bytes[i] = symbols.codeUnitAt(index);
      }
    }
    return String.fromCharCodes(bytes, start, end);
  }
}

/// Provides a simple, non chunkable 8bit encoder.
class BaseEncoder extends cnvrt.Converter<String, List<int>> {
  final bool allowInvalid;
  final Map<int, int> encodingMap;
  final int startIndex;

  /// Creates a new encoder.
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
  List<int> convert(String input, [int start = 0, int end]) {
    final runes = input.runes;
    end = RangeError.checkValidRange(start, end, runes.length);
    if (end == null) {
      throw RangeError('Invalid range');
    }
    var runesList = runes.toList(growable: false);
    if (start > 0 || end < runesList.length) {
      runesList = runesList.sublist(start, end);
    }
    for (var i = 0; i < runesList.length; i++) {
      var rune = runesList[i];
      if (rune > startIndex) {
        final value = encodingMap[rune];
        if (value == null) {
          if (!allowInvalid) {
            throw FormatException(
                'Invalid value in input: ${String.fromCharCode(rune)} ($rune) at $i');
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
}
