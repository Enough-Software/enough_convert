import 'dart:convert' as convert;

// import 'package:enough_convert/base.dart';
import 'package:enough_convert/windows/windows1251.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Windows1251Codec().name, 'windows-1251');
      // BaseEncoder.createEncodingMap(Windows1251Decoder().symbols, 0x7f);
    });
    test('Decoder/encoder classes', () {
      expect(Windows1251Codec().encoder, isA<Windows1251Encoder>());
      expect(Windows1251Codec().decoder, isA<Windows1251Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Windows1251Decoder().convert(bytes), 'hello world');
    });

    test('Decode Windows1251', () {
      expect(Windows1251Decoder().convert([0xC4, 0xD6, 0xFC]), 'ДЦь');
      final bytes = Windows1251Encoder().convert('Радий познайомитися з Вами!');
      expect(
          Windows1251Decoder().convert(bytes), 'Радий познайомитися з Вами!');
    });

    test('Decode Windows1251 with invalid value when invalid input is allowed',
        () {
      expect(
          Windows1251Decoder(allowInvalid: true)
              .convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ДЦь�');
    });

    test(
        'Decode Windows1251 with invalid value when invalid input is not allowed',
        () {
      expect(() => Windows1251Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Windows1251Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode Windows1251', () {
      final bytes = Windows1251Encoder().convert('Радий познайомитися з Вами!');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(
          Windows1251Decoder().convert(bytes), 'Радий познайомитися з Вами!');
    });

    test('encode more Windows1251 ', () {
      final encoder = Windows1251Encoder();
      final decoder = Windows1251Decoder();
      var bytes = encoder.convert(decoder.symbols);
      var expected = List.generate(0xFF - 0x7F, (index) => index + 0x80);
      for (var i = 0; i < decoder.symbols.length; i++) {
        if (decoder.symbols.codeUnitAt(i) == 0x3F) {
          // ?
          expected[i] = 0x3F;
        }
      }
      expect(bytes, expected);
    });

    test('encode Windows1251 with invalid value when invalid input is allowed',
        () {
      var bytes = Windows1251Encoder(allowInvalid: true).convert('йз�');
      expect(Windows1251Decoder().convert(bytes), 'йз?');
    });

    test(
        'encode Windows1251 with invalid value when invalid input is not allowed',
        () {
      expect(() => Windows1251Encoder().convert('йз�'),
          throwsA(isA<FormatException>()));
    });
  });
}
