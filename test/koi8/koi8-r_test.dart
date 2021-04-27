import 'dart:convert' as convert;

import 'package:enough_convert/koi8/koi8-r.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Koi8rCodec().name, 'KOI8-R');
    });
    test('Decoder/encoder classes', () {
      expect(Koi8rCodec().encoder, isA<Koi8rEncoder>());
      expect(Koi8rCodec().decoder, isA<Koi8rDecoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Koi8rDecoder().convert(bytes), 'hello world');
    });

    test('Decode koi8-r', () {
      expect(Koi8rDecoder().convert([0xF1, 0xD4, 0xC0]), 'Ятю');
      final bytes = Koi8rEncoder().convert('Я работаю and me too! ёёё!');
      expect(Koi8rDecoder().convert(bytes), 'Я работаю and me too! ёёё!');
    });

    test('Decode koi8-r with invalid value when invalid input is allowed', () {
      expect(
          Koi8rDecoder(allowInvalid: true).convert([0xF1, 0xD4, 0xC0, 0xFF1]),
          'Ятю�');
    });

    test('Decode koi8-r with invalid value when invalid input is not allowed',
        () {
      expect(() => Koi8rDecoder().convert([0xF1, 0xD4, 0xC0, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Koi8rEncoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode koi8-r', () {
      var bytes = Koi8rEncoder().convert('Ятю');
      expect(bytes, [0xF1, 0xD4, 0xC0]);

      bytes = Koi8rEncoder().convert('Ласково приветствую вас!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more koi8-r ', () {
      var bytes = Koi8rEncoder().convert(
          'ё╓╔╕╖╗╘╙╚╛╜╝╞╟╠╡Ё╢╣╤╥╦╧╨╩╪╫╬©юабцдефгхийклмнопярстужвьызшэщчъЮАБЦДЕФГХИЙКЛМНОПЯРСТУЖВЬЫЗШЭЩЧЪ');
      var expected = List.generate(0xFF - 0xA2, (index) => index + 0xA3);
      expect(bytes, expected);
    });

    test('encode koi8-r with invalid value when invalid input is allowed', () {
      var bytes = Koi8rEncoder(allowInvalid: true).convert('Ятю�');
      expect(Koi8rDecoder().convert(bytes), 'Ятю?');
    });

    test('encode koi8-r with invalid value when invalid input is not allowed',
        () {
      expect(() => Koi8rEncoder().convert('Ятю�'),
          throwsA(isA<FormatException>()));
    });
  });
}
