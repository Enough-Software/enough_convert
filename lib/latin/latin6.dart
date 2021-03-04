import 'dart:convert' as cnvrt;

import 'latin.dart';

const String _latin6Symbols =
    '???¤???????،\u{00AD}?????????????؛???؟?ءآأؤإئابةتثجحخدذرزسشصضطظعغ?????ـفقكلمنهوىيًٌٍَُِّْ?????????????';
const Map<int, int> _latin6SymbolMap = {
  164: 164,
  1548: 172,
  173: 173,
  1563: 187,
  1567: 191,
  1569: 193,
  1570: 194,
  1571: 195,
  1572: 196,
  1573: 197,
  1574: 198,
  1575: 199,
  1576: 200,
  1577: 201,
  1578: 202,
  1579: 203,
  1580: 204,
  1581: 205,
  1582: 206,
  1583: 207,
  1584: 208,
  1585: 209,
  1586: 210,
  1587: 211,
  1588: 212,
  1589: 213,
  1590: 214,
  1591: 215,
  1592: 216,
  1593: 217,
  1594: 218,
  1600: 224,
  1601: 225,
  1602: 226,
  1603: 227,
  1604: 228,
  1605: 229,
  1606: 230,
  1607: 231,
  1608: 232,
  1609: 233,
  1610: 234,
  1611: 235,
  1612: 236,
  1613: 237,
  1614: 238,
  1615: 239,
  1616: 240,
  1617: 241,
  1618: 242,
};

/// Provides a latin 6 / iso-8859-6 codec for easy encoding and decoding.
class Latin6Codec extends cnvrt.Encoding {
  final bool allowInvalid;

  /// Creates a new codec
  const Latin6Codec({
    /// set [allowInvalid] to `true` for ignoring invalid data.
    /// When invalid data is allowed it  will be encoded to ? and decoded to �
    this.allowInvalid = false,
  });

  @override
  Latin6Decoder get decoder => allowInvalid
      ? const Latin6Decoder(allowInvalid: true)
      : const Latin6Decoder(allowInvalid: false);

  @override
  Latin6Encoder get encoder => allowInvalid
      ? const Latin6Encoder(allowInvalid: true)
      : const Latin6Encoder(allowInvalid: false);

  @override
  String get name => 'iso-8859-6';
}

/// Encodes texts into latin 6 / iso-8859-6 data
class Latin6Encoder extends LatinEncoder {
  const Latin6Encoder({
    /// set [allowInvalid] to `true` for ignoring invalid data.
    /// When invalid data is allowed it  will be encoded to ?
    bool allowInvalid = false,
  }) : super(_latin6SymbolMap, allowInvalid: allowInvalid);
}

/// Decodes latin 6 /  iso-8859-6 data.
class Latin6Decoder extends LatinDecoder {
  const Latin6Decoder({
    /// set [allowInvalid] to `true` for ignoring invalid data.
    /// When invalid data is allowed it  will be decoded to �
    bool allowInvalid = false,
  }) : super(_latin6Symbols, allowInvalid: allowInvalid);
}
