// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/enough_convert.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Windows1250Codec().name, 'windows-1250');
      // BaseEncoder.createEncodingMap(Windows1250Decoder().symbols, 0x7f);
    });
    test('Decoder/encoder classes', () {
      expect(const Windows1250Codec().encoder, isA<Windows1250Encoder>());
      expect(const Windows1250Codec().decoder, isA<Windows1250Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Windows1250Decoder().convert(bytes), 'hello world');
    });

    test('Decode Windows1250', () {
      expect(const Windows1250Decoder().convert([0xC4, 0xD6, 0xFC]), 'ÄÖü');
      final bytes = const Windows1250Encoder()
          .convert('hello world motörhead ruleß ok ô');
      expect(const Windows1250Decoder().convert(bytes),
          'hello world motörhead ruleß ok ô');
    });

    test('Decode Windows1250 with invalid value when invalid input is allowed',
        () {
      expect(
          const Windows1250Decoder(allowInvalid: true)
              .convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ÄÖü�');
    });

    test(
        'Decode Windows1250 with invalid value when invalid input is not allowed',
        () {
      expect(
          () => const Windows1250Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Windows1250Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode Windows1250', () {
      var bytes = const Windows1250Encoder().convert('ÄÖü');
      expect(bytes, [0xC4, 0xD6, 0xFC]);
      bytes =
          const Windows1250Encoder().convert('hello world motörhead ruleß ok');

      /// this works because umlauts are at the same position as in latin-1
      expect(
          bytes, dart_convert.latin1.encode('hello world motörhead ruleß ok'));

      bytes = const Windows1250Encoder().convert('Těší mě, že vás poznávám!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more Windows1250 ', () {
      const encoder = Windows1250Encoder();
      const decoder = Windows1250Decoder();
      final bytes = encoder.convert(decoder.symbols);
      final expected = List.generate(0xFF - 0x7F, (index) => index + 0x80);
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
      final bytes =
          const Windows1250Encoder(allowInvalid: true).convert('ÄÖü�');
      expect(const Windows1250Decoder().convert(bytes), 'ÄÖü?');
    });

    test(
        'encode Windows1250 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Windows1250Encoder().convert('ÄÖü�'),
          throwsA(isA<FormatException>()));
    });
  });
}
