import 'dart:convert' as convert;

import 'package:enough_convert/koi8/koi8-u.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Koi8uCodec().name, 'KOI8-U');
    });
    test('Decoder/encoder classes', () {
      expect(Koi8uCodec().encoder, isA<Koi8uEncoder>());
      expect(Koi8uCodec().decoder, isA<Koi8uDecoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Koi8uDecoder().convert(bytes), 'hello world');
    });

    test('Decode koi8-u', () {
      expect(Koi8uDecoder().convert([0xF1, 0xD4, 0xC0]), 'Ятю');
      final bytes = Koi8uEncoder().convert('Я работаю and me too! ёёё!');
      expect(Koi8uDecoder().convert(bytes), 'Я работаю and me too! ёёё!');
    });

    test('Decode koi8-u with invalid value when invalid input is allowed', () {
      expect(
          Koi8uDecoder(allowInvalid: true).convert([0xF1, 0xD4, 0xC0, 0xFF1]),
          'Ятю�');
    });

    test('Decode koi8-u with invalid value when invalid input is not allowed',
        () {
      expect(() => Koi8uDecoder().convert([0xF1, 0xD4, 0xC0, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Koi8uEncoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode koi8-u', () {
      var bytes = Koi8uEncoder().convert('Ятю');
      expect(bytes, [0xF1, 0xD4, 0xC0]);

      bytes = Koi8uEncoder().convert('Ласково приветствую вас!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more koi8-u ', () {
      var bytes = Koi8uEncoder().convert(
          '─│┌┐└┘├┤┬┴┼▀▄█▌▐░▒▓⌠■∙√≈≤≥\u{00A0}⌡°²·÷═║╒ёє╔ії╗╘╙╚╛ґ╝╞╟╠╡ЁЄ╣ІЇ╦╧╨╩╪Ґ╬©юабцдефгхийклмнопярстужвьызшэщчъЮАБЦДЕФГХИЙКЛМНОПЯРСТУЖВЬЫЗШЭЩЧЪ');
      var expected = List.generate(0xFF - 0x7F, (index) => index + 0x80);
      expect(bytes, expected);
    });

    test('encode koi8-u with invalid value when invalid input is allowed', () {
      var bytes = Koi8uEncoder(allowInvalid: true).convert('Ятю�');
      expect(Koi8uDecoder().convert(bytes), 'Ятю?');
    });

    test('encode koi8-u with invalid value when invalid input is not allowed',
        () {
      expect(() => Koi8uEncoder().convert('Ятю�'),
          throwsA(isA<FormatException>()));
    });
  });
}
