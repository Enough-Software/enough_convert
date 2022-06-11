// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/enough_convert.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Latin15Codec().name, 'iso-8859-15');
      // print('latin 15 map:');
      // final isoSymbols =
      //     '¡¢£€¥Š§š©ª«¬\u{00AD}®¯°±²³Žµ¶·ž¹º»ŒœŸ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ';
      // LatinEncoder.createEncodingMap(isoSymbols);
    });
    test('Decoder/encoder classes', () {
      expect(const Latin15Codec().encoder, isA<Latin15Encoder>());
      expect(const Latin15Codec().decoder, isA<Latin15Decoder>());
      const dart_convert.Encoding encoding = Latin15Codec(allowInvalid: false);
      expect(encoding.encoder, isA<Latin15Encoder>());
      expect(encoding.decoder, isA<Latin15Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Latin15Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 15', () {
      final bytes =
          const Latin15Encoder().convert('Il faut être bête quand même.');
      expect(const Latin15Decoder().convert(bytes),
          'Il faut être bête quand même.');
    });

    test('Decode latin 15 with invalid value when invalid input is allowed',
        () {
      expect(
          const Latin15Decoder(allowInvalid: true).convert([0xC6, 0xE6, 0xFF1]),
          'Ææ�');
    });

    test('Decode latin 15 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin15Decoder().convert([0xC6, 0xE6, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Latin15Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode latin 15', () {
      final bytes =
          const Latin15Encoder().convert('Il faut être bête quand même.');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(
          bytes, const Latin15Codec().encode('Il faut être bête quand même.'));
      expect(
          bytes,
          const Latin15Codec(allowInvalid: true)
              .encode('Il faut être bête quand même.'));
      expect(
          bytes,
          const Latin15Codec(allowInvalid: false)
              .encode('Il faut être bête quand même.'));
    });

    test('encode more latin 15 ', () {
      const input =
          '¡¢£€¥Š§š©ª«¬\u{00AD}®¯°±²³Žµ¶·ž¹º»ŒœŸ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ';

      final bytes = const Latin15Encoder().convert(input);
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

    test('encode latin 15 with invalid value when invalid input is allowed',
        () {
      final bytes = const Latin15Encoder(allowInvalid: true)
          .convert('Il faut être bête quand même.�');
      expect(const Latin15Decoder().convert(bytes),
          'Il faut être bête quand même.?');
    });

    test('encode latin 15 with invalid value when invalid input is not allowed',
        () {
      expect(
          () =>
              const Latin15Encoder().convert('Il faut être bête quand même.�'),
          throwsA(isA<FormatException>()));
    });
  });
}
