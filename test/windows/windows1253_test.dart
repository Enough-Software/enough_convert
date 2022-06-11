// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/windows/windows1253.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Windows1253Codec().name, 'windows-1253');
      // BaseEncoder.createEncodingMap(Windows1253Decoder().symbols, 0x7f);
    });
    test('Decoder/encoder classes', () {
      expect(const Windows1253Codec().encoder, isA<Windows1253Encoder>());
      expect(const Windows1253Codec().decoder, isA<Windows1253Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Windows1253Decoder().convert(bytes), 'hello world');
    });

    test('Decode Windows1253', () {
      expect(const Windows1253Decoder().convert([0xC4, 0xD6, 0xFC]), 'ΔΦό');
      final bytes =
          const Windows1253Encoder().convert('Χαίρομαι που σας γνωρίζω!');
      expect(const Windows1253Decoder().convert(bytes),
          'Χαίρομαι που σας γνωρίζω!');
    });

    test('Decode Windows1253 with invalid value when invalid input is allowed',
        () {
      expect(
          const Windows1253Decoder(allowInvalid: true)
              .convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ΔΦό�');
    });

    test(
        'Decode Windows1253 with invalid value when invalid input is not allowed',
        () {
      expect(
          () => const Windows1253Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Windows1253Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode Windows1253', () {
      var bytes = const Windows1253Encoder().convert('ΔΦό');
      expect(bytes, [0xC4, 0xD6, 0xFC]);
      bytes = const Windows1253Encoder().convert('Χαίρομαι που σας γνωρίζω!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more Windows1253', () {
      const encoder = Windows1253Encoder();
      const decoder = Windows1253Decoder();
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

    test('encode Windows1253 with invalid value when invalid input is allowed',
        () {
      final bytes =
          const Windows1253Encoder(allowInvalid: true).convert('ΔΦό�');
      expect(const Windows1253Decoder().convert(bytes), 'ΔΦό?');
    });

    test(
        'encode Windows1253 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Windows1253Encoder().convert('ΔΦό�'),
          throwsA(isA<FormatException>()));
    });
  });
}
