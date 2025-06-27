import 'package:flutter/material.dart';

const Widget emptyWidget = SizedBox.shrink();

Widget verticalSpace(
  double height, {
  bool visible = true,
}) {
  return Visibility(
    visible: visible,
    child: SizedBox(height: height),
  );
}

Widget horizontalSpace(
  double width, {
  bool visible = true,
}) {
  return Visibility(
    visible: visible,
    child: SizedBox(width: width),
  );
}
