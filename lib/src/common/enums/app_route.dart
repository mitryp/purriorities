import 'query_param.dart';

enum AppRoute {
  init('/init'),
  login('/login'),
  dashboard('/dashboard'),
  cats('/cats'),
  store('/store'),
  skills('/skills'),
  register('/register'),
  editQuest('/edit_quest'),
  allQuests('/all_quests');

  final String route;

  const AppRoute(this.route);

  String params(List<String> params) => QueryParam.compose(route, params);
}
