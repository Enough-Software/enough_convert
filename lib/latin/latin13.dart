import 'dart:convert' as cnvrt;

import 'latin.dart';

const String _latin13Symbols =
    '”¢£¤„¦§Ø©Ŗ«¬\u{00AD}®Æ°±²³“µ¶·ø¹ŗ»¼½¾æĄĮĀĆÄÅĘĒČÉŹĖĢĶĪĻŠŃŅÓŌÕÖ×ŲŁŚŪÜŻŽßąįāćäåęēčéźėģķīļšńņóōõö÷ųłśūüżž’';
const Map<int, int> _latin13SymbolMap = {
  8221: 161,
  162: 162,
  163: 163,
  164: 164,
  8222: 165,
  166: 166,
  167: 167,
  216: 168,
  169: 169,
  342: 170,
  171: 171,
  172: 172,
  173: 173,
  174: 174,
  198: 175,
  176: 176,
  177: 177,
  178: 178,
  179: 179,
  8220: 180,
  181: 181,
  182: 182,
  183: 183,
  248: 184,
  185: 185,
  343: 186,
  187: 187,
  188: 188,
  189: 189,
  190: 190,
  230: 191,
  260: 192,
  302: 193,
  256: 194,
  262: 195,
  196: 196,
  197: 197,
  280: 198,
  274: 199,
  268: 200,
  201: 201,
  377: 202,
  278: 203,
  290: 204,
  310: 205,
  298: 206,
  315: 207,
  352: 208,
  323: 209,
  325: 210,
  211: 211,
  332: 212,
  213: 213,
  214: 214,
  215: 215,
  370: 216,
  321: 217,
  346: 218,
  362: 219,
  220: 220,
  379: 221,
  381: 222,
  223: 223,
  261: 224,
  303: 225,
  257: 226,
  263: 227,
  228: 228,
  229: 229,
  281: 230,
  275: 231,
  269: 232,
  233: 233,
  378: 234,
  279: 235,
  291: 236,
  311: 237,
  299: 238,
  316: 239,
  353: 240,
  324: 241,
  326: 242,
  243: 243,
  333: 244,
  245: 245,
  246: 246,
  247: 247,
  371: 248,
  322: 249,
  347: 250,
  363: 251,
  252: 252,
  380: 253,
  382: 254,
  8217: 255,
};

/// Provides a latin 13 / iso-8859-13 codec for easy encoding and decoding.
/// Note that the decoder directly modifies the data given in `decode(List<int> data)`,
/// in doubt create a new array first, e.g.
/// ```dart
/// codec.decode([...data]);
/// ```
class Latin13Codec extends cnvrt.Encoding {
  final bool allowInvalid;

  /// Creates a new codec
  const Latin13Codec({
    /// set [allowInvalid] to `true` for ignoring invalid data.
    /// When invalid data is allowed it  will be encoded to ? and decoded to �
    this.allowInvalid = false,
  });

  @override
  Latin13Decoder get decoder => allowInvalid
      ? const Latin13Decoder(allowInvalid: true)
      : const Latin13Decoder(allowInvalid: false);

  @override
  Latin13Encoder get encoder => allowInvalid
      ? const Latin13Encoder(allowInvalid: true)
      : const Latin13Encoder(allowInvalid: false);

  @override
  String get name => 'iso-8859-13';
}

/// Encodes texts into latin 13 / iso-88513-13 data
class Latin13Encoder extends LatinEncoder {
  const Latin13Encoder({
    /// set [allowInvalid] to `true` for ignoring invalid data.
    /// When invalid data is allowed it  will be encoded to ?
    bool allowInvalid = false,
  }) : super(_latin13SymbolMap, allowInvalid: allowInvalid);
}

/// Decodes latin 13 /  iso-88513-13 data.
/// Note that the decoder directly modifies the data given in `convert(List<int> data)`,
/// in doubt create a new array first, e.g.
/// ```dart
/// decoder.convert([...data]);
/// ```
class Latin13Decoder extends LatinDecoder {
  const Latin13Decoder({
    /// set [allowInvalid] to `true` for ignoring invalid data.
    /// When invalid data is allowed it  will be decoded to �
    bool allowInvalid = false,
  }) : super(_latin13Symbols, allowInvalid: allowInvalid);
}
