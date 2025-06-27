import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tools/screen_size.dart';

abstract class Palette {
  static Color blackWithAlpha(String value) {
    return Color(int.parse("0x${value}000000"));
  }

  static Color whiteWithAlpha(String value) {
    return Color(int.parse("0x${value}FFFFFF"));
  }

  static Color grey(String value) {
    return Color(int.parse('0xFF$value$value$value'));
  }
}

const kcSystemOverlayDark = SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
);

const kcSystemOverlayLight = SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
);

TextStyle get defaultErrorTextStyle {
  return Theme.of(ScreenSize.currentContext)
      .textTheme
      .bodySmall!
      .copyWith(color: defaultErrorColor);
}

Color get defaultErrorColor {
  return Theme.of(ScreenSize.currentContext).colorScheme.error;
}
