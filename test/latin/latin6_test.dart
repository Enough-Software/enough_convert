// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/enough_convert.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Latin6Codec().name, 'iso-8859-6');
      // print('latin 6 map:');
      // LatinEncoder.createEncodingMap(
      //     '???¤???????،\u{00AD}?????????????؛???؟?ءآأؤإئابةتثجحخدذرزسشصضطظعغ?????ـفقكلمنهوىيًٌٍَُِّْ?????????????');
    });
    test('Decoder/encoder classes', () {
      expect(const Latin6Codec().encoder, isA<Latin6Encoder>());
      expect(const Latin6Codec().decoder, isA<Latin6Decoder>());
      const dart_convert.Encoding encoding = Latin6Codec(allowInvalid: false);
      expect(encoding.encoder, isA<Latin6Encoder>());
      expect(encoding.decoder, isA<Latin6Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Latin6Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 6', () {
      final bytes = const Latin6Encoder().convert('سعدت بلقائك');
      expect(const Latin6Decoder().convert(bytes), 'سعدت بلقائك');
    });

    test('Decode latin 6 with invalid value when invalid input is allowed', () {
      expect(
          const Latin6Decoder(allowInvalid: true).convert([0xC4, 0xD6, 0xFF1]),
          'ؤض�');
    });

    test('Decode latin 6 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin6Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Latin6Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode latin 6', () {
      final bytes = const Latin6Encoder().convert('سعدت بلقائك');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(bytes, const Latin6Codec().encode('سعدت بلقائك'));
      expect(
          bytes, const Latin6Codec(allowInvalid: true).encode('سعدت بلقائك'));
      expect(
          bytes, const Latin6Codec(allowInvalid: false).encode('سعدت بلقائك'));
    });

    test('encode more latin 6 ', () {
      const input =
          '???¤???????،\u{00AD}?????????????؛???؟?ءآأؤإئابةتثجحخدذرزسشصضطظعغ?????ـفقكلمنهوىيًٌٍَُِّْ?????????????';
      final bytes = const Latin6Encoder().convert(input);
      final expected = List.generate(95, (index) => index + 0xA1);
      for (var i = 0; i < input.length; i++) {
        if (input.codeUnitAt(i) == 0x3F) {
          // ?
          expected[i] = 0x3F;
        }
      }
      expect(bytes, expected);
    });

    test('encode latin 6 with invalid value when invalid input is allowed', () {
      final bytes =
          const Latin6Encoder(allowInvalid: true).convert('سعدت بلقائك�');
      expect(const Latin6Decoder().convert(bytes), 'سعدت بلقائك?');
    });

    test('encode latin 6 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin6Encoder().convert('سعدت بلقائك�'),
          throwsA(isA<FormatException>()));
    });
  });
}
