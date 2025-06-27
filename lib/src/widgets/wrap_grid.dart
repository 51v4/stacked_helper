import 'package:flutter/material.dart';

class WrapGrid extends StatelessWidget {
  final List<Widget>? children;
  final int? itemCount;
  final IndexedWidgetBuilder? itemBuilder;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final Clip clipBehavior;
  final WrapCrossAlignment crossAxisAlignment;

  const WrapGrid({
    super.key,
    required this.children,
    required this.crossAxisCount,
    this.crossAxisSpacing = 0.0,
    this.mainAxisSpacing = 0.0,
    this.padding,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.clipBehavior = Clip.none,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  })  : itemBuilder = null,
        itemCount = null,
        assert(children != null);

  const WrapGrid.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.crossAxisCount,
    this.crossAxisSpacing = 0.0,
    this.mainAxisSpacing = 0.0,
    this.padding,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.clipBehavior = Clip.none,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  })  : children = null,
        assert(itemCount != null && itemBuilder != null);

  @override
  Widget build(BuildContext context) {
    final items = children ??
        List.generate(
          itemCount!,
          (index) => itemBuilder!(context, index),
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSpacing = (crossAxisCount - 1) * crossAxisSpacing;
        final itemWidth =
            (constraints.maxWidth - totalSpacing) / crossAxisCount;

        return Container(
          padding: padding ?? EdgeInsets.zero,
          child: Wrap(
            spacing: crossAxisSpacing,
            runSpacing: mainAxisSpacing,
            alignment: alignment,
            runAlignment: runAlignment,
            clipBehavior: clipBehavior,
            crossAxisAlignment: crossAxisAlignment,
            children: items.map(
              (child) {
                return SizedBox(
                  width: itemWidth,
                  child: child,
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
