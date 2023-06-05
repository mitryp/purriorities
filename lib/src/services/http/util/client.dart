import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../config.dart' as config;
import 'secure_cookie_storage.dart';

/// Creates a [Dio] HTTP client and attaches a cookie interceptor to it, if needed.
Dio createHttpClient() {
  final client = Dio(BaseOptions(extra: {'withCredentials': true}))
    ..options.baseUrl = config.baseUrl;

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
