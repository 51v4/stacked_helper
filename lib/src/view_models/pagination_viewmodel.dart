import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

const kFirstPageKey = 1;

abstract class PaginationModel<T> {
  int? page;
  int? totalPages;
  List<T>? items;

  PaginationModel({
    this.page,
    this.totalPages,
    this.items,
  });
}

mixin PaginationHelper<T, L extends PaginationModel> on ChangeNotifier {
  int page = kFirstPageKey;
  List<T> items = [];
  bool isBusy = false;
  UniqueKey viewKey = UniqueKey();

  L? lastData;

  bool get hasReachedMax {
    return page > (lastData?.totalPages ?? kFirstPageKey);
  }

  void setBusy(bool value) {
    isBusy = value;
    notifyListeners();
  }

  void resetPagination({
    bool clearLastData = true,
  }) {
    page = kFirstPageKey;
    items = [];
    if (clearLastData) lastData = null;
    isBusy = false;
    viewKey = UniqueKey();
    notifyListeners();
  }
}

abstract class PaginationViewModel<T, L extends PaginationModel>
    extends ReactiveViewModel with PaginationHelper<T, L> {
  bool get isFirstPageBusy => page == kFirstPageKey && isBusy;

  @override
  List<ListenableServiceMixin> get listenableServices => [];
}

class PaginationController<T, L extends PaginationModel> extends ChangeNotifier
    with PaginationHelper<T, L> {
  bool get isFirstPageBusy => page == kFirstPageKey && isBusy;

  void notify() => notifyListeners();
}
