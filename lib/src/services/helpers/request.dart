// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
//
// enum HttpMethod {
//   get,
//   post,
//   put,
//   delete,
//   patch;
// }
//
// /// Makes a HTTP request with the given [method] to the given [uri]
// /// The request will have the optional json encoded [body] (the method will encode the body by
// /// itself).
// ///
// /// If the [context] is given, it will be used to add the authorization data to the request.
// ///
// /// The [headers] will be added in the end, overwriting any existing request headers.
// Future<http.Response> makeRequest(
//   HttpMethod method,
//   Uri uri, {
//   Object? body,
//   Map<String, String> headers = const {},
//   BuildContext? context,
// }) async {
//   final req = http.Request(method.name.toUpperCase(), uri);
//
//   if (body != null) {
//     _setJsonBody(req, body);
//   }
//
//   if (context != null) {
//     _setAuthData(req, context);
//   }
//
//   req.headers.addAll(headers);
//
//   return http.Client()
//       .send(req)
//       .then(http.Response.fromStream)
//       .catchError((err) => http.Response('{"message": "$err"}', 503));
// }
//
// /// Sets the body of the [request] to the json encoded object [body] and the Content-Type header to
// /// `application/json`.
// void _setJsonBody(http.Request request, Object body) {
//   request
//     ..body = jsonEncode(body)
//     ..headers[HttpHeaders.contentTypeHeader] = ContentType.json.value;
// }
//
// /// Sets the Authorization header of the request
// void _setAuthData(http.Request request, BuildContext context) {
//   if (!context.mounted) return;
// }
