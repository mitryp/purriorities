import 'helpers/request.dart';
import 'helpers/service_controller.dart';

class AuthenticationService {
  final baseRoute = 'http://localhost:5000/api';

  //TODO change generic
  Future<dynamic> login() async {
    final response = await makeRequest(
      HttpMethod.post,
      Uri.http(baseRoute, 'login'),
    );

    //TODO add logic to ControllerLogic
    return httpServiceController(response, (res) => res.body);
  }

  //TODO change generic
  Future<dynamic> register() async {
    final response = await makeRequest(
      HttpMethod.post,
      Uri.http(baseRoute, 'register'),
    );

    //TODO add logic to ControllerLogic
    return httpServiceController(response, (res) => res.body);
  }
}
