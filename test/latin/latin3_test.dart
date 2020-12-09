import 'dart:convert' as convert;

import 'package:enough_convert/latin/latin3.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Latin3Codec().name, 'iso-8859-3');
    });
    test('Decoder/encoder classes', () {
      expect(Latin3Codec().encoder, isA<Latin3Encoder>());
      expect(Latin3Codec().decoder, isA<Latin3Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Latin3Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 3', () {
      expect(Latin3Decoder().convert([0xC4, 0xD6, 0xFC]), 'ÄÖü');
      final bytes = Latin3Encoder().convert('hello world motörhead ruleß ok ô');
      expect(
          Latin3Decoder().convert(bytes), 'hello world motörhead ruleß ok ô');
    });

    test('Decode latin 3 with invalid value when invalid input is allowed', () {
      expect(
          Latin3Decoder(allowInvalid: true).convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ÄÖü�');
    });

    test('Decode latin 3 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin3Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Latin3Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode latin 3', () {
      var bytes = Latin3Encoder().convert('ÄÖü');
      expect(bytes, [0xC4, 0xD6, 0xFC]);
      bytes = Latin3Encoder().convert('hello world motörhead ruleß ok');

      /// this works because umlauts are at the same position as in latin-1
      expect(bytes, convert.latin1.encode('hello world motörhead ruleß ok'));
      bytes = Latin3Encoder().convert('Tanıştığımıza memnun oldum!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more latin 3 ', () {
      final input =
          'Ħ˘£¤?Ĥ§¨İŞĞĴ\u{00AD}?Ż°ħ²³´µĥ·¸ışğĵ½?żÀÁÂ?ÄĊĈÇÈÉÊËÌÍÎÏ?ÑÒÓÔĠÖ×ĜÙÚÛÜŬŜßàáâ?äċĉçèéêëìíîï?ñòóôġö÷ĝùúûüŭŝ˙';
      var bytes = Latin3Encoder().convert(input);
      var expected = List.generate(95, (index) => index + 0xA1);
      for (var i = 0; i < input.length; i++) {
        if (input.codeUnitAt(i) == 0x3F) {
          // ?
          expected[i] = 0x3F;
        }
      }
      expect(bytes, expected);
    });

    test('encode latin 3 with invalid value when invalid input is allowed', () {
      var bytes = Latin3Encoder(allowInvalid: true).convert('ÄÖü�');
      expect(Latin3Decoder().convert(bytes), 'ÄÖü?');
    });

    test('encode latin 3 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin3Encoder().convert('ÄÖü�'),
          throwsA(isA<FormatException>()));
    });
  });
}
