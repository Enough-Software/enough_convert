import 'dart:convert' as convert;
// import 'package:enough_convert/latin/latin.dart';
import 'package:enough_convert/latin/latin8.dart';
import 'package:test/test.dart';

//import 'package:characters/characters.dart';
void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Latin8Codec().name, 'iso-8859-8');
      // final symbols =
      //     '?¢£¤¥¦§¨©×«¬\u{00AD}®¯°±²³´µ¶·¸¹÷»¼½¾????????????????????????????????‗אבגדהוזחטיךכלםמןנסעףפץצקרשת??\u{8206}\u{8207}?';
      // print('latin 8 map:');
      // LatinEncoder.createEncodingMap(symbols);
    });
    test('Decoder/encoder classes', () {
      expect(Latin8Codec().encoder, isA<Latin8Encoder>());
      expect(Latin8Codec().decoder, isA<Latin8Decoder>());
      convert.Encoding encoding = const Latin8Codec(allowInvalid: false);
      expect(encoding.encoder, isA<Latin8Encoder>());
      expect(encoding.decoder, isA<Latin8Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Latin8Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 8', () {
      final bytes =
          const Latin8Encoder().convert('נעים להכיר אותך.נעים להכיר אותך-.');
      expect(const Latin8Decoder().convert(bytes),
          'נעים להכיר אותך.נעים להכיר אותך-.');
    });

    test('Decode latin 8 with invalid value when invalid input is allowed', () {
      expect(Latin8Decoder(allowInvalid: true).convert([0xB2, 0xB3, 0xFF1]),
          '²³�');
    });

    test('Decode latin 8 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin8Decoder().convert([0xC4, 0xD8, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Latin8Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode latin 8', () {
      final bytes =
          const Latin8Encoder().convert('נעים להכיר אותך.נעים להכיר אותך-.');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(bytes,
          const Latin8Codec().encode('נעים להכיר אותך.נעים להכיר אותך-.'));
      expect(
          bytes,
          const Latin8Codec(allowInvalid: true)
              .encode('נעים להכיר אותך.נעים להכיר אותך-.'));
      expect(
          bytes,
          const Latin8Codec(allowInvalid: false)
              .encode('נעים להכיר אותך.נעים להכיר אותך-.'));
    });

    test('encode more latin 8 ', () {
      final input =
          '?¢£¤¥¦§¨©×«¬\u{00AD}®¯°±²³´µ¶·¸¹÷»¼½¾????????????????????????????????‗אבגדהוזחטיךכלםמןנסעףפץצקרשת??\u{8206}\u{8207}?';

      var bytes = Latin8Encoder().convert(input);
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

    test('encode latin 8 with invalid value when invalid input is allowed', () {
      var bytes = Latin8Encoder(allowInvalid: true)
          .convert('נעים להכיר אותך.נעים להכיר אותך-.�');
      expect(
          Latin8Decoder().convert(bytes), 'נעים להכיר אותך.נעים להכיר אותך-.?');
    });

    test('encode latin 8 with invalid value when invalid input is not allowed',
        () {
      expect(
          () => Latin8Encoder().convert('נעים להכיר אותך.נעים להכיר אותך-.�'),
          throwsA(isA<FormatException>()));
    });
  });
}
