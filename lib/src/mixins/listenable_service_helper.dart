import 'package:stacked/stacked.dart';

mixin ListenableServiceHelper<T> {
  final _data = ReactiveValue<T?>(null);
  final _busy = ReactiveValue<bool>(false);
  final _error = ReactiveValue<String?>(null);

  T? get data => _data.value;
  bool get busy => _busy.value;
  String? get error => _error.value;

  set data(T? value) => _data.value = value;
  set busy(bool value) => _busy.value = value;
  set error(String? value) => _error.value = value;

  Future<void> getFutureData(
    Future<T?> busyFuture, {
    bool silent = false,
    bool handleError = true,
  }) async {
    if (!silent) busy = true;
    try {
      error = null;
      data = await busyFuture;
    } catch (e) {
      if (handleError) {
        error = e.toString();
      } else {
        rethrow;
      }
    } finally {
      if (!silent) busy = false;
    }
  }

  List<dynamic> get helperReactiveValues => [_data, _busy, _error];
}
