// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert' as dart_convert;

import 'package:enough_convert/enough_convert.dart';

void main() {
  latin2();
  latin3();
  latin4();
  latin5();
  latin6();
  latin7();
  latin8();
  latin9();
  latin10();
  latin11();
  latin13();
  latin14();
  latin15();
  latin16();
  windows1250();
  windows1251();
  windows1252();
  windows1253();
  windows1254();
  gbk();
  koi8r();
  koi8u();
  big5();
  cp850();
}

// cSpell:disable

void latin2() {
  roundtrip(
      const Latin2Codec(allowInvalid: false), 'Těší mě, že vás poznávám!');
}

void latin3() {
  roundtrip(
      const Latin3Codec(allowInvalid: false), 'Tanıştığımıza memnun oldum!');
}

void latin4() {
  roundtrip(const Latin4Codec(allowInvalid: false), 'Priecājos iepazīties!');
}

void latin5() {
  roundtrip(const Latin5Codec(allowInvalid: false), 'Приятно встретиться!');
}

void latin6() {
  roundtrip(const Latin6Codec(allowInvalid: false), 'سعدت بلقائك');
}

void latin7() {
  roundtrip(
      const Latin7Codec(allowInvalid: false), 'Χαίρομαι που σας γνωρίζω!');
}

void latin8() {
  roundtrip(const Latin8Codec(allowInvalid: false),
      'נעים להכיר אותך.נעים להכיר אותך-.');
}

void latin9() {
  roundtrip(
      const Latin9Codec(allowInvalid: false), 'Tanıştığımıza memnun oldum!');
}

void latin10() {
  roundtrip(const Latin10Codec(allowInvalid: false), 'Hyggelig å møte deg!');
}

void latin11() {
  roundtrip(const Latin11Codec(allowInvalid: false), 'ยินดีที่ได้พบคุณ!');
}

void latin13() {
  roundtrip(const Latin13Codec(allowInvalid: false), 'Hyggelig å møte deg!');
}

void latin14() {
  roundtrip(const Latin14Codec(allowInvalid: false),
      'Má tú ag lorg cara gan locht, béidh tú gan cara go deo.');
}

void latin15() {
  roundtrip(
      const Latin15Codec(allowInvalid: false), 'Il faut être bête quand même.');
}

void latin16() {
  roundtrip(
      const Latin16Codec(allowInvalid: false), 'Örülök, hogy találkoztunk!');
}

void windows1250() {
  roundtrip(const Windows1250Codec(allowInvalid: false),
      'Teší ma, že vás spoznávam!');
}

void windows1251() {
  roundtrip(const Windows1251Codec(allowInvalid: false),
      'Радий познайомитися з Вами!');
}

void windows1252() {
  roundtrip(const Windows1252Codec(allowInvalid: false),
      'Il faut être bête quand même.');
}

void windows1253() {
  roundtrip(
      const Windows1253Codec(allowInvalid: false), 'Χαίρομαι που σας γνωρίζω!');
}

void windows1254() {
  roundtrip(const Windows1254Codec(allowInvalid: false),
      'Tanıştığımıza memnun oldum!');
}

void gbk() {
  roundtrip(const GbkCodec(allowInvalid: false), '白日依山尽，黄河入海流');
}

void koi8r() {
  roundtrip(
      const Koi8rCodec(allowInvalid: false), 'Радий познайомитися з Вами!');
}

void koi8u() {
  roundtrip(
      const Koi8uCodec(allowInvalid: false), 'Радий познайомитися з Вами!');
}

void big5() {
  roundtrip(const Big5Codec(allowInvalid: false), '傳統');
}

void cp850() {
  roundtrip(const CodePage850Codec(allowInvalid: false), '♥HELLÖ DOS WØRLD♥');
}

void roundtrip(dart_convert.Encoding codec, String input) {
  final encoded = codec.encode(input);
  final decoded = codec.decode([...encoded]);
  print('${codec.name}: encode "$input" to "$encoded"');
  print('${codec.name}: decode $encoded to "$decoded"');
}
