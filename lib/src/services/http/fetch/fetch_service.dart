import 'package:dio/dio.dart';

import '../../../data/models/abs/serializable.dart';
import '../../../data/util/paginated_data.dart';
import '../../../data/util/serializable_difference.dart';
import '../../../typedefs.dart';
import '../../../util/extensions/serializable_difference_extension.dart';
import '../util/fetch_result.dart';

typedef FromJsonConverter<T> = T Function(Map<String, dynamic> json);

abstract class FetchService<T> {
  /// An http client to perform the operations.
  final Dio client;

  /// A relative resource path on the server starting from the [baseUrl].
  final String path;

  /// A FromJsonConverter for the resource type.
  final FromJsonConverter<T> fromJsonConverter;

  const FetchService({required this.client, required this.path, required this.fromJsonConverter});

  /// Fetches a single resource with the given [primaryKey].
  Future<FetchResult<T>> getOne(Object primaryKey) =>
      _defaultResponseTransform(client.get<JsonMap>('$path/$primaryKey'));

  Future<FetchResult<T>> _defaultResponseTransform(Future<Response<JsonMap>> res) =>
      FetchResult.transformResponse(res, fromJsonConverter);
}

mixin ReadManyFetchMixin<T> on FetchService<T> {
  // todo pagination
  /// Fetches a [PaginatedData] of [T] based on the [queryData].
  Future<FetchResult<PaginatedData<T>>> getMany([dynamic queryData]) {
    final res = client.get<JsonMap>(path);

    return FetchResult.transformResponse(
      res,
          (json) => PaginatedData.fromJson<T>(json, fromJsonConverter),
    );
  }
}

mixin ModifyFetchMixin<S extends Serializable> on FetchService<S> {
  /// Posts a [serializable] json created with [Serializable.toCreateJson] method.
  /// Returns a created resource.
  Future<FetchResult<S>> create(S serializable) async {
    final res = client.post<JsonMap>(
      path,
      data: serializable.toCreateJson(),
    );

    return _defaultResponseTransform(res);
  }

  /// Patches a [serializable] json created with [Serializable.toCreateJson] method.
  ///
  /// If the [oldSerializable] is provided, only changed key-values will be sent to a server.
  /// (See [serializableDifference])
  ///
  /// The request is sent to [path]/[primaryKey] path.
  /// Returns an updated resource.
  Future<FetchResult<S>> update(Object primaryKey, S serializable, {S? oldSerializable}) async {
    final patchJson = oldSerializable?.diff(serializable) ?? serializable.toJson();
    final res = client.patch<JsonMap>('$path/$primaryKey', data: patchJson);

    return _defaultResponseTransform(res);
  }
}
