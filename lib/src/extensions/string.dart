import 'list.dart';

extension HelperStringNotNullExtensions on String {
  String get toCapitalizeFirstLetters {
    return trim()
        .split(' ')
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join(' ');
  }

  String toSnakeCase() {
    return replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (Match m) => '${m[1]}_${m[2]}',
    ).toLowerCase();
  }

  String toKebabCase() {
    return replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (Match m) => '${m[1]}-${m[2]}',
    ).toLowerCase();
  }

  String toSpaceSeparated() {
    return replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (Match m) => '${m[1]} ${m[2]}',
    ).toLowerCase();
  }

  String toSpaceSeparatedWithCapitalize() {
    return toSpaceSeparated().toCapitalizeFirstLetters;
  }
}

extension HelperStringExtensions on String? {
  bool get isNotEmptyOrNull {
    return this != null && this!.isNotEmpty;
  }

  bool get isEmptyOrNull {
    return this == null || this!.isEmpty;
  }

  String get toFirstLetters {
    if (isEmptyOrNull) {
      return '';
    }

    return this!.split(' ').map((e) {
      if (e.trim().isNotEmpty) {
        return e.trim()[0].toUpperCase();
      }
      return '';
    }).join();
  }

  String get limitTo255Characters {
    const maxLength = 255;

    if (this == null) return '';

    if (this!.length <= maxLength) {
      return this!;
    } else {
      return this!.substring(0, maxLength);
    }
  }

  bool isInEnglish() {
    if (this != null) {
      final englishRegExp =
          RegExp(r"^[a-zA-Z0-9.,!?&\n@|/\-+()%#$^*=_:;{}[ ]+$");
      return englishRegExp.hasMatch(this!);
    }
    return false;
  }

  String? get extension {
    if (this?.split('.').isNotEmptyOrNull == true) {
      return this!.split('.').last;
    }
    return null;
  }

  String? get fileName {
    if (this?.split('/').isNotEmptyOrNull == true) {
      return this!.split('/').last;
    }
    return null;
  }

  String? get fileNameWithoutExtension {
    if (fileName.isNotEmptyOrNull) {
      return fileName!.split('.').first;
    }
    return null;
  }

  String? get toCapitalizeFirstLetters {
    if (this?.isNotEmptyOrNull == true) {
      return this!
          .trim()
          .split(' ')
          .map((e) => e[0].toUpperCase() + e.substring(1))
          .join(' ');
    }
    return null;
  }

  bool get isValidUrl {
    if (isNotEmptyOrNull) {
      final uri = Uri.tryParse(this!);
      return uri!.hasScheme && uri.hasAuthority;
    }

    return false;
  }
}
