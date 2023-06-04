import 'package:dio/dio.dart';

import 'status_code_predicates.dart';

import 'exceptions.dart';

typedef ControllerLogic<T> = T Function(Response response);

Future<T> httpServiceController<T>(
  Response response,
  ControllerLogic<T> successLogic, [
  ControllerLogic<T>? unsuccessfulLogic,
]) async {
  final res = response;

  if (hasSuccessCode(res)) {
    return successLogic(res);
  }

  if (unsuccessfulLogic != null) {
    return unsuccessfulLogic(res);
  }
  throw ResourceNotFetchedException(res.statusMessage);
}
