import 'dart:convert' as convert;

// import 'package:enough_convert/base.dart';
import 'package:enough_convert/windows/windows1256.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Windows1256Codec().name, 'windows-1256');
      // BaseEncoder.createEncodingMap(Windows1254Decoder().symbols, 0x7f);
    });
    test('Decoder/encoder classes', () {
      expect(Windows1256Codec().encoder, isA<Windows1256Encoder>());
      expect(Windows1256Codec().decoder, isA<Windows1256Decoder>());
    });
  });

  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Windows1256Decoder().convert(bytes), 'hello world');
    });

    test('Decode Windows1256', () {
      expect(Windows1256Decoder().convert([0xC4, 0xD6, 0xFC]), 'ؤضü');
      final bytes = Windows1256Encoder().convert('سلام اين يک متن تست است!');
      expect(
          Windows1256Decoder().convert(bytes), 'سلام اين يک متن تست است!');
    });

    test('Decode Windows1256 with invalid value when invalid input is allowed',
            () {
          expect(
              Windows1256Decoder(allowInvalid: true)
                  .convert([0xC4, 0xD6, 0xFC, 0xFF1]),
              'ؤضü�');
        });

    test(
        'Decode Windows1256 with invalid value when invalid input is not allowed',
            () {
          expect(() => Windows1256Decoder().convert([0xC4, 0xD6, 0xFC, 0xFF1]),
              throwsA(isA<FormatException>()));
        });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Windows1256Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode Windows1256', () {
      var bytes = Windows1256Encoder().convert('ؤضü');
      expect(bytes, [0xC4, 0xD6, 0xFC]);
      bytes = Windows1256Encoder().convert('سلام اين يک متن تست است!');
      expect(bytes.any((element) => element > 0xFF), false);
    });

    test('encode more Windows1256 ', () {
      final encoder = Windows1256Encoder();
      final decoder = Windows1256Decoder();
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

    test('encode Windows1256 with invalid value when invalid input is allowed',
            () {
          var bytes = Windows1256Encoder(allowInvalid: true).convert('ؤضü�');
          expect(Windows1256Decoder().convert(bytes), 'ؤضü?');
        });

    test(
        'encode Windows1256 with invalid value when invalid input is not allowed',
            () {
          expect(() => Windows1256Encoder().convert('ؤضü�'),
              throwsA(isA<FormatException>()));
        });
  });
}
