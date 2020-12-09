import 'dart:convert' as convert;

// import 'package:enough_convert/latin/latin.dart';
import 'package:enough_convert/latin/latin11.dart';
import 'package:test/test.dart';

void main() {
  group('Codec tests', () {
    test('name', () {
      expect(Latin11Codec().name, 'iso-8859-11');
      // print('latin 11 map:');
      // final isoSymbols =
      //     'กขฃคฅฆงจฉชซฌญฎฏฐฑฒณดตถทธนบปผฝพฟภมยรฤลฦวศษสหฬอฮฯะัาำิีึืฺุู????฿เแโใไๅๆ็่้๊๋์ํ๎๏๐๑๒๓๔๕๖๗๘๙๚๛????';
      // LatinEncoder.createEncodingMap(isoSymbols);
    });
    test('Decoder/encoder classes', () {
      expect(Latin11Codec().encoder, isA<Latin11Encoder>());
      expect(Latin11Codec().decoder, isA<Latin11Decoder>());
      convert.Encoding encoding = const Latin11Codec(allowInvalid: false);
      expect(encoding.encoder, isA<Latin11Encoder>());
      expect(encoding.decoder, isA<Latin11Decoder>());
    });
  });
  group('Decoder tests', () {
    test('Decode ascii', () {
      final bytes = convert.ascii.encode('hello world');
      expect(Latin11Decoder().convert(bytes), 'hello world');
    });

    test('Decode latin 11', () {
      final bytes = const Latin11Encoder().convert('ยินดีที่ได้พบคุณ!');
      expect(const Latin11Decoder().convert(bytes), 'ยินดีที่ได้พบคุณ!');
    });

    test('Decode latin 11 with invalid value when invalid input is allowed',
        () {
      expect(Latin11Decoder(allowInvalid: true).convert([0xC6, 0xC7, 0xFF1]),
          'ฦว�');
    });

    test('Decode latin 11 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin11Decoder().convert([0xC6, 0xC7, 0xFF1]),
          throwsA(isA<FormatException>()));
    });
  });

  group('Encoder tests', () {
    test('encode ascii', () {
      final bytes = Latin11Encoder().convert('hello world');
      expect(bytes, convert.latin1.encode('hello world'));
    });

    test('encode latin 11', () {
      final bytes = const Latin11Encoder().convert('ยินดีที่ได้พบคุณ!');
      expect(bytes.any((element) => element > 0xFF), false);
      expect(bytes, const Latin11Codec().encode('ยินดีที่ได้พบคุณ!'));
      expect(bytes,
          const Latin11Codec(allowInvalid: true).encode('ยินดีที่ได้พบคุณ!'));
      expect(bytes,
          const Latin11Codec(allowInvalid: false).encode('ยินดีที่ได้พบคุณ!'));
    });

    test('encode more latin 11 ', () {
      final input =
          'กขฃคฅฆงจฉชซฌญฎฏฐฑฒณดตถทธนบปผฝพฟภมยรฤลฦวศษสหฬอฮฯะัาำิีึืฺุู????฿เแโใไๅๆ็่้๊๋์ํ๎๏๐๑๒๓๔๕๖๗๘๙๚๛????';

      var bytes = Latin11Encoder().convert(input);
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

    test('encode latin 11 with invalid value when invalid input is allowed',
        () {
      var bytes =
          Latin11Encoder(allowInvalid: true).convert('ยินดีที่ได้พบคุณ!�');
      expect(Latin11Decoder().convert(bytes), 'ยินดีที่ได้พบคุณ!?');
    });

    test('encode latin 11 with invalid value when invalid input is not allowed',
        () {
      expect(() => Latin11Encoder().convert('ยินดีที่ได้พบคุณ!�'),
          throwsA(isA<FormatException>()));
    });
  });
}
