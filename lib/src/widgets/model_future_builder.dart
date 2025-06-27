import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_strings.dart';
import '../extensions/list.dart';
import '../extensions/widget.dart';

import 'conditional_widget.dart';

class ModelFutureBuilder<T> extends StatelessWidget {
  const ModelFutureBuilder({
    super.key,
    required this.busy,
    required this.data,
    required this.builder,
    this.errorBuilder,
    this.busyBuilder,
    this.onRefresh,
    this.error,
    this.isFullScreen = false,
    this.height,
    this.hasRefreshButton = true,
  });

  final bool busy;
  final T? data;
  final RefreshCallback? onRefresh;
  final bool isFullScreen;
  final dynamic error;
  final Widget Function(BuildContext context, String? error)? errorBuilder;
  final WidgetBuilder? busyBuilder;
  final ValueWidgetBuilder<T> builder;
  final double? height;
  final bool hasRefreshButton;

  @override
  Widget build(BuildContext context) {
    if (busy) {
      return busyBuilder != null
          ? busyBuilder!.call(context)
          : ModelBusyWidget(
              isFullScreen: isFullScreen,
              height: height,
            );
    } else {
      if (data == null) {
        return errorBuilder != null
            ? errorBuilder!.call(
                context,
                error ?? AppStrings.somethingWentWrong,
              )
            : ModelErrorWidget(
                onRefresh: hasRefreshButton ? onRefresh : null,
                error: error ?? AppStrings.somethingWentWrong,
                height: height,
                isFullScreen: isFullScreen,
              );
      } else {
        return onRefresh != null
            ? RefreshIndicator(
                onRefresh: onRefresh!,
                child: builder(context, data as T, null),
              )
            : builder(context, data as T, null);
      }
    }
  }
}

class ModelFutureListBuilder<T> extends StatelessWidget {
  const ModelFutureListBuilder({
    super.key,
    required this.busy,
    this.data,
    required this.builder,
    this.errorBuilder,
    this.busyBuilder,
    this.onRefresh,
    this.hasRefreshButton = true,
    this.error,
    this.isFullScreen = false,
    this.height,
  });

  final bool busy;
  final List<T>? data;
  final Widget Function(BuildContext context, String? error)? errorBuilder;
  final WidgetBuilder? busyBuilder;
  final RefreshCallback? onRefresh;
  final bool hasRefreshButton;
  final String? error;
  final ValueWidgetBuilder<List<T>> builder;
  final bool isFullScreen;
  final double? height;

  @override
  Widget build(BuildContext context) {
    if (busy) {
      return busyBuilder != null
          ? busyBuilder!.call(context)
          : ModelBusyWidget(
              isFullScreen: isFullScreen,
              height: height,
            );
    } else {
      if (data.isEmptyOrNull) {
        return errorBuilder != null
            ? errorBuilder!.call(
                context,
                error ?? AppStrings.somethingWentWrong,
              )
            : ModelErrorWidget(
                onRefresh: hasRefreshButton ? onRefresh : null,
                error: error ?? AppStrings.somethingWentWrong,
                height: height,
                isFullScreen: isFullScreen,
              );
      } else {
        return onRefresh != null
            ? RefreshIndicator(
                onRefresh: onRefresh!,
                child: builder(context, data!, null),
              )
            : builder(context, data!, null);
      }
    }
  }
}

class ModelBusyWidget extends StatelessWidget {
  const ModelBusyWidget({
    super.key,
    this.isFullScreen = false,
    this.padding,
    this.height,
    this.safeArea = false,
    this.appBar,
  });

  final bool isFullScreen;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final bool safeArea;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    if (isFullScreen) {
      return Scaffold(
        appBar: appBar ??
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
        extendBodyBehindAppBar: true,
        body: SizedBox.expand(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return ConditionalWrap(
      condition: safeArea,
      wrapper: (child) => SafeArea(child: child),
      child: Container(
        height: height,
        width: double.infinity,
        alignment: Alignment.center,
        padding: padding,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

class ModelErrorWidget extends StatelessWidget {
  const ModelErrorWidget({
    super.key,
    this.onRefresh,
    required this.error,
    this.isFullScreen = false,
    this.height,
    this.hasDelay = false,
    this.errorColor,
    this.safeArea = true,
    this.appBar,
  });

  final RefreshCallback? onRefresh;
  final dynamic error;
  final bool isFullScreen;
  final double? height;
  final bool hasDelay;
  final Color? errorColor;
  final bool safeArea;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    if (isFullScreen) {
      return Scaffold(
        appBar: appBar ??
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
        extendBodyBehindAppBar: true,
        body: SizedBox.expand(
          child: _getBody(context),
        ),
      );
    }

    return ConditionalWrap(
      condition: safeArea,
      wrapper: (child) => SafeArea(child: child),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: _getBody(context),
      ),
    );
  }

  Widget _getBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: onRefresh != null,
          child: OutlinedButton(
            onPressed: onRefresh,
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              visualDensity: VisualDensity.comfortable,
              tapTargetSize: MaterialTapTargetSize.padded,
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            ),
            child: const Text(
              AppStrings.refresh,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: onRefresh != null ? 10 : 0),
          child: Text(
            error?.toString() ?? "",
            textAlign: TextAlign.center,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: errorColor ?? Palette.grey('5F'),
            ),
          ),
        ),
      ],
    ).delayed(
      delay: hasDelay ? const Duration(milliseconds: 500) : Duration.zero,
    );
  }
}

class BusyOpacityWidget extends StatelessWidget {
  const BusyOpacityWidget({
    super.key,
    required this.isBusy,
    required this.child,
    this.busyWidget = const ModelBusyWidget(),
  });

  final bool isBusy;
  final Widget child;
  final Widget busyWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: isBusy ? 0 : 1,
          child: child,
        ),
        Visibility(
          visible: isBusy,
          child: busyWidget,
        ),
      ],
    );
  }
}
