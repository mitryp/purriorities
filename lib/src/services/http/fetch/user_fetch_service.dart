import 'package:dio/dio.dart';

import '../../../data/models/user.dart';
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
    assert(primaryKey.isEmpty);

    return super.getOne(primaryKey);
  }

  Future<FetchResult<User>> me() async => getOne();
}
