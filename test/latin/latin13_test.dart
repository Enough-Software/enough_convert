import 'dart:convert' as convert;

// import 'package:enough_convert/latin/latin.dart';
import 'package:enough_convert/latin/latin13.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Latin13Codec().name, 'iso-8859-13');
      // print('latin 13 map:');
      // final isoSymbols =
      //     '”¢£¤„¦§Ø©Ŗ«¬\u{00AD}®Æ°±²³“µ¶·ø¹ŗ»¼½¾æĄĮĀĆÄÅĘĒČÉŹĖĢĶĪĻŠŃŅÓŌÕÖ×ŲŁŚŪÜŻŽßąįāćäåęēčéźėģķīļšńņóōõö÷ųłśūüżž’';
      // LatinEncoder.createEncodingMap(isoSymbols);
    });
    test('Decoder/encoder classes', () {
      expect(Latin13Codec().encoder, isA<Latin13Encoder>());
      expect(Latin13Codec().decoder, isA<Latin13Decoder>());
      convert.Encoding encoding = const Latin13Codec(allowInvalid: false);
      expect(encoding.encoder, isA<Latin13Encoder>());
      expect(encoding.decoder, isA<Latin13Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Latin13Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 13', () {
      final bytes = const Latin13Encoder().convert('Hyggelig å møte deg!');
      expect(const Latin13Decoder().convert(bytes), 'Hyggelig å møte deg!');
    });

    test('Decode latin 13 with invalid value when invalid input is allowed',
        () {
      expect(Latin13Decoder(allowInvalid: true).convert([0xC6, 0xE6, 0xFF1]),
          'Ęę�');
    });

    test('Decode latin 13 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin13Decoder().convert([0xC6, 0xE6, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Latin13Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode latin 13', () {
      final bytes = const Latin13Encoder().convert('Hyggelig å møte deg!');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(bytes, const Latin13Codec().encode('Hyggelig å møte deg!'));
      expect(
          bytes,
          const Latin13Codec(allowInvalid: true)
              .encode('Hyggelig å møte deg!'));
      expect(
          bytes,
          const Latin13Codec(allowInvalid: false)
              .encode('Hyggelig å møte deg!'));
    });

    test('encode more latin 13 ', () {
      final input =
          '”¢£¤„¦§Ø©Ŗ«¬\u{00AD}®Æ°±²³“µ¶·ø¹ŗ»¼½¾æĄĮĀĆÄÅĘĒČÉŹĖĢĶĪĻŠŃŅÓŌÕÖ×ŲŁŚŪÜŻŽßąįāćäåęēčéźėģķīļšńņóōõö÷ųłśūüżž’';

      var bytes = Latin13Encoder().convert(input);
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

    test('encode latin 13 with invalid value when invalid input is allowed',
        () {
      var bytes =
          Latin13Encoder(allowInvalid: true).convert('Hyggelig å møte deg!�');
      expect(Latin13Decoder().convert(bytes), 'Hyggelig å møte deg!?');
    });

    test('encode latin 13 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin13Encoder().convert('Hyggelig å møte deg!�'),
          throwsA(isA<FormatException>()));
    });
  });
}
