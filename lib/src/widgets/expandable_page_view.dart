import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandablePageView extends StatefulWidget {
  final List<Widget>? children;
  final int? itemCount;
  final IndexedWidgetBuilder? itemBuilder;
  final PageController? controller;
  final ValueChanged<int>? onPageChanged;
  final bool reverse;
  final Duration animationDuration;
  final Curve animationCurve;
  final ScrollPhysics? physics;
  final bool pageSnapping;
  final DragStartBehavior dragStartBehavior;
  final bool allowImplicitScrolling;
  final String? restorationId;
  final Clip clipBehavior;
  final bool animateFirstPage;
  final Alignment alignment;
  final double estimatedPageSize;
  final ScrollBehavior? scrollBehavior;
  final Axis scrollDirection;
  final bool padEnds;

  const ExpandablePageView({
    required this.children,
    this.controller,
    this.onPageChanged,
    this.reverse = false,
    this.animationDuration = const Duration(milliseconds: 100),
    this.animationCurve = Curves.easeInOutCubic,
    this.physics,
    this.pageSnapping = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.animateFirstPage = false,
    this.estimatedPageSize = 0.0,
    this.alignment = Alignment.topCenter,
    this.scrollBehavior,
    this.scrollDirection = Axis.horizontal,
    this.padEnds = true,
    super.key,
  })  : assert(estimatedPageSize >= 0.0),
        itemBuilder = null,
        itemCount = null;

  const ExpandablePageView.builder({
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.onPageChanged,
    this.reverse = false,
    this.animationDuration = const Duration(milliseconds: 100),
    this.animationCurve = Curves.easeInOutCubic,
    this.physics,
    this.pageSnapping = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.animateFirstPage = false,
    this.estimatedPageSize = 0.0,
    this.alignment = Alignment.topCenter,
    this.scrollBehavior,
    this.scrollDirection = Axis.horizontal,
    this.padEnds = true,
    super.key,
  })  : assert(estimatedPageSize >= 0.0),
        children = null;

  @override
  State<ExpandablePageView> createState() => _ExpandablePageViewState();
}

class _ExpandablePageViewState extends State<ExpandablePageView> {
  late PageController _pageController;
  late List<double> _sizes;
  int _currentPage = 0;
  int _previousPage = 0;
  bool _shouldDisposePageController = false;
  bool _firstPageLoaded = false;

  double get _currentSize => _sizes[_currentPage];

  double get _previousSize => _sizes[_previousPage];

  bool get isBuilder => widget.itemBuilder != null;

  bool get _isHorizontalScroll => widget.scrollDirection == Axis.horizontal;

  @override
  void initState() {
    super.initState();
    _sizes = _prepareSizes();
    _pageController = widget.controller ?? PageController();
    _pageController.addListener(_updatePage);
    _currentPage = _pageController.initialPage.clamp(0, _sizes.length - 1);
    _previousPage = _currentPage - 1 < 0 ? 0 : _currentPage - 1;
    _shouldDisposePageController = widget.controller == null;
  }

  @override
  void didUpdateWidget(covariant ExpandablePageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_updatePage);
      _pageController = widget.controller ?? PageController();
      _pageController.addListener(_updatePage);
      _shouldDisposePageController = widget.controller == null;
    }
    if (_shouldReinitializeHeights(oldWidget)) {
      _reinitializeSizes();
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_updatePage);
    if (_shouldDisposePageController) {
      _pageController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: widget.animationCurve,
      duration: _getDuration(),
      tween: Tween<double>(begin: _previousSize, end: _currentSize),
      builder: (context, value, child) => SizedBox(
        height: _isHorizontalScroll ? value : null,
        width: !_isHorizontalScroll ? value : null,
        child: child,
      ),
      child: _buildPageView(),
    );
  }

  bool _shouldReinitializeHeights(ExpandablePageView oldWidget) {
    if (oldWidget.itemBuilder != null && isBuilder) {
      return oldWidget.itemCount != widget.itemCount;
    }
    return oldWidget.children?.length != widget.children?.length;
  }

  void _reinitializeSizes() {
    final currentPageSize = _sizes[_currentPage];
    _sizes = _prepareSizes();

    if (_currentPage >= _sizes.length) {
      final differenceFromPreviousToCurrent = _previousPage - _currentPage;
      _currentPage = _sizes.length - 1;
      widget.onPageChanged?.call(_currentPage);

      _previousPage = (_currentPage + differenceFromPreviousToCurrent)
          .clamp(0, _sizes.length - 1);
    }

    _previousPage = _previousPage.clamp(0, _sizes.length - 1);
    _sizes[_currentPage] = currentPageSize;
  }

  Duration _getDuration() {
    if (_firstPageLoaded) {
      return widget.animationDuration;
    }
    return widget.animateFirstPage ? widget.animationDuration : Duration.zero;
  }

  Widget _buildPageView() {
    if (isBuilder) {
      return PageView.builder(
        controller: _pageController,
        itemBuilder: _itemBuilder,
        itemCount: widget.itemCount,
        onPageChanged: widget.onPageChanged,
        reverse: widget.reverse,
        physics: widget.physics,
        pageSnapping: widget.pageSnapping,
        dragStartBehavior: widget.dragStartBehavior,
        allowImplicitScrolling: widget.allowImplicitScrolling,
        restorationId: widget.restorationId,
        clipBehavior: widget.clipBehavior,
        scrollBehavior: widget.scrollBehavior,
        scrollDirection: widget.scrollDirection,
        padEnds: widget.padEnds,
      );
    }
    return PageView(
      controller: _pageController,
      onPageChanged: widget.onPageChanged,
      reverse: widget.reverse,
      physics: widget.physics,
      pageSnapping: widget.pageSnapping,
      dragStartBehavior: widget.dragStartBehavior,
      allowImplicitScrolling: widget.allowImplicitScrolling,
      restorationId: widget.restorationId,
      clipBehavior: widget.clipBehavior,
      scrollBehavior: widget.scrollBehavior,
      scrollDirection: widget.scrollDirection,
      padEnds: widget.padEnds,
      children: _sizeReportingChildren(),
    );
  }

  List<double> _prepareSizes() {
    if (isBuilder) {
      return List.filled(widget.itemCount!, widget.estimatedPageSize);
    } else {
      return widget.children!.map((child) => widget.estimatedPageSize).toList();
    }
  }

  void _updatePage() {
    final newPage = _pageController.page!.round();
    if (_currentPage != newPage) {
      setState(() {
        _firstPageLoaded = true;
        _previousPage = _currentPage;
        _currentPage = newPage;
      });
    }
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final item = widget.itemBuilder!(context, index);
    return OverflowPage(
      onSizeChange: (size) => setState(
        () => _sizes[index] = _isHorizontalScroll ? size.height : size.width,
      ),
      alignment: widget.alignment,
      scrollDirection: widget.scrollDirection,
      child: item,
    );
  }

  List<Widget> _sizeReportingChildren() => widget.children!
      .asMap()
      .map(
        (index, child) => MapEntry(
          index,
          OverflowPage(
            onSizeChange: (size) => setState(
              () => _sizes[index] =
                  _isHorizontalScroll ? size.height : size.width,
            ),
            alignment: widget.alignment,
            scrollDirection: widget.scrollDirection,
            child: child,
          ),
        ),
      )
      .values
      .toList();
}

class OverflowPage extends StatelessWidget {
  final ValueChanged<Size> onSizeChange;
  final Widget child;
  final Alignment alignment;
  final Axis scrollDirection;

  const OverflowPage({
    super.key,
    required this.onSizeChange,
    required this.child,
    required this.alignment,
    required this.scrollDirection,
  });

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minHeight: scrollDirection == Axis.horizontal ? 0 : null,
      minWidth: scrollDirection == Axis.vertical ? 0 : null,
      maxHeight: scrollDirection == Axis.horizontal ? double.infinity : null,
      maxWidth: scrollDirection == Axis.vertical ? double.infinity : null,
      alignment: alignment,
      child: SizeReportingWidget(
        onSizeChange: onSizeChange,
        child: child,
      ),
    );
  }
}

class SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const SizeReportingWidget({
    super.key,
    required this.child,
    required this.onSizeChange,
  });

  @override
  State<SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  final _widgetKey = GlobalKey();
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Container(
          key: _widgetKey,
          child: widget.child,
        ),
      ),
    );
  }

  void _notifySize() {
    final context = _widgetKey.currentContext;
    if (context == null) return;
    final size = context.size;
    if (_oldSize != size) {
      _oldSize = size;
      widget.onSizeChange(size!);
    }
  }
}
