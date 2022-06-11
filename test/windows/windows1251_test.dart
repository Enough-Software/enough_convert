// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/windows/windows1251.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Windows1251Codec().name, 'windows-1251');
      // BaseEncoder.createEncodingMap(Windows1251Decoder().symbols, 0x7f);
    });
    test('Decoder/encoder classes', () {
      expect(const Windows1251Codec().encoder, isA<Windows1251Encoder>());
      expect(const Windows1251Codec().decoder, isA<Windows1251Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Windows1251Decoder().convert(bytes), 'hello world');
    });

    test('Decode Windows1251', () {
      expect(const Windows1251Decoder().convert([0xC4, 0xD6, 0xFC]), 'ДЦь');
      final bytes =
          const Windows1251Encoder().convert('Радий познайомитися з Вами!');
      expect(const Windows1251Decoder().convert(bytes),
          'Радий познайомитися з Вами!');
    });

    test('Decode Windows1251 with invalid value when invalid input is allowed',
        () {
      expect(
          const Windows1251Decoder(allowInvalid: true)
              .convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ДЦь�');
    });

    test(
        'Decode Windows1251 with invalid value when invalid input is not allowed',
        () {
      expect(
          () => const Windows1251Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Windows1251Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode Windows1251', () {
      final bytes =
          const Windows1251Encoder().convert('Радий познайомитися з Вами!');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(const Windows1251Decoder().convert(bytes),
          'Радий познайомитися з Вами!');
    });

    test('encode more Windows1251 ', () {
      const encoder = Windows1251Encoder();
      const decoder = Windows1251Decoder();
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

    test('encode Windows1251 with invalid value when invalid input is allowed',
        () {
      final bytes = const Windows1251Encoder(allowInvalid: true).convert('йз�');
      expect(const Windows1251Decoder().convert(bytes), 'йз?');
    });

    test(
        'encode Windows1251 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Windows1251Encoder().convert('йз�'),
          throwsA(isA<FormatException>()));
    });
  });
}
