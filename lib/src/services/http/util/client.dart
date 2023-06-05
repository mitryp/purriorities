import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../helpers/cookie_storage.dart';

const String baseUrl = 'http://localhost:80/api/';

/// Creates a [Dio] HTTP client and attaches a cookie interceptor to it, if the platform is not web.
Dio createHttpClient() {
  final client = Dio()..options.baseUrl = baseUrl;

  if (!kIsWeb) {
    _addCookieInterceptorTo(client);
  }

  return client;
}

void _addCookieInterceptorTo(Dio client) {
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  const cookieStorage = SecureCookieStorage(secureStorage);

  final cookieJar = PersistCookieJar(storage: cookieStorage);

  client.interceptors.add(CookieManager(cookieJar));
}
