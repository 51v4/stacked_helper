import 'package:flutter/material.dart';

import '../../stacked_helper.dart';

class If extends StatelessWidget {
  const If({
    super.key,
    required this.builder,
    required this.condition,
    this.replacement = emptyWidget,
  });

  final bool condition;
  final Widget Function(BuildContext context) builder;
  final Widget replacement;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return builder(context);
    }

    return replacement;
  }
}

class IfNotNull<T> extends StatelessWidget {
  const IfNotNull({
    super.key,
    required this.value,
    required this.builder,
    this.condition,
    this.replacement = emptyWidget,
  });

  final T? value;
  final bool Function(T value)? condition;
  final Widget Function(BuildContext context, T value) builder;
  final Widget replacement;

  @override
  Widget build(BuildContext context) {
    if (value != null) {
      if ((condition?.call(value as T) ?? true)) {
        return builder(context, value as T);
      }
    }
    return replacement;
  }
}

typedef Wrapper = Widget Function(Widget child);

class ConditionalWrap extends StatelessWidget {
  const ConditionalWrap({
    super.key,
    required this.condition,
    required this.wrapper,
    this.fallback,
    required this.child,
  });

  final bool condition;

  final Wrapper wrapper;

  final Wrapper? fallback;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return wrapper(child);
    } else if (fallback != null) {
      return fallback!(child);
    } else {
      return child;
    }
  }
}

class IfColumn extends StatelessWidget {
  const IfColumn({
    super.key,
    required this.children,
    required this.condition,
    this.replacement = emptyWidget,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final bool condition;
  final List<Widget> Function(BuildContext context) children;
  final Widget replacement;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: children(context),
      );
    }

    return replacement;
  }
}

class IfRow extends StatelessWidget {
  const IfRow({
    super.key,
    required this.children,
    required this.condition,
    this.replacement = emptyWidget,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final bool condition;
  final List<Widget> Function(BuildContext context) children;
  final Widget replacement;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: children(context),
      );
    }

    return replacement;
  }
}
