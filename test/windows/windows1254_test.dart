import 'dart:convert' as convert;

// import 'package:enough_convert/base.dart';
import 'package:enough_convert/windows/windows1254.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Windows1254Codec().name, 'windows-1254');
      // BaseEncoder.createEncodingMap(Windows1254Decoder().symbols, 0x7f);
    });
    test('Decoder/encoder classes', () {
      expect(Windows1254Codec().encoder, isA<Windows1254Encoder>());
      expect(Windows1254Codec().decoder, isA<Windows1254Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Windows1254Decoder().convert(bytes), 'hello world');
    });

    test('Decode Windows1254', () {
      expect(Windows1254Decoder().convert([0xC4, 0xD6, 0xFC]), 'ÄÖü');
      final bytes = Windows1254Encoder().convert('Tanıştığımıza memnun oldum!');
      expect(
          Windows1254Decoder().convert(bytes), 'Tanıştığımıza memnun oldum!');
    });

    test('Decode Windows1254 with invalid value when invalid input is allowed',
        () {
      expect(
          Windows1254Decoder(allowInvalid: true)
              .convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          'ÄÖü�');
    });

    test(
        'Decode Windows1254 with invalid value when invalid input is not allowed',
        () {
      expect(() => Windows1254Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Windows1254Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode Windows1254', () {
      var bytes = Windows1254Encoder().convert('ÄÖü');
      expect(bytes, [0xC4, 0xD6, 0xFC]);
      bytes = Windows1254Encoder().convert('Tanıştığımıza memnun oldum!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more Windows1254 ', () {
      final encoder = Windows1254Encoder();
      final decoder = Windows1254Decoder();
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

    test('encode Windows1254 with invalid value when invalid input is allowed',
        () {
      var bytes = Windows1254Encoder(allowInvalid: true).convert('ÄÖü�');
      expect(Windows1254Decoder().convert(bytes), 'ÄÖü?');
    });

    test(
        'encode Windows1254 with invalid value when invalid input is not allowed',
        () {
      expect(() => Windows1254Encoder().convert('ÄÖü�'),
          throwsA(isA<FormatException>()));
    });
  });
}
