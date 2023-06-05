import 'package:dio/dio.dart';

import '../../../data/models/abs/serializable.dart';
import '../../../data/util/paginated_data.dart';
import '../../../typedefs.dart';
import '../../../util/extensions/serializable_difference_extension.dart';
import '../util/client.dart';
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
  Future<FetchResult<T>> getSingle(Object primaryKey) async {
    final res = client.get<JsonMap>('$path/$primaryKey');
    final result = await FetchResult.fromResponse(res);

    return result.transform(fromJsonConverter);
  }

  // todo pagination
  /// Fetches a [PaginatedData] of [T] based on the [paginationData].
  Future<FetchResult<PaginatedData<T>>> getAll([dynamic paginationData]) async {
    final res = client.get<JsonMap>(path);
    final result = await FetchResult.fromResponse(res);

    return result.transform((json) => PaginatedData.fromJson<T>(json, fromJsonConverter));
  }
}

abstract class ModifyingFetchService<S extends Serializable> extends FetchService<S> {
  const ModifyingFetchService({
    required super.client,
    required super.path,
    required super.fromJsonConverter,
  });

  /// Posts a [serializable] json created with [Serializable.toCreateJson] method.
  /// Returns a created resource.
  Future<FetchResult<S>> create(S serializable) async {
    final res = client.post<JsonMap>(
      path,
      data: serializable.toCreateJson(),
    );
    final result = await FetchResult.fromResponse(res);

    return result.transform(fromJsonConverter);
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
    final result = await FetchResult.fromResponse(res);

    return result.transform(fromJsonConverter);
  }
}
