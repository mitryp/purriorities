import 'package:dio/dio.dart';

/// True for codes in range [200, 299] or 304.
bool hasSuccessCode(Response res) {
  final statusCode = res.statusCode ?? 503;

  return statusCode >= 200 && statusCode < 300 || statusCode == 304;
}
