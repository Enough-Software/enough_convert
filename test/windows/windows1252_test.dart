import 'dart:convert' as convert;

// import 'package:enough_convert/base.dart';
import 'package:enough_convert/windows/windows1252.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Windows1252Codec().name, 'windows-1252');
      //BaseEncoder.createEncodingMap(Windows1252Decoder().symbols, 0x7f);
    });
    test('Decoder/encoder classes', () {
      expect(Windows1252Codec().encoder, isA<Windows1252Encoder>());
      expect(Windows1252Codec().decoder, isA<Windows1252Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Windows1252Decoder().convert(bytes), 'hello world');
    });

    test('Decode Windows1252', () {
      expect(Windows1252Decoder().convert([0xC4, 0xD6, 0xFC]), 'ÄÖü');
      final bytes =
          Windows1252Encoder().convert('hello world motörhead ruleß ok ô');
      expect(Windows1252Decoder().convert(bytes),
          'hello world motörhead ruleß ok ô');
    });

    test('Decode Windows1252 with invalid value when invalid input is allowed',
        () {
      expect(
          Windows1252Decoder(allowInvalid: true)
              .convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ÄÖü�');
    });

    test(
        'Decode Windows1252 with invalid value when invalid input is not allowed',
        () {
      expect(() => Windows1252Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Windows1252Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode Windows1252', () {
      var bytes = Windows1252Encoder().convert('ÄÖü');
      expect(bytes, [0xC4, 0xD6, 0xFC]);
      bytes = Windows1252Encoder().convert('hello world motörhead ruleß ok');

      /// this works because umlauts are at the same position as in latin-1
      expect(bytes, convert.latin1.encode('hello world motörhead ruleß ok'));

      bytes = Windows1252Encoder().convert('Il faut être bête quand même.');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more Windows1252 ', () {
      final encoder = Windows1252Encoder();
      final decoder = Windows1252Decoder();
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

    test('encode Windows1252 with invalid value when invalid input is allowed',
        () {
      var bytes = Windows1252Encoder(allowInvalid: true).convert('ÄÖü�');
      expect(Windows1252Decoder().convert(bytes), 'ÄÖü?');
    });

    test(
        'encode Windows1252 with invalid value when invalid input is not allowed',
        () {
      expect(() => Windows1252Encoder().convert('ÄÖü�'),
          throwsA(isA<FormatException>()));
    });
  });
}
