import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/ui_helpers.dart';

extension HelperListExtensions<T> on List<T>? {
  bool get isNotEmptyOrNull {
    return this != null && this!.isNotEmpty;
  }

  bool get isEmptyOrNull {
    return this == null || this!.isEmpty;
  }

  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this ?? <T>[]) {
      if (test(element)) return element;
    }
    return null;
  }

  String get toCommaSeparated {
    if (isNotEmptyOrNull) {
      List<String> list = [];
      for (var element in this!) {
        list.add(element.toString());
      }

      return list.join(', ');
    }
    return '';
  }

  List<List<T>> chunks(int size) {
    if (isNotEmptyOrNull) {
      final chunks = <List<T>>[];
      for (var i = 0; i < this!.length; i += size) {
        chunks.add(this!.sublist(i, min(this!.length, i + size)));
      }
      return chunks;
    }
    return <List<T>>[];
  }
}

extension HelperListExtensionsNotNull<T> on List<T> {
  List<List<T>> chunks(int size) {
    if (isNotEmptyOrNull) {
      final chunks = <List<T>>[];
      for (var i = 0; i < length; i += size) {
        chunks.add(sublist(i, min(length, i + size)));
      }
      return chunks;
    }
    return <List<T>>[];
  }
}

extension ListStringExtensions on List<String>? {
  String get toCommaSeparated {
    if (isNotEmptyOrNull) {
      return this!.join(', ');
    }
    return '';
  }
}

extension ListWidgetsExtensions on List<Widget> {
  List<Widget> withHorizontalSeparation(double? separation) {
    List<Widget> spacedChildren = [];

    for (int i = 0; i < length; i++) {
      var child = this[i];
      spacedChildren.add(child);
      if (i != length - 1) {
        spacedChildren.add(horizontalSpace(separation ?? 0));
      }
    }

    return spacedChildren;
  }

  List<Widget> withVerticalSeparation(double? separation) {
    List<Widget> spacedChildren = [];

    for (int i = 0; i < length; i++) {
      var child = this[i];
      spacedChildren.add(child);
      if (i != length - 1) {
        spacedChildren.add(verticalSpace(separation ?? 0));
      }
    }

    return spacedChildren;
  }

  List<Widget> withHorizontalSeparationBuilder(
    Widget Function() builder,
  ) {
    List<Widget> spacedChildren = [];

    for (int i = 0; i < length; i++) {
      var child = this[i];
      spacedChildren.add(child);
      if (i != length - 1) {
        spacedChildren.add(builder());
      }
    }

    return spacedChildren;
  }

  List<Widget> withVerticalSeparationBuilder(
    Widget Function() builder,
  ) {
    List<Widget> spacedChildren = [];

    for (int i = 0; i < length; i++) {
      var child = this[i];
      spacedChildren.add(child);
      if (i != length - 1) {
        spacedChildren.add(builder());
      }
    }

    return spacedChildren;
  }
}
