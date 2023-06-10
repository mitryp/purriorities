import 'query_param.dart';

enum AppRoute {
  init('/init'),
  login('/login'),
  dashboard('/dashboard'),
  cats('/cats'),
  store('/store'),
  skills('/skills'),
  editSkill('/edit_skill'),
  register('/register'),
  allQuests('/quests'),
  editQuest('/edit_quest'),
  ;

  final String route;

  const AppRoute(this.route);

  String params(List<String> params) => QueryParam.compose(route, params);
}
