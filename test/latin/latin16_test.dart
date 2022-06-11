// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/enough_convert.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Latin16Codec().name, 'iso-8859-16');
      // print('latin 16 map:');
      // final isoSymbols =
      //     'ĄąŁ€„Š§š©Ș«Ź\u{00AD}źŻ°±ČłŽ”¶·žčș»ŒœŸżÀÁÂĂÄĆÆÇÈÉÊËÌÍÎÏĐŃÒÓÔŐÖŚŰÙÚÛÜĘȚßàáâăäćæçèéêëìíîïđńòóôőöśűùúûüęțÿ';
      // LatinEncoder.createEncodingMap(isoSymbols);
    });
    test('Decoder/encoder classes', () {
      expect(const Latin16Codec().encoder, isA<Latin16Encoder>());
      expect(const Latin16Codec().decoder, isA<Latin16Decoder>());
      const dart_convert.Encoding encoding = Latin16Codec(allowInvalid: false);
      expect(encoding.encoder, isA<Latin16Encoder>());
      expect(encoding.decoder, isA<Latin16Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Latin16Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 16', () {
      final bytes =
          const Latin16Encoder().convert('Örülök, hogy találkoztunk!');
      expect(
          const Latin16Decoder().convert(bytes), 'Örülök, hogy találkoztunk!');
    });

    test('Decode latin 16 with invalid value when invalid input is allowed',
        () {
      expect(
          const Latin16Decoder(allowInvalid: true).convert([0xC6, 0xE6, 0xFF1]),
          'Ææ�');
    });

    test('Decode latin 16 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin16Decoder().convert([0xC6, 0xE6, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Latin16Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode latin 16', () {
      final bytes =
          const Latin16Encoder().convert('Örülök, hogy találkoztunk!');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(bytes, const Latin16Codec().encode('Örülök, hogy találkoztunk!'));
      expect(
          bytes,
          const Latin16Codec(allowInvalid: true)
              .encode('Örülök, hogy találkoztunk!'));
      expect(
          bytes,
          const Latin16Codec(allowInvalid: false)
              .encode('Örülök, hogy találkoztunk!'));
    });

    test('encode more latin 16 ', () {
      const input =
          'ĄąŁ€„Š§š©Ș«Ź\u{00AD}źŻ°±ČłŽ”¶·žčș»ŒœŸżÀÁÂĂÄĆÆÇÈÉÊËÌÍÎÏĐŃÒÓÔŐÖŚŰÙÚÛÜĘȚßàáâăäćæçèéêëìíîïđńòóôőöśűùúûüęțÿ';

      final bytes = const Latin16Encoder().convert(input);
      final expected = List.generate(95, (index) => index + 0xA1);
      // print(
      //     'input.length=${input.length} bytes.length=${bytes.length} expected.length=${expected.length}');
      for (var i = 0; i < input.length; i++) {
        if (input.codeUnitAt(i) == 0x3F) {
          // ?
          expected[i] = 0x3F;
        }
      }
      expect(bytes, expected);
    });

    test('encode latin 16 with invalid value when invalid input is allowed',
        () {
      final bytes = const Latin16Encoder(allowInvalid: true)
          .convert('Örülök, hogy találkoztunk!�');
      expect(
          const Latin16Decoder().convert(bytes), 'Örülök, hogy találkoztunk!?');
    });

    test('encode latin 16 with invalid value when invalid input is not allowed',
        () {
      expect(
          () => const Latin16Encoder().convert('Örülök, hogy találkoztunk!�'),
          throwsA(isA<FormatException>()));
    });
  });
}
