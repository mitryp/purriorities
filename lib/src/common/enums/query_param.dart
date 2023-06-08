import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum QueryParam {
  redirectTo('redirectTo');

  final String key;

  const QueryParam(this.key);

  static String compose(String path, [List<String> params = const []]) {
    if (params.isEmpty) return path;

    final composedParams = params.join('&');

    return '$path?$composedParams';
  }

  String call(String value) => '$key=$value';

  String? valueOf(BuildContext context) => GoRouterState.of(context).queryParameters[key];
}
