import 'dart:convert' as convert;

// import 'package:enough_convert/base.dart';
import 'package:enough_convert/windows/windows1253.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Windows1253Codec().name, 'windows-1253');
      // BaseEncoder.createEncodingMap(Windows1253Decoder().symbols, 0x7f);
    });
    test('Decoder/encoder classes', () {
      expect(Windows1253Codec().encoder, isA<Windows1253Encoder>());
      expect(Windows1253Codec().decoder, isA<Windows1253Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Windows1253Decoder().convert(bytes), 'hello world');
    });

    test('Decode Windows1253', () {
      expect(Windows1253Decoder().convert([0xC4, 0xD6, 0xFC]), 'ΔΦό');
      final bytes = Windows1253Encoder().convert('Χαίρομαι που σας γνωρίζω!');
      expect(Windows1253Decoder().convert(bytes), 'Χαίρομαι που σας γνωρίζω!');
    });

    test('Decode Windows1253 with invalid value when invalid input is allowed',
        () {
      expect(
          Windows1253Decoder(allowInvalid: true)
              .convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ΔΦό�');
    });

    test(
        'Decode Windows1253 with invalid value when invalid input is not allowed',
        () {
      expect(() => Windows1253Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Windows1253Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode Windows1253', () {
      var bytes = Windows1253Encoder().convert('ΔΦό');
      expect(bytes, [0xC4, 0xD6, 0xFC]);
      bytes = Windows1253Encoder().convert('Χαίρομαι που σας γνωρίζω!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more Windows1253', () {
      final encoder = Windows1253Encoder();
      final decoder = Windows1253Decoder();
      var bytes = encoder.convert(decoder.symbols);
      var expected = List.generate(0xFF - 0x7F, (index) => index + 0x80);
      for (var i = 0; i < decoder.symbols.length; i++) {
        if (decoder.symbols.codeUnitAt(i) == 0x3F) {
          // ?
          expected[i] = 0x3F;
        }
      }
      expect(bytes, expected);
    });

    test('encode Windows1253 with invalid value when invalid input is allowed',
        () {
      var bytes = Windows1253Encoder(allowInvalid: true).convert('ΔΦό�');
      expect(Windows1253Decoder().convert(bytes), 'ΔΦό?');
    });

    test(
        'encode Windows1253 with invalid value when invalid input is not allowed',
        () {
      expect(() => Windows1253Encoder().convert('ΔΦό�'),
          throwsA(isA<FormatException>()));
    });
  });
}
