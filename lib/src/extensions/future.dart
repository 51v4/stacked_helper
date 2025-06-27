import 'dart:developer';

import 'string.dart';

extension FutureExecutionTimeLogger<T> on Future<T> {
  Future<T> logExecutionTime({String? functionName}) async {
    final startTime = DateTime.now();
    final result = await this;
    final endTime = DateTime.now();
    final timeTaken = endTime.difference(startTime).inSeconds;
    log(
      '${functionName.isNotEmptyOrNull ? '$functionName - ' : ''}Execution time: $timeTaken seconds',
    );
    return result;
  }
}
