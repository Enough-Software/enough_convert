import 'dart:convert' as convert;

// import 'package:enough_convert/latin/latin.dart';
import 'package:enough_convert/latin/latin6.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Latin6Codec().name, 'iso-8859-6');
      // print('latin 6 map:');
      // LatinEncoder.createEncodingMap(
      //     '???¤???????،\u{00AD}?????????????؛???؟?ءآأؤإئابةتثجحخدذرزسشصضطظعغ?????ـفقكلمنهوىيًٌٍَُِّْ?????????????');
    });
    test('Decoder/encoder classes', () {
      expect(Latin6Codec().encoder, isA<Latin6Encoder>());
      expect(Latin6Codec().decoder, isA<Latin6Decoder>());
      convert.Encoding encoding = const Latin6Codec(allowInvalid: false);
      expect(encoding.encoder, isA<Latin6Encoder>());
      expect(encoding.decoder, isA<Latin6Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Latin6Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 6', () {
      final bytes = const Latin6Encoder().convert('سعدت بلقائك');
      expect(const Latin6Decoder().convert(bytes), 'سعدت بلقائك');
    });

    test('Decode latin 6 with invalid value when invalid input is allowed', () {
      expect(Latin6Decoder(allowInvalid: true).convert([0xC4, 0xD6, 0xFF1]),
          'ؤض�');
    });

    test('Decode latin 6 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin6Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Latin6Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode latin 6', () {
      final bytes = const Latin6Encoder().convert('سعدت بلقائك');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(bytes, const Latin6Codec().encode('سعدت بلقائك'));
      expect(
          bytes, const Latin6Codec(allowInvalid: true).encode('سعدت بلقائك'));
      expect(
          bytes, const Latin6Codec(allowInvalid: false).encode('سعدت بلقائك'));
    });

    test('encode more latin 6 ', () {
      final input =
          '???¤???????،\u{00AD}?????????????؛???؟?ءآأؤإئابةتثجحخدذرزسشصضطظعغ?????ـفقكلمنهوىيًٌٍَُِّْ?????????????';
      var bytes = Latin6Encoder().convert(input);
      var expected = List.generate(95, (index) => index + 0xA1);
      for (var i = 0; i < input.length; i++) {
        if (input.codeUnitAt(i) == 0x3F) {
          // ?
          expected[i] = 0x3F;
        }
      }
      expect(bytes, expected);
    });

    test('encode latin 6 with invalid value when invalid input is allowed', () {
      var bytes = Latin6Encoder(allowInvalid: true).convert('سعدت بلقائك�');
      expect(Latin6Decoder().convert(bytes), 'سعدت بلقائك?');
    });

    test('encode latin 6 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin6Encoder().convert('سعدت بلقائك�'),
          throwsA(isA<FormatException>()));
    });
  });
}
