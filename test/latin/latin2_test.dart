import 'dart:convert' as convert;

import 'package:enough_convert/latin/latin2.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Latin2Codec().name, 'iso-8859-2');
    });
    test('Decoder/encoder classes', () {
      expect(Latin2Codec().encoder, isA<Latin2Encoder>());
      expect(Latin2Codec().decoder, isA<Latin2Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Latin2Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 2', () {
      expect(Latin2Decoder().convert([0xC4, 0xD6, 0xFC]), 'ÄÖü');
      final bytes = Latin2Encoder().convert('hello world motörhead ruleß ok ô');
      expect(
          Latin2Decoder().convert(bytes), 'hello world motörhead ruleß ok ô');
    });

    test('Decode latin 2 with invalid value when invalid input is allowed', () {
      expect(
          Latin2Decoder(allowInvalid: true).convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ÄÖü�');
    });

    test('Decode latin 2 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin2Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Latin2Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode latin 2', () {
      var bytes = Latin2Encoder().convert('ÄÖü');
      expect(bytes, [0xC4, 0xD6, 0xFC]);
      bytes = Latin2Encoder().convert('hello world motörhead ruleß ok');

      /// this works because umlauts are at the same position as in latin-1
      expect(bytes, convert.latin1.encode('hello world motörhead ruleß ok'));

      bytes = Latin2Encoder().convert('Těší mě, že vás poznávám!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more latin 2 ', () {
      var bytes = Latin2Encoder().convert(
          'ŽŻ°ą˛ł´ľśˇ¸šşťź˝žżŔÁÂĂÄĹĆÇČÉĘËĚÍÎĎĐŃŇÓÔŐÖ×ŘŮÚŰÜÝŢßŕáâăäĺćçčéęëěíîďđńňóôőö÷řůúűüýţ˙');
      var expected = List.generate(0xFF - 0xAD, (index) => index + 0xAE);
      expect(bytes, expected);

      bytes = Latin2Encoder().convert('Ą˘Ł¤ĽŚ§¨ŠŞŤŹ\u{00AD}');
      expected = List.generate(0xAE - 0xA1, (index) => index + 0xA1);
      expect(bytes, expected);
    });

    test('encode latin 2 with invalid value when invalid input is allowed', () {
      var bytes = Latin2Encoder(allowInvalid: true).convert('ÄÖü�');
      expect(Latin2Decoder().convert(bytes), 'ÄÖü?');
    });

    test('encode latin 2 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin2Encoder().convert('ÄÖü�'),
          throwsA(isA<FormatException>()));
    });
  });
}
