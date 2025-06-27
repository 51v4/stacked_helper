import 'package:flutter/material.dart';

import '../common/app_strings.dart';

class ReadMoreWrapper extends StatefulWidget {
  final Widget child;
  final double collapsedHeight;
  final Duration animationDuration;
  final String readMoreText;
  final String readLessText;
  final Color? backgroundColor;

  const ReadMoreWrapper({
    super.key,
    required this.child,
    this.collapsedHeight = 150,
    this.animationDuration = const Duration(milliseconds: 300),
    this.readMoreText = AppStrings.readMore,
    this.readLessText = AppStrings.readLess,
    this.backgroundColor,
  });

  @override
  State<ReadMoreWrapper> createState() => _ReadMoreWrapperState();
}

class _ReadMoreWrapperState extends State<ReadMoreWrapper>
    with TickerProviderStateMixin {
  bool _expanded = false;
  final GlobalKey _childKey = GlobalKey();
  double? _childHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureChildHeight());
  }

  void _measureChildHeight() {
    final context = _childKey.currentContext;
    if (context != null && mounted) {
      final size = context.size;
      if (size != null) {
        setState(() {
          _childHeight = size.height;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOverflowing =
        _childHeight != null && _childHeight! > widget.collapsedHeight;
    final backgroundColor =
        widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: widget.animationDuration,
          curve: Curves.ease,
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              ConstrainedBox(
                constraints: _expanded || !isOverflowing
                    ? const BoxConstraints()
                    : BoxConstraints(maxHeight: widget.collapsedHeight),
                child: SizedBox(
                  key: _childKey,
                  width: double.infinity,
                  child: widget.child,
                ),
              ),
              if (!_expanded && isOverflowing)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 40,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            backgroundColor.withValues(alpha: 0.0),
                            backgroundColor.withValues(alpha: 0.3),
                            backgroundColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (isOverflowing)
          TextButton(
            onPressed: () {
              setState(() => _expanded = !_expanded);
            },
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              _expanded ? widget.readLessText : widget.readMoreText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}
