Support for character encodings, charsets and codecs missing from `dart:convert`.

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
* GBK (compatible with GB 2312)


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
  enough_convert: ^0.10.0
```
The latest version or `enough_convert` is [![enough_convert version](https://img.shields.io/pub/v/enough_convert.svg)](https://pub.dartlang.org/packages/enough_convert).


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Enough-Software/enough_convert/issues

## License
`enough_convert` is licensed under the commercial friendly [Mozilla Public License 2.0](LICENSE)
