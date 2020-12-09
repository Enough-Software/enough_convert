import 'dart:convert' as convert;

// import 'package:enough_convert/latin/latin.dart';
import 'package:enough_convert/latin/latin14.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Latin14Codec().name, 'iso-8859-14');
      // print('latin 14 map:');
      // final isoSymbols =
      //     'Ḃḃ£ĊċḊ§Ẁ©ẂḋỲ\u{00AD}®ŸḞḟĠġṀṁ¶ṖẁṗẃṠỳẄẅṡÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏŴÑÒÓÔÕÖṪØÙÚÛÜÝŶßàáâãäåæçèéêëìíîïŵñòóôõöṫøùúûüýŷÿ';
      // LatinEncoder.createEncodingMap(isoSymbols);
    });
    test('Decoder/encoder classes', () {
      expect(Latin14Codec().encoder, isA<Latin14Encoder>());
      expect(Latin14Codec().decoder, isA<Latin14Decoder>());
      convert.Encoding encoding = const Latin14Codec(allowInvalid: false);
      expect(encoding.encoder, isA<Latin14Encoder>());
      expect(encoding.decoder, isA<Latin14Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Latin14Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 14', () {
      final bytes = const Latin14Encoder()
          .convert('Má tú ag lorg cara gan locht, béidh tú gan cara go deo.');
      expect(const Latin14Decoder().convert(bytes),
          'Má tú ag lorg cara gan locht, béidh tú gan cara go deo.');
    });

    test('Decode latin 14 with invalid value when invalid input is allowed',
        () {
      expect(Latin14Decoder(allowInvalid: true).convert([0xC6, 0xE6, 0xFF1]),
          'Ææ�');
    });

    test('Decode latin 14 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin14Decoder().convert([0xC6, 0xE6, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Latin14Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode latin 14', () {
      final bytes = const Latin14Encoder()
          .convert('Má tú ag lorg cara gan locht, béidh tú gan cara go deo.');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(
          bytes,
          const Latin14Codec().encode(
              'Má tú ag lorg cara gan locht, béidh tú gan cara go deo.'));
      expect(
          bytes,
          const Latin14Codec(allowInvalid: true).encode(
              'Má tú ag lorg cara gan locht, béidh tú gan cara go deo.'));
      expect(
          bytes,
          const Latin14Codec(allowInvalid: false).encode(
              'Má tú ag lorg cara gan locht, béidh tú gan cara go deo.'));
    });

    test('encode more latin 14 ', () {
      final input =
          'Ḃḃ£ĊċḊ§Ẁ©ẂḋỲ\u{00AD}®ŸḞḟĠġṀṁ¶ṖẁṗẃṠỳẄẅṡÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏŴÑÒÓÔÕÖṪØÙÚÛÜÝŶßàáâãäåæçèéêëìíîïŵñòóôõöṫøùúûüýŷÿ';

      var bytes = Latin14Encoder().convert(input);
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

    test('encode latin 14 with invalid value when invalid input is allowed',
        () {
      var bytes = Latin14Encoder(allowInvalid: true)
          .convert('Má tú ag lorg cara gan locht, béidh tú gan cara go deo.�');
      expect(Latin14Decoder().convert(bytes),
          'Má tú ag lorg cara gan locht, béidh tú gan cara go deo.?');
    });

    test('encode latin 14 with invalid value when invalid input is not allowed',
        () {
      expect(
          () => Latin14Encoder().convert(
              'Má tú ag lorg cara gan locht, béidh tú gan cara go deo.�'),
          throwsA(isA<FormatException>()));
    });
  });
}
