// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/enough_convert.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Latin3Codec().name, 'iso-8859-3');
    });
    test('Decoder/encoder classes', () {
      expect(const Latin3Codec().encoder, isA<Latin3Encoder>());
      expect(const Latin3Codec().decoder, isA<Latin3Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Latin3Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 3', () {
      expect(const Latin3Decoder().convert([0xC4, 0xD6, 0xFC]), 'ÄÖü');
      final bytes =
          const Latin3Encoder().convert('hello world motörhead ruleß ok ô');
      expect(const Latin3Decoder().convert(bytes),
          'hello world motörhead ruleß ok ô');
    });

    test('Decode latin 3 with invalid value when invalid input is allowed', () {
      expect(
          const Latin3Decoder(allowInvalid: true)
              .convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ÄÖü�');
    });

    test('Decode latin 3 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin3Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Latin3Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode latin 3', () {
      var bytes = const Latin3Encoder().convert('ÄÖü');
      expect(bytes, [0xC4, 0xD6, 0xFC]);
      bytes = const Latin3Encoder().convert('hello world motörhead ruleß ok');

      /// this works because umlauts are at the same position as in latin-1
      expect(
          bytes, dart_convert.latin1.encode('hello world motörhead ruleß ok'));
      bytes = const Latin3Encoder().convert('Tanıştığımıza memnun oldum!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more latin 3 ', () {
      const input =
          'Ħ˘£¤?Ĥ§¨İŞĞĴ\u{00AD}?Ż°ħ²³´µĥ·¸ışğĵ½?żÀÁÂ?ÄĊĈÇÈÉÊËÌÍÎÏ?ÑÒÓÔĠÖ×ĜÙÚÛÜŬŜßàáâ?äċĉçèéêëìíîï?ñòóôġö÷ĝùúûüŭŝ˙';
      final bytes = const Latin3Encoder().convert(input);
      final expected = List.generate(95, (index) => index + 0xA1);
      for (var i = 0; i < input.length; i++) {
        if (input.codeUnitAt(i) == 0x3F) {
          // ?
          expected[i] = 0x3F;
        }
      }
      expect(bytes, expected);
    });

    test('encode latin 3 with invalid value when invalid input is allowed', () {
      final bytes = const Latin3Encoder(allowInvalid: true).convert('ÄÖü�');
      expect(const Latin3Decoder().convert(bytes), 'ÄÖü?');
    });

    test('encode latin 3 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin3Encoder().convert('ÄÖü�'),
          throwsA(isA<FormatException>()));
    });
  });
}
