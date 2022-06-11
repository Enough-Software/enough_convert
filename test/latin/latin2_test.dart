// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/enough_convert.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Latin2Codec().name, 'iso-8859-2');
    });
    test('Decoder/encoder classes', () {
      expect(const Latin2Codec().encoder, isA<Latin2Encoder>());
      expect(const Latin2Codec().decoder, isA<Latin2Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Latin2Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 2', () {
      expect(const Latin2Decoder().convert([0xC4, 0xD6, 0xFC]), 'ÄÖü');
      final bytes =
          const Latin2Encoder().convert('hello world motörhead ruleß ok ô');
      expect(const Latin2Decoder().convert(bytes),
          'hello world motörhead ruleß ok ô');
    });

    test('Decode latin 2 with invalid value when invalid input is allowed', () {
      expect(
          const Latin2Decoder(allowInvalid: true)
              .convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ÄÖü�');
    });

    test('Decode latin 2 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin2Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Latin2Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode latin 2', () {
      var bytes = const Latin2Encoder().convert('ÄÖü');
      expect(bytes, [0xC4, 0xD6, 0xFC]);
      bytes = const Latin2Encoder().convert('hello world motörhead ruleß ok');

      /// this works because umlauts are at the same position as in latin-1
      expect(
          bytes, dart_convert.latin1.encode('hello world motörhead ruleß ok'));

      bytes = const Latin2Encoder().convert('Těší mě, že vás poznávám!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more latin 2 ', () {
      var bytes = const Latin2Encoder().convert(
          'ŽŻ°ą˛ł´ľśˇ¸šşťź˝žżŔÁÂĂÄĹĆÇČÉĘËĚÍÎĎĐŃŇÓÔŐÖ×ŘŮÚŰÜÝŢßŕáâăäĺćçčéęëěíîďđńňóôőö÷řůúűüýţ˙');
      var expected = List.generate(0xFF - 0xAD, (index) => index + 0xAE);
      expect(bytes, expected);

      bytes = const Latin2Encoder().convert('Ą˘Ł¤ĽŚ§¨ŠŞŤŹ\u{00AD}');
      expected = List.generate(0xAE - 0xA1, (index) => index + 0xA1);
      expect(bytes, expected);
    });

    test('encode latin 2 with invalid value when invalid input is allowed', () {
      final bytes = const Latin2Encoder(allowInvalid: true).convert('ÄÖü�');
      expect(const Latin2Decoder().convert(bytes), 'ÄÖü?');
    });

    test('encode latin 2 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin2Encoder().convert('ÄÖü�'),
          throwsA(isA<FormatException>()));
    });
  });
}
