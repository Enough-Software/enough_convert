import 'dart:convert' as convert;

// import 'package:enough_convert/base.dart';
import 'package:enough_convert/windows/windows1250.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Windows1250Codec().name, 'windows-1250');
      // BaseEncoder.createEncodingMap(Windows1250Decoder().symbols, 0x7f);
    });
    test('Decoder/encoder classes', () {
      expect(Windows1250Codec().encoder, isA<Windows1250Encoder>());
      expect(Windows1250Codec().decoder, isA<Windows1250Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Windows1250Decoder().convert(bytes), 'hello world');
    });

    test('Decode Windows1250', () {
      expect(Windows1250Decoder().convert([0xC4, 0xD6, 0xFC]), 'ÄÖü');
      final bytes =
          Windows1250Encoder().convert('hello world motörhead ruleß ok ô');
      expect(Windows1250Decoder().convert(bytes),
          'hello world motörhead ruleß ok ô');
    });

    test('Decode Windows1250 with invalid value when invalid input is allowed',
        () {
      expect(
          Windows1250Decoder(allowInvalid: true)
              .convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ÄÖü�');
    });

    test(
        'Decode Windows1250 with invalid value when invalid input is not allowed',
        () {
      expect(() => Windows1250Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Windows1250Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode Windows1250', () {
      var bytes = Windows1250Encoder().convert('ÄÖü');
      expect(bytes, [0xC4, 0xD6, 0xFC]);
      bytes = Windows1250Encoder().convert('hello world motörhead ruleß ok');

      /// this works because umlauts are at the same position as in latin-1
      expect(bytes, convert.latin1.encode('hello world motörhead ruleß ok'));

      bytes = Windows1250Encoder().convert('Těší mě, že vás poznávám!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more Windows1250 ', () {
      final encoder = Windows1250Encoder();
      final decoder = Windows1250Decoder();
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

    test('encode Windows1250 with invalid value when invalid input is allowed',
        () {
      var bytes = Windows1250Encoder(allowInvalid: true).convert('ÄÖü�');
      expect(Windows1250Decoder().convert(bytes), 'ÄÖü?');
    });

    test(
        'encode Windows1250 with invalid value when invalid input is not allowed',
        () {
      expect(() => Windows1250Encoder().convert('ÄÖü�'),
          throwsA(isA<FormatException>()));
    });
  });
}
