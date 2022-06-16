Support for character encodings / charsets / codecs missing from `dart:convert`.

Supports the following encodings:
* Latin / ISO 8859 encodings:
  * Latin 1 / ISO 8859-1
  * Latin 2 / ISO 8859-2
  * Latin 3 / ISO 8859-3
  * Latin 4 / ISO 8859-4
  * Latin 5 / ISO 8859-5
  * Latin 6 / ISO 8859-6
  * Latin 7 / ISO 8859-7
  * Latin 8 / ISO 8859-8
  * Latin 9 / ISO 8859-9
  * Latin 10 / ISO 8859-10
  * Latin 11 / ISO 8859-11
  * Latin 13 / ISO 8859-13
  * Latin 14 / ISO 8859-14
  * Latin 15 / ISO 8859-15
  * Latin 16 / ISO 8859-16
* Windows Codepage Encodings:
  * Windows-1250 / cp-1250
  * Windows-1251 / cp-1251
  * Windows-1252 / cp-1252
  * Windows-1253 / cp-1253
  * Windows-1254 / cp-1254
  * Windows-1256 / cp-1256
* DOS Codepage Encodings:
  * cp-850
* GBK (compatible with GB-2312)
* KOI8
  * KOI8-R
  * KOI8-U
* Big5

## Usage

Using `enough_convert` is pretty straight forward:

```dart
import 'package:enough_convert/enough_convert.dart';

main() {
  final codec = const Windows1252Codec(allowInvalid: false);
  final input = 'Il faut être bête quand même.';
  final encoded = codec.encode(input);
  final decoded = codec.decode([...encoded]);
  print('${codec.name}: encode "$input" to "$encoded"');
  print('${codec.name}: decode $encoded to "$decoded"');

}
```

## Installation
Add this dependency your pubspec.yaml file:

```
dependencies:
  enough_convert: ^1.6.0
```
The latest version or `enough_convert` is [![enough_convert version](https://img.shields.io/pub/v/enough_convert.svg)](https://pub.dartlang.org/packages/enough_convert).


## Wait, what is this about?

Dylan (not associated with this project in any way) explains the world of text encoding quite well:
[![Plain text? Really?](https://img.youtube.com/vi/_mZBa3sqTrI/0.jpg)](https://www.youtube.com/watch?v=_mZBa3sqTrI)


## It's 2022, do we still need this?

Short answer: yes.

Long answer: yes, there are still many web pages, emails and other content out there that is encoded in various text encodings.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Enough-Software/enough_convert/issues

## Null-Safety
enough_convert is null-safe from v1.0.0 onward.

## License
`enough_convert` is licensed under the commercial friendly [Mozilla Public License 2.0](LICENSE)
