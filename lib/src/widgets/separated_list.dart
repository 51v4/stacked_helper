import 'dart:math' as math;

import 'package:flutter/material.dart';

class SeparatedWidgetList<E> extends StatelessWidget {
  const SeparatedWidgetList({
    super.key,
    this.list,
    required this.builder,
    this.separation,
    this.direction = Axis.vertical,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.separationBuilder,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.headerBuilder,
    this.footerBuilder,
    this.isWrap = false,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapCrossAlignment = WrapCrossAlignment.start,
    this.wrapSpacing = 0,
    this.wrapRunSpacing = 0,
    this.wrapRunAlignment = WrapAlignment.start,
    this.headerFooterSeparation = false,
    this.showHeaderAndFooterIfEmpty = false,
  });

  final List<E>? list;
  final Axis direction;
  final double? separation;
  final Widget Function(E item, int index) builder;
  final Widget Function(int? index)? separationBuilder;
  final Widget Function()? headerBuilder;
  final Widget Function()? footerBuilder;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool isWrap;
  final WrapAlignment wrapAlignment;
  final WrapCrossAlignment wrapCrossAlignment;
  final double wrapSpacing;
  final double wrapRunSpacing;
  final WrapAlignment wrapRunAlignment;
  final bool headerFooterSeparation;
  final bool showHeaderAndFooterIfEmpty;

  @override
  Widget build(BuildContext context) {
    if (isWrap) {
      return Wrap(
        alignment: wrapAlignment,
        crossAxisAlignment: wrapCrossAlignment,
        spacing: wrapSpacing,
        runSpacing: wrapRunSpacing,
        direction: direction,
        runAlignment: wrapRunAlignment,
        children: widgetList,
      );
    }

    if (direction == Axis.vertical) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: widgetList,
      );
    } else {
      return Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: widgetList,
      );
    }
  }

  Widget _buildSeparationWidget(int? itemIndex) {
    if (separationBuilder != null) {
      return separationBuilder!(itemIndex);
    } else {
      if (direction == Axis.vertical) {
        return SizedBox(height: separation);
      } else {
        return SizedBox(width: separation);
      }
    }
  }

  List<Widget> get widgetList {
    var wl = List.generate(
      computeActualChildCountForSeparated(list?.length ?? 0),
      (index) {
        int itemIndex = index ~/ 2;
        var item = list![itemIndex];

        if (index.isOdd) {
          return _buildSeparationWidget(itemIndex);
        }

        return builder(item, itemIndex);
      },
    );

    if (wl.isNotEmpty || showHeaderAndFooterIfEmpty) {
      if (headerBuilder != null) {
        wl.insert(0, headerBuilder!());
        if (headerFooterSeparation && wl.length > 1) {
          wl.insert(1, _buildSeparationWidget(null));
        }
      }
      if (footerBuilder != null) {
        if (headerFooterSeparation && wl.isNotEmpty) {
          wl.add(_buildSeparationWidget(null));
        }
        wl.add(footerBuilder!());
      }
    }
    return wl;
  }

  int computeActualChildCountForSeparated(int itemCount) {
    return math.max(0, itemCount * 2 - 1);
  }
}
