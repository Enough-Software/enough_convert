// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/enough_convert.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Latin5Codec().name, 'iso-8859-5');
      // print('latin 5 map:');
      // LatinEncoder.createEncodingMap(
      //     'ЁЂЃЄЅІЇЈЉЊЋЌ\u{00AD}ЎЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя№ёђѓєѕіїјљњћќ§ўџ');
    });
    test('Decoder/encoder classes', () {
      expect(const Latin5Codec().encoder, isA<Latin5Encoder>());
      expect(const Latin5Codec().decoder, isA<Latin5Decoder>());
      const dart_convert.Encoding encoding = Latin5Codec(allowInvalid: false);
      expect(encoding.encoder, isA<Latin5Encoder>());
      expect(encoding.decoder, isA<Latin5Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Latin5Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 5', () {
      final bytes = const Latin5Encoder().convert('Приятно встретиться!');
      expect(const Latin5Decoder().convert(bytes), 'Приятно встретиться!');
    });

    test('Decode latin 5 with invalid value when invalid input is allowed', () {
      expect(
          const Latin5Decoder(allowInvalid: true)
              .convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'Фжќ�');
    });

    test('Decode latin 5 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin5Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Latin5Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode latin 5', () {
      final bytes = const Latin5Encoder().convert('Приятно встретиться!');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(bytes, const Latin5Codec().encode('Приятно встретиться!'));
      expect(bytes,
          const Latin5Codec(allowInvalid: true).encode('Приятно встретиться!'));
      expect(
          bytes,
          const Latin5Codec(allowInvalid: false)
              .encode('Приятно встретиться!'));
    });

    test('encode more latin 5 ', () {
      const input =
          'ЁЂЃЄЅІЇЈЉЊЋЌ\u{00AD}ЎЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя№ёђѓєѕіїјљњћќ§ўџ';
      final bytes = const Latin5Encoder().convert(input);
      final expected = List.generate(95, (index) => index + 0xA1);
      for (var i = 0; i < input.length; i++) {
        if (input.codeUnitAt(i) == 0x3F) {
          // ?
          expected[i] = 0x3F;
        }
      }
      expect(bytes, expected);
    });

    test('encode latin 5 with invalid value when invalid input is allowed', () {
      final bytes = const Latin5Encoder(allowInvalid: true).convert('Фжќ�');
      expect(const Latin5Decoder().convert(bytes), 'Фжќ?');
    });

    test('encode latin 5 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin5Encoder().convert('Фжќ�'),
          throwsA(isA<FormatException>()));
    });
  });
}
