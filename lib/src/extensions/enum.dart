import 'string.dart';

extension HelperEnumExtensions on Enum {
  String get label {
    return name.toSpaceSeparatedWithCapitalize();
  }
}
