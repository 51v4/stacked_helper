import 'package:flutter/widgets.dart';

import '../widgets/ui_helpers.dart';

extension HelperWidgetExtensions on Widget {
  Widget delayed({
    Duration delay = const Duration(milliseconds: 500),
    Widget initialWidget = emptyWidget,
  }) {
    return FutureBuilder(
      future: Future.delayed(delay, () => true),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return this;
        } else {
          return initialWidget;
        }
      },
    );
  }
}
