## 1.6.0
- Add cp-850 / DOS-Latin-1 encoding support.
- Improve documentation.

## 1.5.0
- Thanks to [bobaxix](https://github.com/bobaxix) both KOI8-R as well as KOI8-U codecs are now supported.
- Add support for [big5](https://en.wikipedia.org/wiki/Big5) encoding by forking https://github.com/douasin/big5-dart.
- Restructure the package to hide implementation details - in doubt `import 'package:enough_convert/enough_convert.dart';`.
- Improve documentation and code style

## 1.4.0
- Thanks to [moheb2000](https://github.com/moheb2000) now the Windows-1256 codec (Persian) works as expected.

## 1.3.0
- Add support the following encoding thanks to [habbas11](https://github.com/habbas11):
  * Windows-1256 / cp-1256

## 1.2.0
- Add support the following encodings:
  * Windows-1253 / cp-1253
  * Windows-1254 / cp-1254


## 1.1.0
- Support chunked conversion

## 1.0.0
- Add null-safety

## 0.10.0

- Decoding data does not change the data anymore, as this is not expected behavior 
- Forked [fast_gbk](https://github.com/lixiangthinker/fast_gbk) into enough_convert to support GBK and GB2312 encodings

## 0.9.0

- Initial version with support for ISO 8859 1-16, Windows 1250, 1251 and 1252 character encodings 
