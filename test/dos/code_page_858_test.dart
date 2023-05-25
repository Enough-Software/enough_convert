// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/enough_convert.dart';
// import 'package:enough_convert/src/base.dart';
import 'package:test/test.dart';

void main() {
  group('Euro sign', () {
    // This is the key test for this code page, whose only difference from 850
    // is the support for the euro sign (that replaces the "ı" character).
    test('encode euro sign', () {
      final bytes = const CodePage858Encoder().convert('€');
      expect(bytes, [0xD5]);
      expect(const CodePage858Decoder().convert(bytes), '€');
    });
  });

  group('Codec tests', () {
    test('name', () {
      expect(const CodePage858Codec().name, 'cp-858');
      // BaseEncoder.createEncodingMap(CodePage858Decoder().startBlock!, 0);
      // BaseEncoder.createEncodingMap(CodePage858Decoder().symbols, CodePage858Decoder().startIndex);
    });
    test('Decoder/encoder classes', () {
      expect(const CodePage858Codec().encoder, isA<CodePage858Encoder>());
      expect(const CodePage858Codec().decoder, isA<CodePage858Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const CodePage858Decoder().convert(bytes), 'hello world');
    });

    test('Decode cp-858', () {
      expect(
          const CodePage858Decoder().convert([0x0C, 0x0E, 0x7F, 0x9D]), '♀♫⌂Ø');
      final bytes = const CodePage858Encoder()
          .convert('hello world motörhead ruleß ok ô');
      expect(const CodePage858Decoder().convert(bytes),
          'hello world motörhead ruleß ok ô');
    });

    test('Decode cp-858 with invalid value when invalid input is allowed', () {
      expect(
          const CodePage858Decoder(allowInvalid: true)
              .convert([0x0C, 0x0E, 0x7F, 0x9D, 0xFF1]),
          '♀♫⌂Ø�');
    });

    test('Decode cp-858 with invalid value when invalid input is not allowed',
        () {
      expect(
          () => const CodePage858Decoder()
              .convert([0x0C, 0x0E, 0x7F, 0x9D, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const CodePage858Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode 858', () {
      var bytes = const CodePage858Encoder().convert('♫⌂Ø');
      expect(bytes, [0x0E, 0x7F, 0x9D]);
      bytes =
          const CodePage858Encoder().convert('hello world motörhead ruleß ok');
      expect(const CodePage858Decoder().convert(bytes),
          'hello world motörhead ruleß ok');

      bytes = const CodePage858Encoder()
          .convert('‼¶§▬abcABC┴┬├─┼ãÃ╚╔╩╦╠═╬¤ðÐÊËÈ€ÍÎÏ┘┌█▄');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more cp-858 ', () {
      var bytes = const CodePage858Encoder().convert(
          '⌂ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜø£Ø×ƒáíóúñÑªº¿®¬½¼¡«»░▒▓│┤ÁÂÀ©╣║╗╝¢¥┐└┴┬├─┼ãÃ╚╔╩╦╠═╬¤ðÐÊËÈ€ÍÎÏ┘┌█▄¦Ì▀ÓßÔÒõÕµþÞÚÛÙýÝ¯´\u{00AD}±‗¾¶§÷¸°¨·¹³²■\u{00A0}');
      var expected = List.generate(255 - 126, (index) => index + 127);
      expect(bytes, expected);

      bytes = const CodePage858Encoder().convert('íóúñÑªº¿®¬½¼¡«');
      expected = List.generate(0xAE - 0xA0, (index) => index + 0xA1);
      expect(bytes, expected);
    });

    test('encode cp-858 with invalid value when invalid input is allowed', () {
      final bytes =
          const CodePage858Encoder(allowInvalid: true).convert('ÄÖü�');
      expect(const CodePage858Decoder().convert(bytes), 'ÄÖü?');
    });

    test('encode cp-858 with invalid value when invalid input is not allowed',
        () {
      expect(() => const CodePage858Encoder().convert('ÄÖü�'),
          throwsA(isA<FormatException>()));
    });
  });
}
