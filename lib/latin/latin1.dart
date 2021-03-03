import 'dart:convert' as cnvrt;

/// Provides simple iso-8859-1 / latin 1 support for dart.
/// Use `dart:convert.Latin1Codec` if in doubt.
class Latin1Codec extends cnvrt.Encoding {
  final bool allowInvalid;

  const Latin1Codec({this.allowInvalid = false});

  @override
  cnvrt.Converter<List<int>, String> get decoder => allowInvalid
      ? const Latin1Decoder(allowInvalid: true)
      : const Latin1Decoder(allowInvalid: false);

  @override
  cnvrt.Converter<String, List<int>> get encoder => allowInvalid
      ? const Latin1Encoder(allowInvalid: true)
      : const Latin1Encoder(allowInvalid: false);

  @override
  String get name => 'iso-8859-1';
}

/// Provides a simple, non chunkable iso-8859-1 / latin1 decoder.
class Latin1Decoder extends cnvrt.Converter<List<int>, String> {
  final bool allowInvalid;

  /// Creates a new latin 1 decoder.
  /// Set [allowedInvalid] to true in case invalid characters sequences should be at least readable.
  const Latin1Decoder({this.allowInvalid = false});

  @override
  String convert(List<int> bytes, [int start = 0, int? end]) {
    // values of ISO 8859-1 corresponds to the first 256 characters in UTF8, so conversion is trivial
    end = RangeError.checkValidRange(start, end, bytes.length);
    if (end == null) {
      throw RangeError('Invalid range');
    }

    for (var i = start; i < end; i++) {
      var byte = bytes[i];
      if ((byte & ~0xFF) != 0) {
        if (!allowInvalid) {
          throw FormatException('Invalid value in input: $byte');
        } else {
          bytes[i] = 0xFFFD; // unicode �
        }
      }
    }
    return String.fromCharCodes(bytes, start, end);
  }

  // @override
  // cnvrt.ByteConversionSink startChunkedConversion(Sink<String> sink) {
  //   cnvrt.StringConversionSink stringSink;
  //   if (sink is cnvrt.StringConversionSink) {
  //     stringSink = sink;
  //   } else {
  //     stringSink = cnvrt.StringConversionSink.from(sink);
  //   }
  //   return Latin1DecoderSink(stringSink, allowInvalid);
  // }
}

// class Latin1DecoderSink extends cnvrt.ByteConversionSinkBase {
//   final cnvrt.StringConversionSink sink;
//   final bool allowInvalid;

//   Latin1DecoderSink(this.sink, this.allowInvalid);

//   @override
//   void close() {
//     sink.close();
//   }

//   @override
//   void add(List<int> chunk) {
//     addSlice(chunk, 0, chunk.length, false);
//   }

//   @override
//   void addSlice(List<int> source, int start, int end, bool isLast) {
//     RangeError.checkValidRange(start, end, source.length);
//     if (start == end) return;
//     if (!allowInvalid && source is! Uint8List) {
//       // List may contain value outside of the 0..255 range. If so, throw.
//       // Technically, we could excuse Uint8ClampedList as well, but it unlikely
//       // to be relevant.
//       _checkValidLatin1(source, start, end);
//     }
//     _addSliceToSink(source, start, end, isLast);
//   }

//   void _addSliceToSink(List<int> source, int start, int end, bool isLast) {
//     sink.add(String.fromCharCodes(source, start, end));
//     if (isLast) {
//       close();
//     }
//   }

//   void _checkValidLatin1(List<int> source, int start, int end) {
//     for (var i = start; i < end; i++) {
//       var char = source[i];
//       if (char < 0 || char > 0xff) {
//         throw FormatException(
//             'Source contains non-ISO-8859 character code 0x${char.toRadixString(16)}.',
//             source,
//             i);
//       }
//     }
//   }
// }

/// Provides a simple, non chunkable iso-8859-1 / latin1 encoder.
class Latin1Encoder extends cnvrt.Converter<String, List<int>> {
  final bool allowInvalid;

  /// Creates a new latin 1 encoder.
  /// Set [allowedInvalid] to true in case invalid characters should be translated to question marks.
  const Latin1Encoder({this.allowInvalid = false});

  @override
  List<int> convert(String input, [int start = 0, int? end]) {
    // 7bit values of ISO 8859 correspond to their ASCII values:
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
      if ((rune & ~0xFF) != 0) {
        if (!allowInvalid) {
          throw FormatException('Invalid value in input: $rune');
        } else {
          runesList[i] = 0x3F; // ?
        }
      }
    }
    return runesList;
  }
}
