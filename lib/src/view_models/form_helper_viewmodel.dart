import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

abstract class FormHelperViewModel extends ReactiveViewModel with FormHelper {
  @override
  void dispose() {
    disposeFocusNodes();
    super.dispose();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [];
}

mixin FormHelper on ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  var autoValidateMode = AutovalidateMode.disabled;

  final Map<String, FocusNode> _focusNodes = {};

  FocusNode getFocusNode(String key) {
    if (_focusNodes.containsKey(key)) {
      return _focusNodes[key]!;
    } else {
      final focusNode = FocusNode();
      _focusNodes[key] = focusNode;
      return focusNode;
    }
  }

  void disposeFocusNodes() {
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    _focusNodes.clear();
  }

  bool validateAndSave() {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState!.save();
      return true;
    } else {
      autoValidateMode = AutovalidateMode.always;
      notifyListeners();
      return false;
    }
  }
}
