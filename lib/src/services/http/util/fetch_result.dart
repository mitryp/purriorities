import 'dart:async';

import 'package:dio/dio.dart';

typedef ResultMapper<T, R> = R Function(T res);
typedef AnyResultMapper<T, R> = R Function(T? res, DioError? error);

class FetchResult<T> {
  final T? _result;
  final DioError? error;
  final bool isSuccessful;

  const FetchResult.success(T this._result)
      : isSuccessful = true,
        error = null;

  const FetchResult.failure([this.error])
      : isSuccessful = false,
        _result = null;

  static Future<FetchResult<T>> fromResponse<T>(
    FutureOr<Response<T>> resFuture,
  ) async {
    try {
      final res = await resFuture;
      final data = res.data;

      if (data != null) {
        return FetchResult<T>.success(data);
      }

      return FetchResult<T>.failure();
    } on DioError catch (e) {
      return FetchResult<T>.failure(e);
    }
  }

  T result() {
    final res = _result;

    if (res != null) {
      return res;
    }

    throw StateError('Obtained a failed result of type $T. The error was $error');
  }

  FetchResult<R> transform<R>(ResultMapper<T, R> transform) {
    final res = _result;

    if (res != null) {
      return FetchResult.success(transform(res));
    }

    return FetchResult<R>.failure(error);
  }

  R map<R>(ResultMapper<T, R> mapper) {
    final res = _result;

    if (res != null) {
      return mapper(res);
    }

    throw StateError(
      'Used a ResultMapper on a failed result. Use [mapAny] instead '
      'to transform the result no matter of its status',
    );
  }

  R mapAny<R>(AnyResultMapper<T, R> mapper) => mapper(_result, error);
}

// enum FetchResultStatus {
//   success,
//   failure;
// }
