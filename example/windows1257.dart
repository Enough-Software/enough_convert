import 'dart:convert' show Converter, Encoding;

import 'package:enough_convert/windows_base.dart';

class Windows1257Codec extends Encoding {
  const Windows1257Codec({this.allowInvalid = false});

  final bool allowInvalid;

  @override
  Converter<List<int>, String> get decoder => allowInvalid
      ? Windows1257Decoder(allowInvalid: true)
      : Windows1257Decoder(allowInvalid: false);

  @override
  Converter<String, List<int>> get encoder => allowInvalid
      ? Windows1257Encoder(allowInvalid: true)
      : Windows1257Encoder(allowInvalid: false);

  @override
  String get name => 'windows-1257';
}

class Windows1257Decoder extends WindowsDecoder {
  Windows1257Decoder({bool allowInvalid = false})
      : super(_cp1257Symbols, allowInvalid: allowInvalid);
}

class Windows1257Encoder extends WindowsEncoder {
  Windows1257Encoder({bool allowInvalid = false})
      : super(_cp1257Map, allowInvalid: allowInvalid);
}

const String _cp1257Symbols =
    '€?‚?„…†‡?‰?‹?¨ˇ¸?‘’“”•–—?™?›?¯˛?\u{00A0}?¢£¤?¦§Ø©Ŗ«¬\u{00AD}®Æ°±²³´µ¶·ø¹ŗ»'
    '¼½¾æĄĮĀĆÄÅĘĒČÉŹĖĢĶĪĻŠŃŅÓŌÕÖ×ŲŁŚŪÜŻŽßąįāćäåęēčéźėģķīļšńņóōõö÷ųłśūüżž˙';

const Map<int, int> _cp1257Map = {
  8364: 128,
  8218: 130,
  8222: 132,
  8230: 133,
  8224: 134,
  8225: 135,
  8240: 137,
  8249: 139,
  168: 141,
  711: 142,
  184: 143,
  8216: 145,
  8217: 146,
  8220: 147,
  8221: 148,
  8226: 149,
  8211: 150,
  8212: 151,
  8482: 153,
  8250: 155,
  175: 157,
  731: 158,
  160: 160,
  162: 162,
  163: 163,
  164: 164,
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
  180: 180,
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
  729: 255,
};
