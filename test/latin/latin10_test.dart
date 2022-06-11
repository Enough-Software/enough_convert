// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/enough_convert.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Latin10Codec().name, 'iso-8859-10');
      // print('latin 10 map:');
      // final isoSymbols =
      //     'ĄĒĢĪĨĶ§ĻĐŠŦŽ\u{00AD}ŪŊ°ąēģīĩķ·ļđšŧž―ūŋĀÁÂÃÄÅÆĮČÉĘËĖÍÎÏÐŅŌÓÔÕÖŨØŲÚÛÜÝÞßāáâãäåæįčéęëėíîïðņōóôõöũøųúûüýþĸ';
      // LatinEncoder.createEncodingMap(isoSymbols);
    });
    test('Decoder/encoder classes', () {
      expect(const Latin10Codec().encoder, isA<Latin10Encoder>());
      expect(const Latin10Codec().decoder, isA<Latin10Decoder>());
      const dart_convert.Encoding encoding = Latin10Codec(allowInvalid: false);
      expect(encoding.encoder, isA<Latin10Encoder>());
      expect(encoding.decoder, isA<Latin10Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Latin10Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 10', () {
      final bytes = const Latin10Encoder().convert('Hyggelig å møte deg!');
      expect(const Latin10Decoder().convert(bytes), 'Hyggelig å møte deg!');
    });

    test('Decode latin 10 with invalid value when invalid input is allowed',
        () {
      expect(
          const Latin10Decoder(allowInvalid: true).convert([0xC6, 0xE6, 0xFF1]),
          'Ææ�');
    });

    test('Decode latin 10 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin10Decoder().convert([0xC6, 0xE6, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Latin10Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode latin 10', () {
      final bytes = const Latin10Encoder().convert('Hyggelig å møte deg!');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(bytes, const Latin10Codec().encode('Hyggelig å møte deg!'));
      expect(
          bytes,
          const Latin10Codec(allowInvalid: true)
              .encode('Hyggelig å møte deg!'));
      expect(
          bytes,
          const Latin10Codec(allowInvalid: false)
              .encode('Hyggelig å møte deg!'));
    });

    test('encode more latin 10 ', () {
      const input =
          'ĄĒĢĪĨĶ§ĻĐŠŦŽ\u{00AD}ŪŊ°ąēģīĩķ·ļđšŧž―ūŋĀÁÂÃÄÅÆĮČÉĘËĖÍÎÏÐŅŌÓÔÕÖŨØŲÚÛÜÝÞßāáâãäåæįčéęëėíîïðņōóôõöũøųúûüýþĸ';

      final bytes = const Latin10Encoder().convert(input);
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

    test('encode latin 10 with invalid value when invalid input is allowed',
        () {
      final bytes = const Latin10Encoder(allowInvalid: true)
          .convert('Hyggelig å møte deg!�');
      expect(const Latin10Decoder().convert(bytes), 'Hyggelig å møte deg!?');
    });

    test('encode latin 10 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin10Encoder().convert('Hyggelig å møte deg!�'),
          throwsA(isA<FormatException>()));
    });
  });
}
