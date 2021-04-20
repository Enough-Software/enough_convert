import 'dart:convert' as cnvrt;

import 'koi8.dart';

const String _koi8_r_symbols =
    'юабцдефгхийклмнопярстужвьызшэщчъЮАБЦДЕФГХИЙКЛМНОПЯРСТУЖВЬЫЗШЭЩЧЪ';

const Map<int, int> _koi8_rSymbolMap = {
  1102: 192,
  1072: 193,
  1073: 194,
  1094: 195,
  1076: 196,
  1077: 197,
  1092: 198,
  1075: 199,
  1093: 200,
  1080: 201,
  1081: 202,
  1082: 203,
  1083: 204,
  1084: 205,
  1085: 206,
  1086: 207,
  1087: 208,
  1103: 209,
  1088: 210,
  1089: 211,
  1090: 212,
  1091: 213,
  1078: 214,
  1074: 215,
  1100: 216,
  1099: 217,
  1079: 218,
  1096: 219,
  1101: 220,
  1097: 221,
  1095: 222,
  1098: 223,
  1070: 224,
  1040: 225,
  1041: 226,
  1062: 227,
  1044: 228,
  1045: 229,
  1060: 230,
  1043: 231,
  1061: 232,
  1048: 233,
  1049: 234,
  1050: 235,
  1051: 236,
  1052: 237,
  1053: 238,
  1054: 239,
  1055: 240,
  1071: 241,
  1056: 242,
  1057: 243,
  1058: 244,
  1059: 245,
  1046: 246,
  1042: 247,
  1068: 248,
  1067: 249,
  1047: 250,
  1064: 251,
  1069: 252,
  1065: 253,
  1063: 254,
  1066: 255
};

class Koi8rCodec extends cnvrt.Encoding {
  final bool allowInvalid;

  const Koi8rCodec({this.allowInvalid = false});

  @override
  Koi8rDecoder get decoder => allowInvalid
      ? Koi8rDecoder(allowInvalid: true)
      : Koi8rDecoder(allowInvalid: false);

  @override
  // TODO: implement encoder
  Koi8rEncoder get encoder => allowInvalid
      ? Koi8rEncoder(allowInvalid: true)
      : Koi8rEncoder(allowInvalid: false);

  @override
  String get name => "KOI8-R";
}

class Koi8rDecoder extends KoiDecoder {
  const Koi8rDecoder({
    bool allowInvalid = false,
  }) : super(_koi8_r_symbols, allowInvalid: allowInvalid);
}

class Koi8rEncoder extends KoiEncoder {

  Koi8rEncoder({
    bool allowInvalid = false,
  }) : super(_koi8_rSymbolMap, allowInvalid: allowInvalid);

}
