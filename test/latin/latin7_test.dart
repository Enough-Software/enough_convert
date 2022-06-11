// ignore_for_file: lines_longer_than_80_chars
// cSpell:disable

import 'dart:convert' as dart_convert;

import 'package:enough_convert/latin/latin7.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(const Latin7Codec().name, 'iso-8859-7');
      // print('latin 7 map:');
      // LatinEncoder.createEncodingMap(
      //     '‘’£€₯¦§¨©ͺ«¬\u{00AD}?―°±²³΄΅Ά·ΈΉΊ»Ό½ΎΏΐΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡ?ΣΤΥΦΧΨΩΪΫάέήίΰαβγδεζηθικλμνξοπρςστυφχψωϊϋόύώ?');
    });
    test('Decoder/encoder classes', () {
      expect(const Latin7Codec().encoder, isA<Latin7Encoder>());
      expect(const Latin7Codec().decoder, isA<Latin7Decoder>());
      const dart_convert.Encoding encoding = Latin7Codec(allowInvalid: false);
      expect(encoding.encoder, isA<Latin7Encoder>());
      expect(encoding.decoder, isA<Latin7Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = dart_convert.ascii.encode('hello world');
      expect(const Latin7Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 7', () {
      final bytes = const Latin7Encoder().convert('Χαίρομαι που σας γνωρίζω!');
      expect(const Latin7Decoder().convert(bytes), 'Χαίρομαι που σας γνωρίζω!');
    });

    test('Decode latin 7 with invalid value when invalid input is allowed', () {
      expect(
          const Latin7Decoder(allowInvalid: true).convert([0xC4, 0xD7, 0xFF1]),
          'ΔΧ�');
    });

    test('Decode latin 7 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin7Decoder().convert([0xC4, 0xD7, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = const Latin7Encoder().convert('hello world');
      expect(bytes, dart_convert.latin1.encode('hello world'));
    });

    test('encode latin 7', () {
      final bytes = const Latin7Encoder().convert('Χαίρομαι που σας γνωρίζω!');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(bytes, const Latin7Codec().encode('Χαίρομαι που σας γνωρίζω!'));
      expect(
          bytes,
          const Latin7Codec(allowInvalid: true)
              .encode('Χαίρομαι που σας γνωρίζω!'));
      expect(
          bytes,
          const Latin7Codec(allowInvalid: false)
              .encode('Χαίρομαι που σας γνωρίζω!'));
    });

    test('encode more latin 7 ', () {
      const input =
          '‘’£€₯¦§¨©ͺ«¬\u{00AD}?―°±²³΄΅Ά·ΈΉΊ»Ό½ΎΏΐΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡ?ΣΤΥΦΧΨΩΪΫάέήίΰαβγδεζηθικλμνξοπρςστυφχψωϊϋόύώ?';
      final bytes = const Latin7Encoder().convert(input);
      final expected = List.generate(95, (index) => index + 0xA1);
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

    test('encode latin 7 with invalid value when invalid input is allowed', () {
      final bytes = const Latin7Encoder(allowInvalid: true)
          .convert('Χαίρομαι που σας γνωρίζω!�');
      expect(
          const Latin7Decoder().convert(bytes), 'Χαίρομαι που σας γνωρίζω!?');
    });

    test('encode latin 7 with invalid value when invalid input is not allowed',
        () {
      expect(() => const Latin7Encoder().convert('Χαίρομαι που σας γνωρίζω!�'),
          throwsA(isA<FormatException>()));
    });
  });
}
