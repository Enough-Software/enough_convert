import 'dart:convert' as convert;

import 'package:enough_convert/latin/latin1.dart';
import 'package:test/test.dart';

void main() {
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Latin1Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 1', () {
      expect(Latin1Decoder().convert([0xC4, 0xD6, 0xFC]), 'ÄÖü');
      final bytes = convert.latin1.encode('hello world motörhead ruleß ok ÿñô');
      expect(
          Latin1Decoder().convert(bytes), 'hello world motörhead ruleß ok ÿñô');
    });

    test('Decode latin 1 with invalid value when invalid input is allowed', () {
      expect(
          Latin1Decoder(allowInvalid: true).convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ÄÖü�');
    });

    test('Decode latin 1 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin1Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Latin1Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode latin 1', () {
      var bytes = Latin1Encoder().convert('ÄÖü');
      expect(bytes, convert.latin1.encode('ÄÖü'));
      bytes = Latin1Encoder().convert('hello world motörhead ruleß ok ÿñô');
      expect(
          bytes, convert.latin1.encode('hello world motörhead ruleß ok ÿñô'));
    });

    test('encode latin 1 with invalid value when invalid input is allowed', () {
      var bytes = Latin1Encoder(allowInvalid: true).convert('ÄÖü�');
      expect(Latin1Decoder().convert(bytes), 'ÄÖü?');
    });

    test('encode latin 1 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin1Encoder().convert('ÄÖü�'),
          throwsA(isA<FormatException>()));
    });
  });
}
