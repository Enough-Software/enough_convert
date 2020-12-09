import 'dart:convert' as convert;

//import 'package:enough_convert/latin/latin.dart';
import 'package:enough_convert/latin/latin9.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Latin9Codec().name, 'iso-8859-9');
      // print('latin 9 map:');
      // final isoSymbols =
      //     '¡¢£¤¥¦§¨©ª«¬\u{00AD}®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿ';
      // LatinEncoder.createEncodingMap(isoSymbols);
    });
    test('Decoder/encoder classes', () {
      expect(Latin9Codec().encoder, isA<Latin9Encoder>());
      expect(Latin9Codec().decoder, isA<Latin9Decoder>());
      convert.Encoding encoding = const Latin9Codec(allowInvalid: false);
      expect(encoding.encoder, isA<Latin9Encoder>());
      expect(encoding.decoder, isA<Latin9Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Latin9Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 9', () {
      final bytes =
          const Latin9Encoder().convert('Tanıştığımıza memnun oldum!');
      expect(
          const Latin9Decoder().convert(bytes), 'Tanıştığımıza memnun oldum!');
    });

    test('Decode latin 9 with invalid value when invalid input is allowed', () {
      expect(Latin9Decoder(allowInvalid: true).convert([0xC4, 0xD9, 0xFF1]),
          'ÄÙ�');
    });

    test('Decode latin 9 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin9Decoder().convert([0xC4, 0xD9, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Latin9Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode latin 9', () {
      final bytes =
          const Latin9Encoder().convert('Tanıştığımıza memnun oldum!');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(bytes, const Latin9Codec().encode('Tanıştığımıza memnun oldum!'));
      expect(
          bytes,
          const Latin9Codec(allowInvalid: true)
              .encode('Tanıştığımıza memnun oldum!'));
      expect(
          bytes,
          const Latin9Codec(allowInvalid: false)
              .encode('Tanıştığımıza memnun oldum!'));
    });

    test('encode more latin 9 ', () {
      final input =
          '¡¢£¤¥¦§¨©ª«¬\u{00AD}®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿ';

      var bytes = Latin9Encoder().convert(input);
      var expected = List.generate(95, (index) => index + 0xA1);
      // print(
      //     'input.length=${input.length} bytes.length=${bytes.length} expected.length=${expected.length}');
      for (var i = 0; i < input.length; i++) {
        if (input.codeUnitAt(i) == 0x3F) {
          // ?
          expected[i] = 0x3F;
        }
      }
      expect(bytes, expected);
    });

    test('encode latin 9 with invalid value when invalid input is allowed', () {
      var bytes = Latin9Encoder(allowInvalid: true)
          .convert('Tanıştığımıza memnun oldum!�');
      expect(Latin9Decoder().convert(bytes), 'Tanıştığımıza memnun oldum!?');
    });

    test('encode latin 9 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin9Encoder().convert('Tanıştığımıza memnun oldum!�'),
          throwsA(isA<FormatException>()));
    });
  });
}
