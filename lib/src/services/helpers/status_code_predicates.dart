import 'package:http/http.dart';

/// True for codes in range [200, 299] or 304.
bool hasSuccessCode(Response res) =>
    res.statusCode >= 200 && res.statusCode < 300 || res.statusCode == 304;
