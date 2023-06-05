import 'package:dio/dio.dart';

import '../http/util/fetch_result.dart';
import 'exceptions.dart';

Future<T> httpServiceController<TData, T>(
  Future<Response<TData>> response,
  ResultMapper<TData, T> successMapper, [
  AnyResultMapper<TData, T>? failureMapper,
]) async {
  final res = await FetchResult.fromResponse(response);

  if (res.isSuccessful) {
    return res.map(successMapper);
  }

  if (failureMapper != null) {
    return res.mapAny(failureMapper);
  }

  throw ResourceNotFetchedException(res.error?.message);
}

Future<FetchResult<T>> httpServiceControllerRes<TData, T>(
  Future<Response<TData>> response,
  ResultMapper<TData, T> mapper, [
  AnyResultMapper<TData, T>? failureMapper,
]) async {
  final res = await FetchResult.fromResponse(response);

  if (!res.isSuccessful && failureMapper != null) {
    return FetchResult.success(res.mapAny(failureMapper));
  }

  if (res.isSuccessful) {
    return res.transform(mapper);
  }

  return FetchResult<T>.failure(res.error);
}
