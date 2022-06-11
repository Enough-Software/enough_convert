// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/enough_convert.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Big5Codec().name, 'Big5');
    });
    test('Decoder/encoder classes', () {
      expect(const Big5Codec().encoder, isA<Big5Encoder>());
      expect(const Big5Codec().decoder, isA<Big5Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Big5Decoder().convert(bytes), 'hello world');
    });

    test('Decode big5', () {
      expect(
          const Big5Decoder().convert(
              [0x00D6, 0x00F7, 0x00D2, 0x00B3, 0x00B8, 0x00C5, 0x00BF, 0x00F6]),
          '翋珜衙錶');
      final bytes = const Big5Encoder().convert('傳統');
      expect(const Big5Decoder().convert(bytes), '傳統');
    });

    test('Decode big5 with invalid value when invalid input is allowed', () {
      expect(
          const Big5Decoder(allowInvalid: true).convert([
            0x00D6,
            0x00F7,
            0x00D2,
            0x00B3,
            0x00B8,
            0x00C5,
            0x00BF,
            0x00F6,
            0xFFFF
          ]),
          '翋珜衙錶�');
    });

    test('Decode big5 with invalid value when invalid input is not allowed',
        () {
      expect(
          () => const Big5Decoder().convert([
                0x00D6,
                0x00F7,
                0x00D2,
                0x00B3,
                0x00B8,
                0x00C5,
                0x00BF,
                0x00F6,
                0xFFFF
              ]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Big5Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode big5', () {
      var bytes = const Big5Encoder().convert('傳統');
      expect(bytes, [182, 199, 178, 206]);

      bytes = const Big5Encoder().convert('翋珜衙錶');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode big5 with invalid value when invalid input is allowed', () {
      final bytes = const Big5Encoder(allowInvalid: true).convert('錶�');
      expect(const Big5Decoder().convert(bytes), '錶?');
    });

    test('encode big5 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Big5Encoder().convert('翋珜衙錶�'),
          throwsA(isA<FormatException>()));
    });
  });
}
