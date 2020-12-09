import 'dart:convert' as convert;

//import 'package:enough_convert/latin/latin.dart';
import 'package:enough_convert/latin/latin5.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Latin5Codec().name, 'iso-8859-5');
      // print('latin 5 map:');
      // LatinEncoder.createEncodingMap(
      //     'ЁЂЃЄЅІЇЈЉЊЋЌ\u{00AD}ЎЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя№ёђѓєѕіїјљњћќ§ўџ');
    });
    test('Decoder/encoder classes', () {
      expect(Latin5Codec().encoder, isA<Latin5Encoder>());
      expect(Latin5Codec().decoder, isA<Latin5Decoder>());
      convert.Encoding encoding = const Latin5Codec(allowInvalid: false);
      expect(encoding.encoder, isA<Latin5Encoder>());
      expect(encoding.decoder, isA<Latin5Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Latin5Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 5', () {
      final bytes = const Latin5Encoder().convert('Приятно встретиться!');
      expect(const Latin5Decoder().convert(bytes), 'Приятно встретиться!');
    });

    test('Decode latin 5 with invalid value when invalid input is allowed', () {
      expect(
          Latin5Decoder(allowInvalid: true).convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'Фжќ�');
    });

    test('Decode latin 5 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin5Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Latin5Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode latin 5', () {
      final bytes = const Latin5Encoder().convert('Приятно встретиться!');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(bytes, const Latin5Codec().encode('Приятно встретиться!'));
      expect(bytes,
          const Latin5Codec(allowInvalid: true).encode('Приятно встретиться!'));
      expect(
          bytes,
          const Latin5Codec(allowInvalid: false)
              .encode('Приятно встретиться!'));
    });

    test('encode more latin 5 ', () {
      final input =
          'ЁЂЃЄЅІЇЈЉЊЋЌ\u{00AD}ЎЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя№ёђѓєѕіїјљњћќ§ўџ';
      var bytes = Latin5Encoder().convert(input);
      var expected = List.generate(95, (index) => index + 0xA1);
      for (var i = 0; i < input.length; i++) {
        if (input.codeUnitAt(i) == 0x3F) {
          // ?
          expected[i] = 0x3F;
        }
      }
      expect(bytes, expected);
    });

    test('encode latin 5 with invalid value when invalid input is allowed', () {
      var bytes = Latin5Encoder(allowInvalid: true).convert('Фжќ�');
      expect(Latin5Decoder().convert(bytes), 'Фжќ?');
    });

    test('encode latin 5 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin5Encoder().convert('Фжќ�'),
          throwsA(isA<FormatException>()));
    });
  });
}
