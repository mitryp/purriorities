import 'package:dio/dio.dart';

import '../../data/models/user.dart';
import '../helpers/service_controller.dart';
import 'util/fetch_result.dart';

class AuthService {
  final Dio _client;

  const AuthService(this._client);

  Future<FetchResult<bool>> login({
    required String email,
    required String password,
  }) async {
    final response = _client.post<Map<String, dynamic>>(
      'api/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return httpServiceControllerRes(response, (res) => true, orElseIfNotFailed: true);
  }

  Future<FetchResult<bool>> logout() async {
    final response = _client.delete<void>('auth/logout');

    return httpServiceControllerRes(response, (res) => true, orElseIfNotFailed: true);
  }

  Future<FetchResult<bool>> register(User newUser, String password) async {
    final data = newUser.toCreateJson()..['password'] = password;

    final response = _client.post(
      'api/users/signup',
      data: data,
    );

    return httpServiceControllerRes(response, (res) => true, orElseIfNotFailed: true);
  }
}
