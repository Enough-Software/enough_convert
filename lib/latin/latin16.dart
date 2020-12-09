import 'dart:convert' as cnvrt;

import 'latin.dart';

const String _latin16Symbols =
    'ĄąŁ€„Š§š©Ș«Ź\u{00AD}źŻ°±ČłŽ”¶·žčș»ŒœŸżÀÁÂĂÄĆÆÇÈÉÊËÌÍÎÏĐŃÒÓÔŐÖŚŰÙÚÛÜĘȚßàáâăäćæçèéêëìíîïđńòóôőöśűùúûüęțÿ';
const Map<int, int> _latin16SymbolMap = {
  260: 161,
  261: 162,
  321: 163,
  8364: 164,
  8222: 165,
  352: 166,
  167: 167,
  353: 168,
  169: 169,
  536: 170,
  171: 171,
  377: 172,
  173: 173,
  378: 174,
  379: 175,
  176: 176,
  177: 177,
  268: 178,
  322: 179,
  381: 180,
  8221: 181,
  182: 182,
  183: 183,
  382: 184,
  269: 185,
  537: 186,
  187: 187,
  338: 188,
  339: 189,
  376: 190,
  380: 191,
  192: 192,
  193: 193,
  194: 194,
  258: 195,
  196: 196,
  262: 197,
  198: 198,
  199: 199,
  200: 200,
  201: 201,
  202: 202,
  203: 203,
  204: 204,
  205: 205,
  206: 206,
  207: 207,
  272: 208,
  323: 209,
  210: 210,
  211: 211,
  212: 212,
  336: 213,
  214: 214,
  346: 215,
  368: 216,
  217: 217,
  218: 218,
  219: 219,
  220: 220,
  280: 221,
  538: 222,
  223: 223,
  224: 224,
  225: 225,
  226: 226,
  259: 227,
  228: 228,
  263: 229,
  230: 230,
  231: 231,
  232: 232,
  233: 233,
  234: 234,
  235: 235,
  236: 236,
  237: 237,
  238: 238,
  239: 239,
  273: 240,
  324: 241,
  242: 242,
  243: 243,
  244: 244,
  337: 245,
  246: 246,
  347: 247,
  369: 248,
  249: 249,
  250: 250,
  251: 251,
  252: 252,
  281: 253,
  539: 254,
  255: 255,
};

/// Provides a latin 16 / iso-8859-16 codec for easy encoding and decoding.
/// Note that the decoder directly modifies the data given in `decode(List<int> data)`,
/// in doubt create a new array first, e.g.
/// ```dart
/// codec.decode([...data]);
/// ```
class Latin16Codec extends cnvrt.Encoding {
  final bool allowInvalid;

  /// Creates a new codec
  const Latin16Codec({
    /// set [allowInvalid] to `true` for ignoring invalid data.
    /// When invalid data is allowed it  will be encoded to ? and decoded to �
    this.allowInvalid = false,
  });

  @override
  Latin16Decoder get decoder => allowInvalid
      ? const Latin16Decoder(allowInvalid: true)
      : const Latin16Decoder(allowInvalid: false);

  @override
  Latin16Encoder get encoder => allowInvalid
      ? const Latin16Encoder(allowInvalid: true)
      : const Latin16Encoder(allowInvalid: false);

  @override
  String get name => 'iso-8859-16';
}

/// Encodes texts into latin 16 / iso-88516-16 data
class Latin16Encoder extends LatinEncoder {
  const Latin16Encoder({
    /// set [allowInvalid] to `true` for ignoring invalid data.
    /// When invalid data is allowed it  will be encoded to ?
    bool allowInvalid = false,
  }) : super(_latin16SymbolMap, allowInvalid: allowInvalid);
}

/// Decodes latin 16 /  iso-88516-16 data.
/// Note that the decoder directly modifies the data given in `convert(List<int> data)`,
/// in doubt create a new array first, e.g.
/// ```dart
/// decoder.convert([...data]);
/// ```
class Latin16Decoder extends LatinDecoder {
  const Latin16Decoder({
    /// set [allowInvalid] to `true` for ignoring invalid data.
    /// When invalid data is allowed it  will be decoded to �
    bool allowInvalid = false,
  }) : super(_latin16Symbols, allowInvalid: allowInvalid);
}
