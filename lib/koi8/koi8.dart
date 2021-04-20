import 'package:enough_convert/base.dart';

/// Contains base classes for windows codepage codecs

/// Provides a windows codepage decoder.
class KoiDecoder extends BaseDecoder {
  /// Creates a new windows codepage decoder.
  /// The [symbols] need to be exactly `128` characters long.
  /// Set [allowedInvalid] to true in case invalid characters sequences should be at least readable.
  const KoiDecoder(String symbols, {bool allowInvalid = false})
      : super(symbols, 0xBF, allowInvalid: allowInvalid);
}

/// Provides a simple, non chunkable iso-8859-XX encoder.
class KoiEncoder extends BaseEncoder {
  /// Creates a new windows codepage encoder.
  /// Set [allowedInvalid] to true in case invalid characters should be translated to question marks.
  const KoiEncoder(Map<int, int> encodingMap, {bool allowInvalid = false})
      : super(encodingMap, 0xBF, allowInvalid: allowInvalid);
}
