import 'dart:convert';

import 'package:http/http.dart' as http;

enum HttpMethod {
  get,
  post,
  put,
  delete,
  patch;
}

Future<http.Response> makeRequest(HttpMethod method, Uri path, {Object? body}) async {
  final req = http.Request(method.name.toUpperCase(), path)
    ..body = body != null ? jsonEncode(body) : ''
    ..headers['Content-Type'] = 'application/json; charset=utf-8';

  // todo add authentication token here

  return http.Client()
      .send(req)
      .then(http.Response.fromStream)
      .catchError((err) => http.Response('{"message": "$err"}', 503));
}
