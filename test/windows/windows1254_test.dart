// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/enough_convert.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Windows1254Codec().name, 'windows-1254');
      // BaseEncoder.createEncodingMap(Windows1254Decoder().symbols, 0x7f);
    });
    test('Decoder/encoder classes', () {
      expect(const Windows1254Codec().encoder, isA<Windows1254Encoder>());
      expect(const Windows1254Codec().decoder, isA<Windows1254Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Windows1254Decoder().convert(bytes), 'hello world');
    });

    test('Decode Windows1254', () {
      expect(const Windows1254Decoder().convert([0xC4, 0xD6, 0xFC]), 'ÄÖü');
      final bytes =
          const Windows1254Encoder().convert('Tanıştığımıza memnun oldum!');
      expect(const Windows1254Decoder().convert(bytes),
          'Tanıştığımıza memnun oldum!');
    });

    test('Decode Windows1254 with invalid value when invalid input is allowed',
        () {
      expect(
          const Windows1254Decoder(allowInvalid: true)
              .convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ÄÖü�');
    });

    test(
        'Decode Windows1254 with invalid value when invalid input is not allowed',
        () {
      expect(
          () => const Windows1254Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Windows1254Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode Windows1254', () {
      var bytes = const Windows1254Encoder().convert('ÄÖü');
      expect(bytes, [0xC4, 0xD6, 0xFC]);
      bytes = const Windows1254Encoder().convert('Tanıştığımıza memnun oldum!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more Windows1254 ', () {
      const encoder = Windows1254Encoder();
      const decoder = Windows1254Decoder();
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

    test('encode Windows1254 with invalid value when invalid input is allowed',
        () {
      final bytes =
          const Windows1254Encoder(allowInvalid: true).convert('ÄÖü�');
      expect(const Windows1254Decoder().convert(bytes), 'ÄÖü?');
    });

    test(
        'encode Windows1254 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Windows1254Encoder().convert('ÄÖü�'),
          throwsA(isA<FormatException>()));
    });
  });
}
