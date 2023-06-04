import 'package:dio/dio.dart';

import '../../data/models/user.dart';
import '../helpers/service_controller.dart';

class AuthenticationService {
  final Dio client;

  const AuthenticationService(this.client);

  Future<bool> login({
    required String login,
    required String password,
  }) async {
    final response = await client.post(
      'auth/login',
      data: {
        'login': login,
        'password': password,
      },
    );

    return httpServiceController(response, (res) => true, (res) => false);
  }

  Future<bool> register(User newUser) async {
    final response = await client.post(
      'api/users/signup',
      data: newUser.toCreateJson(),
    );

    return httpServiceController(response, (res) => true, (res) => false);
  }
}
