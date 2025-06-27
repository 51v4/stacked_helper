import 'package:flutter/widgets.dart';

typedef BuilderWithElevation = Widget Function(
  BuildContext context,
  double elevation,
);

class ScrollActivatedElevation extends StatefulWidget {
  const ScrollActivatedElevation({
    required this.builder,
    this.elevationInitial = 0,
    this.elevationScrolled = 4,
    super.key,
    this.enabled = true,
    this.axis = Axis.vertical,
  });

  final double elevationInitial;
  final double elevationScrolled;
  final BuilderWithElevation builder;
  final bool enabled;
  final Axis axis;

  @override
  State<ScrollActivatedElevation> createState() {
    return _ScrollActivatedElevationState();
  }
}

class _ScrollActivatedElevationState extends State<ScrollActivatedElevation> {
  late double _elevation;

  @override
  void initState() {
    super.initState();
    _elevation = widget.elevationInitial;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
      return NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == widget.axis) {
            final scrolledPixels = notification.metrics.extentBefore;
            final newElevation = scrolledPixels > 1
                ? widget.elevationScrolled
                : widget.elevationInitial;
            if (_elevation != newElevation) {
              setState(() {
                _elevation = newElevation;
              });
            }
          }

          return false;
        },
        child: widget.builder(context, _elevation),
      );
    }
    return widget.builder(context, 0);
  }
}
