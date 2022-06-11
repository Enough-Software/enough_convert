// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/enough_convert.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Koi8rCodec().name, 'KOI8-R');
    });
    test('Decoder/encoder classes', () {
      expect(const Koi8rCodec().encoder, isA<Koi8rEncoder>());
      expect(const Koi8rCodec().decoder, isA<Koi8rDecoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Koi8rDecoder().convert(bytes), 'hello world');
    });

    test('Decode koi8-r', () {
      expect(const Koi8rDecoder().convert([0xF1, 0xD4, 0xC0]), 'Ятю');
      final bytes = const Koi8rEncoder().convert('Я работаю and me too! ёёё!');
      expect(const Koi8rDecoder().convert(bytes), 'Я работаю and me too! ёёё!');
    });

    test('Decode koi8-r with invalid value when invalid input is allowed', () {
      expect(
          const Koi8rDecoder(allowInvalid: true)
              .convert([0xF1, 0xD4, 0xC0, 0xFF1]),
          'Ятю�');
    });

    test('Decode koi8-r with invalid value when invalid input is not allowed',
        () {
      expect(() => const Koi8rDecoder().convert([0xF1, 0xD4, 0xC0, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Koi8rEncoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode koi8-r', () {
      var bytes = const Koi8rEncoder().convert('Ятю');
      expect(bytes, [0xF1, 0xD4, 0xC0]);

      bytes = const Koi8rEncoder().convert('Ласково приветствую вас!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more koi8-r ', () {
      final bytes = const Koi8rEncoder().convert(
          '─│┌┐└┘├┤┬┴┼▀▄█▌▐░▒▓⌠■∙√≈≤≥\u{00A0}⌡°²·÷═║╒ё╓╔╕╖╗╘╙╚╛╜╝╞╟╠╡Ё╢╣╤╥╦╧╨╩╪╫╬©юабцдефгхийклмнопярстужвьызшэщчъЮАБЦДЕФГХИЙКЛМНОПЯРСТУЖВЬЫЗШЭЩЧЪ');
      final expected = List.generate(0xFF - 0x7F, (index) => index + 0x80);
      expect(bytes, expected);
    });

    test('encode koi8-r with invalid value when invalid input is allowed', () {
      final bytes = const Koi8rEncoder(allowInvalid: true).convert('Ятю�');
      expect(const Koi8rDecoder().convert(bytes), 'Ятю?');
    });

    test('encode koi8-r with invalid value when invalid input is not allowed',
        () {
      expect(() => const Koi8rEncoder().convert('Ятю�'),
          throwsA(isA<FormatException>()));
    });
  });
}
