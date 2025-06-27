import 'package:flutter/material.dart';

class HasScrollBuilder extends StatefulWidget {
  const HasScrollBuilder({
    super.key,
    required this.builder,
    this.defaultValue = false,
  });

  final bool defaultValue;
  final Widget Function(BuildContext context, bool hasScroll) builder;

  @override
  State<HasScrollBuilder> createState() => _HasScrollBuilderState();
}

class _HasScrollBuilderState extends State<HasScrollBuilder> {
  bool hasScroll = false;

  @override
  void initState() {
    super.initState();
    hasScroll = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (scrollNotification) {
        setState(() {
          hasScroll = scrollNotification.metrics.maxScrollExtent > 0;
        });
        return false;
      },
      child: widget.builder(context, hasScroll),
    );
  }
}
