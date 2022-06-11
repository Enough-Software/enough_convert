// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/latin/latin9.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Latin9Codec().name, 'iso-8859-9');
      // print('latin 9 map:');
      // final isoSymbols =
      //     '¡¢£¤¥¦§¨©ª«¬\u{00AD}®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿ';
      // LatinEncoder.createEncodingMap(isoSymbols);
    });
    test('Decoder/encoder classes', () {
      expect(const Latin9Codec().encoder, isA<Latin9Encoder>());
      expect(const Latin9Codec().decoder, isA<Latin9Decoder>());
      const dart_convert.Encoding encoding = Latin9Codec(allowInvalid: false);
      expect(encoding.encoder, isA<Latin9Encoder>());
      expect(encoding.decoder, isA<Latin9Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Latin9Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 9', () {
      final bytes =
          const Latin9Encoder().convert('Tanıştığımıza memnun oldum!');
      expect(
          const Latin9Decoder().convert(bytes), 'Tanıştığımıza memnun oldum!');
    });

    test('Decode latin 9 with invalid value when invalid input is allowed', () {
      expect(
          const Latin9Decoder(allowInvalid: true).convert([0xC4, 0xD9, 0xFF1]),
          'ÄÙ�');
    });

    test('Decode latin 9 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin9Decoder().convert([0xC4, 0xD9, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Latin9Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode latin 9', () {
      final bytes =
          const Latin9Encoder().convert('Tanıştığımıza memnun oldum!');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(bytes, const Latin9Codec().encode('Tanıştığımıza memnun oldum!'));
      expect(
          bytes,
          const Latin9Codec(allowInvalid: true)
              .encode('Tanıştığımıza memnun oldum!'));
      expect(
          bytes,
          const Latin9Codec(allowInvalid: false)
              .encode('Tanıştığımıza memnun oldum!'));
    });

    test('encode more latin 9 ', () {
      const input =
          '¡¢£¤¥¦§¨©ª«¬\u{00AD}®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿ';

      final bytes = const Latin9Encoder().convert(input);
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

    test('encode latin 9 with invalid value when invalid input is allowed', () {
      final bytes = const Latin9Encoder(allowInvalid: true)
          .convert('Tanıştığımıza memnun oldum!�');
      expect(
          const Latin9Decoder().convert(bytes), 'Tanıştığımıza memnun oldum!?');
    });

    test('encode latin 9 with invalid value when invalid input is not allowed',
        () {
      expect(
          () => const Latin9Encoder().convert('Tanıştığımıza memnun oldum!�'),
          throwsA(isA<FormatException>()));
    });
  });
}
