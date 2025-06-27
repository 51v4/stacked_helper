import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../stacked_helper.dart';
import '../extensions/color.dart';

// int
int? parseToInt(dynamic value) {
  return value != null ? int.tryParse(value.toString()) : null;
}

//String
String? parseToString(dynamic value) {
  if (value == null) {
    return null;
  } else if (value is String) {
    return value;
  } else if (value is Map<String, dynamic>) {
    try {
      return jsonEncode(value);
    } catch (e) {
      return value.toString();
    }
  } else {
    return value!.toString();
  }
}

// double
double? parseToDouble(dynamic value) {
  return value != null ? double.tryParse(value.toString()) : null;
}

// bool
bool? parseToBool(dynamic value) {
  return value != null
      ? bool.tryParse(value.toString(), caseSensitive: false)
      : null;
}

//DateTime
DateTime? parseToDateTime(dynamic value, {String? format}) {
  try {
    var valueStr = parseToString(value);
    if (valueStr.isNotEmptyOrNull) {
      if (format != null) {
        return DateFormat(format).parse(value.toString());
      }
      return value != null ? DateTime.tryParse(value.toString()) : null;
    }
  } catch (e) {
    debugPrint("DateTime parse error: $e");
  }
  return null;
}

// TimeOfDay
TimeOfDay? parseToTimeOfDay(dynamic value) {
  try {
    if (value == null) return null;
    final format = RegExp(r'(\d{1,2}):(\d{2})\s*([APMapm]{2})');
    final match = format.firstMatch(value);

    if (match != null) {
      var hour = parseToInt(match.group(1));
      var minute = parseToInt(match.group(2));
      var period = match.group(3)?.toUpperCase();

      if (hour != null && minute != null && period != null) {
        if (period == 'PM' && hour != 12) {
          hour += 12;
        } else if (period == 'AM' && hour == 12) {
          hour = 0;
        }

        return TimeOfDay(hour: hour, minute: minute);
      } else {
        debugPrint('Invalid time format');
      }
    } else {
      debugPrint('Invalid time format');
    }
  } catch (e) {
    debugPrint("TimeOfDay parse error: $e");
  }
  return null;
}

// TextInputType
TextInputType? parseToTextInputType(dynamic value) {
  var i = parseToInt(value);

  return i != null && i < TextInputType.values.length
      ? TextInputType.values[i]
      : null;
}

int? formatToTextInputType(TextInputType? value) {
  return (value != null) ? TextInputType.values.indexOf(value) : null;
}

// List of Object
List<T>? parseToList<T>(
  dynamic values,
  T? Function(Map<String, dynamic> map) fromJson, {
  bool acceptObject = false,
}) {
  List<T> valueList = [];
  if (values is List) {
    for (var v in values) {
      if (v is Map<String, dynamic>) {
        var item = fromJson(v);
        if (item != null) {
          valueList.add(item);
        }
      }
    }
    return valueList;
  }
  if (values is Map<String, dynamic> && acceptObject) {
    var item = parseToObject<T>(
      values,
      fromJson,
    );

    if (item != null) {
      valueList.add(item);
    }

    return valueList;
  }
  return null;
}

// Parse to Object
T? parseToObject<T>(
  dynamic value,
  T? Function(Map<String, dynamic> map) fromJson,
) {
  try {
    if (value is Map<String, dynamic>) {
      return fromJson(value);
    } else {
      if (value != null) {
        debugPrint(
          "parseToObject type error - Type: ${value.runtimeType}, Value: $value",
        );
      }
    }
  } catch (e) {
    debugPrint("parseToObject error: $e");
  }
  return null;
}

// Parse to Object from String
T? parseToObjectFromString<T>(
  dynamic value,
  T? Function(String? value) fromJson,
) {
  try {
    return fromJson(parseToString(value));
  } catch (e) {
    debugPrint("parseToObjectFromString error: $e");
  }
  return null;
}

// List of Data Types, Use this for list of int, String, double, Color
List<T>? parseToListOfField<T>(
  dynamic values,
  T? Function(dynamic value) parseValue,
) {
  List<T> valueList = [];
  if (values is List) {
    for (var v in values) {
      var item = parseValue(v);
      if (item != null) {
        valueList.add(item);
      }
    }
    return valueList;
  }
  return null;
}

Color? parseToColor(dynamic value) {
  if (value != null) {
    String colorString = value.toString().toUpperCase().replaceAll(' ', '');

    if (colorString.startsWith('#')) {
      colorString = colorString.replaceFirst('#', '');

      if (colorString.length == 3) {
        colorString = colorString.split('').map((char) => char * 2).join();
      } else if (colorString.length == 4) {
        colorString = colorString.split('').map((char) => char * 2).join();
      }

      if (colorString.length == 6) {
        colorString = 'FF$colorString';
      }

      return Color(int.tryParse(colorString, radix: 16) ?? 0x00000000);
    }

    if (colorString.startsWith('0X')) {
      colorString = colorString.replaceFirst('0X', '');

      if (colorString.length == 8) {
        return Color(int.tryParse(colorString, radix: 16) ?? 0x00000000);
      }

      if (colorString.length == 6) {
        return Color(int.tryParse('FF$colorString', radix: 16) ?? 0x00000000);
      }
    }

    return Color(int.tryParse(colorString) ?? 0x00000000);
  }

  return null;
}

String? formatFromColor(Color? color) {
  if (color != null) {
    return color.toInt32
        .toRadixString(16)
        .padLeft(6, '0')
        .replaceRange(0, 2, "0xff");
  }
  return null;
}

//Map
Map<String, dynamic>? parseToMap(
  dynamic value,
) {
  if (value is Map) {
    Map mapValue = value;
    Map<String, dynamic> map = {};
    mapValue.forEach((key, value) {
      var k = parseToString(key);
      if (k.isNotEmptyOrNull) {
        map[k!] = value;
      }
    });
    return map;
  }
  return null;
}

T? parseToEnum<T extends Enum>(dynamic value, List<T> values) {
  String? valueStr = parseToString(value)
      ?.replaceAll(RegExp(r'[_-]'), '')
      .toLowerCase()
      .trim();

  if (valueStr.isNotEmptyOrNull) {
    for (var e in values) {
      if (e.name.toLowerCase() == valueStr) return e;
    }
  }
  return null;
}

String? formatEnum<T extends Enum>(
  T? value, {
  bool isHyphenated = false,
}) {
  if (value != null) {
    return isHyphenated ? value.name.toKebabCase() : value.name.toSnakeCase();
  }
  return null;
}
