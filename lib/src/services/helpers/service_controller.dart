import 'package:http/http.dart' as http;
import 'status_code_predicates.dart';

import 'exceptions.dart';

typedef ControllerLogic<T> = T Function(http.Response response);

Future<T> httpServiceController<T>(
  http.Response response,
  ControllerLogic<T> successLogic, [
  ControllerLogic<T>? unsuccessfulLogic,
]) async {
  //final res = await applyResponseMiddleware(response);

  final res = response;

  if (hasSuccessCode(res)) {
    return successLogic(res);
  }

  if (unsuccessfulLogic != null) {
    return unsuccessfulLogic(res);
  }
  throw ResourceNotFetchedException(res.reasonPhrase);
}
