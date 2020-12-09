import 'dart:convert' as convert;

//import 'package:enough_convert/latin/latin.dart';
import 'package:enough_convert/latin/latin4.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Latin4Codec().name, 'iso-8859-4');
      //print('latin4 map:');
      // LatinEncoder.createEncodingMap(
      //     'ĄĸŖ¤ĨĻ§¨ŠĒĢŦ\u{00AD}Ž¯°ą˛ŗ´ĩļˇ¸šēģŧŊžŋĀÁÂÃÄÅÆĮČÉĘËĖÍÎĪĐŅŌĶÔÕÖ×ØŲÚÛÜŨŪßāáâãäåæįčéęëėíîīđņōķôõö÷øųúûüũū˙');
    });
    test('Decoder/encoder classes', () {
      expect(Latin4Codec().encoder, isA<Latin4Encoder>());
      expect(Latin4Codec().decoder, isA<Latin4Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Latin4Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 4', () {
      expect(Latin4Decoder().convert([0xC4, 0xD6, 0xFC]), 'ÄÖü');
      final bytes = Latin4Encoder().convert('hello world motörhead ruleß ok ô');
      expect(
          Latin4Decoder().convert(bytes), 'hello world motörhead ruleß ok ô');
    });

    test('Decode latin 4 with invalid value when invalid input is allowed', () {
      expect(
          Latin4Decoder(allowInvalid: true).convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ÄÖü�');
    });

    test('Decode latin 4 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin4Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Latin4Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode latin 4', () {
      var bytes = Latin4Encoder().convert('ÄÖü');
      expect(bytes, [0xC4, 0xD6, 0xFC]);
      bytes = Latin4Encoder().convert('hello world motörhead ruleß ok');

      /// this works because umlauts are at the same position as in latin-1
      expect(bytes, convert.latin1.encode('hello world motörhead ruleß ok'));
      bytes = Latin4Encoder().convert('Priecājos iepazīties!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more latin 4 ', () {
      final input =
          'ĄĸŖ¤ĨĻ§¨ŠĒĢŦ\u{00AD}Ž¯°ą˛ŗ´ĩļˇ¸šēģŧŊžŋĀÁÂÃÄÅÆĮČÉĘËĖÍÎĪĐŅŌĶÔÕÖ×ØŲÚÛÜŨŪßāáâãäåæįčéęëėíîīđņōķôõö÷øųúûüũū˙';
      var bytes = Latin4Encoder().convert(input);
      var expected = List.generate(95, (index) => index + 0xA1);
      for (var i = 0; i < input.length; i++) {
        if (input.codeUnitAt(i) == 0x3F) {
          // ?
          expected[i] = 0x3F;
        }
      }
      expect(bytes, expected);
    });

    test('encode latin 4 with invalid value when invalid input is allowed', () {
      var bytes = Latin4Encoder(allowInvalid: true).convert('ÄÖü�');
      expect(Latin4Decoder().convert(bytes), 'ÄÖü?');
    });

    test('encode latin 4 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin4Encoder().convert('ÄÖü�'),
          throwsA(isA<FormatException>()));
    });
  });
}
