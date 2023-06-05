import 'package:dio/dio.dart';

import '../../../data/models/user.dart';
import '../../../typedefs.dart';
import '../util/fetch_result.dart';
import 'fetch_service.dart';

class UserFetchService extends ModifyingFetchService<User> {
  const UserFetchService(Dio client)
      : super(
          path: 'users',
          client: client,
          fromJsonConverter: User.fromJson,
        );

  Future<FetchResult<User>> me() async {
    final res = client.get<JsonMap>('$path/me');

    return defaultResponseTransform(res);
  }
}
