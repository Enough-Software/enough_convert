// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/enough_convert.dart';
// import 'package:enough_convert/src/base.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const CodePage850Codec().name, 'cp-850');
      // BaseEncoder.createEncodingMap(CodePage850Decoder().startBlock!, 0);
      // BaseEncoder.createEncodingMap(CodePage850Decoder().symbols, CodePage850Decoder().startIndex);
    });
    test('Decoder/encoder classes', () {
      expect(const CodePage850Codec().encoder, isA<CodePage850Encoder>());
      expect(const CodePage850Codec().decoder, isA<CodePage850Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const CodePage850Decoder().convert(bytes), 'hello world');
    });

    test('Decode cp-850', () {
      expect(
          const CodePage850Decoder().convert([0x0C, 0x0E, 0x7F, 0x9D]), '♀♫⌂Ø');
      final bytes = const CodePage850Encoder()
          .convert('hello world motörhead ruleß ok ô');
      expect(const CodePage850Decoder().convert(bytes),
          'hello world motörhead ruleß ok ô');
    });

    test('Decode cp-850 with invalid value when invalid input is allowed', () {
      expect(
          const CodePage850Decoder(allowInvalid: true)
              .convert([0x0C, 0x0E, 0x7F, 0x9D, 0xFF1]),
          '♀♫⌂Ø�');
    });

    test('Decode cp-850 with invalid value when invalid input is not allowed',
        () {
      expect(
          () => const CodePage850Decoder()
              .convert([0x0C, 0x0E, 0x7F, 0x9D, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const CodePage850Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode 850', () {
      var bytes = const CodePage850Encoder().convert('♫⌂Ø');
      expect(bytes, [0x0E, 0x7F, 0x9D]);
      bytes =
          const CodePage850Encoder().convert('hello world motörhead ruleß ok');
      expect(const CodePage850Decoder().convert(bytes),
          'hello world motörhead ruleß ok');

      bytes = const CodePage850Encoder()
          .convert('‼¶§▬abcABC┴┬├─┼ãÃ╚╔╩╦╠═╬¤ðÐÊËÈıÍÎÏ┘┌█▄');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more cp-850 ', () {
      var bytes = const CodePage850Encoder().convert(
          '⌂ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜø£Ø×ƒáíóúñÑªº¿®¬½¼¡«»░▒▓│┤ÁÂÀ©╣║╗╝¢¥┐└┴┬├─┼ãÃ╚╔╩╦╠═╬¤ðÐÊËÈıÍÎÏ┘┌█▄¦Ì▀ÓßÔÒõÕµþÞÚÛÙýÝ¯´\u{00AD}±‗¾¶§÷¸°¨·¹³²■\u{00A0}');
      var expected = List.generate(255 - 126, (index) => index + 127);
      expect(bytes, expected);

      bytes = const CodePage850Encoder().convert('íóúñÑªº¿®¬½¼¡«');
      expected = List.generate(0xAE - 0xA0, (index) => index + 0xA1);
      expect(bytes, expected);
    });

    test('encode cp-850 with invalid value when invalid input is allowed', () {
      final bytes =
          const CodePage850Encoder(allowInvalid: true).convert('ÄÖü�');
      expect(const CodePage850Decoder().convert(bytes), 'ÄÖü?');
    });

    test('encode cp-850 with invalid value when invalid input is not allowed',
        () {
      expect(() => const CodePage850Encoder().convert('ÄÖü�'),
          throwsA(isA<FormatException>()));
    });
  });
}
