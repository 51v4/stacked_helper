import 'dart:async';

import 'package:flutter/material.dart';

class AutoScrollingPageView extends StatefulWidget {
  final Widget child;
  final PageController controller;
  final int duration;
  final bool autoScroll;
  final int itemCount;
  final bool handleLoop;

  const AutoScrollingPageView({
    super.key,
    required this.child,
    required this.controller,
    this.duration = 3,
    this.autoScroll = true,
    required this.itemCount,
    this.handleLoop = false,
  });

  @override
  State<AutoScrollingPageView> createState() => _AutoScrollingPageViewState();
}

class _AutoScrollingPageViewState extends State<AutoScrollingPageView>
    with SingleTickerProviderStateMixin {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoScroll) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: widget.duration),
      (timer) {
        var currentPage = widget.controller.page?.floor() ?? 0;
        if (widget.handleLoop) {
          widget.controller.animateToPage(
            (currentPage + 1) % widget.itemCount,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        } else {
          widget.controller.animateToPage(
            currentPage + 1,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
