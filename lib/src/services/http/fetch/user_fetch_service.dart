import 'package:dio/dio.dart';

import '../../../data/models/punishments.dart';
import '../../../data/models/user.dart';
import '../../../typedefs.dart';
import '../util/fetch_result.dart';
import 'fetch_service.dart';

class UsersFetchService extends FetchService<User> with ModifyFetchMixin<User> {
  const UsersFetchService(Dio client)
      : super(
          path: 'users/me',
          client: client,
          fromJsonConverter: User.fromJson,
        );

  @override
  Future<FetchResult<User>> getOne([String primaryKey = '']) {
    assert(
      primaryKey.isEmpty,
      'UserFetchService must not fetch with a primary key, Users cannot get information about'
      ' other users',
    );

    return super.getOne(primaryKey);
  }

  @override
  Future<FetchResult<User>> update(
    String primaryKey,
    User serializable, {
    Map<String, dynamic> additionalFields = const {},
    User? oldSerializable,
  }) {
    assert(
      primaryKey.isEmpty,
      'UserFetchService must not fetch with a primary key, Users cannot get information about'
      ' other users. Please, pass an empty string',
    );

    return super.update(
      primaryKey,
      serializable,
      oldSerializable: oldSerializable,
      additionalFields: additionalFields,
    );
  }

  Future<FetchResult<User>> me() => getOne();

  Future<FetchResult<PendingPunishment>> pendingPunishment() => FetchResult.transformResponse(
        client.get<JsonMap>('$path/new-punishments'),
        PendingPunishment.fromJson,
      );
}
