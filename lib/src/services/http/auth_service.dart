import 'dart:io';

import 'package:dio/dio.dart';

import '../../data/models/user.dart';
import '../helpers/service_controller.dart';
import 'util/fetch_result.dart';

class AuthService {
  final Dio client;

  const AuthService(this.client);

  Future<FetchResult<bool>> login({
    required String email,
    required String password,
  }) async {
    final response = client.post<Map<String, dynamic>>(
      'auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return httpServiceControllerRes(response, (res) => true);

    // return httpServiceController(response, (res) => true, (res, error) {
    //   print('$error, ${error?.response}, ${error?.message}');
    //   return false;
    // });
  }

  Future<FetchResult<bool>> logout() async {
    final response = client.delete<void>('auth/logout');

    return httpServiceControllerRes(response, (res) => true);
  }

  Future<FetchResult<bool>> register(User newUser) async {
    final response = client.post(
      'users/signup',
      data: newUser.toCreateJson(),
    );

    return httpServiceControllerRes(response, (res) => true);
  }
}
