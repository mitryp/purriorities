import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'query_param.dart';

enum AppRoute {
  init('/init', 'Завантаження'),
  login('/login', 'Вхід'),
  dashboard('/dashboard', 'Головна'),
  cats('/cats', 'Котики'),
  store('/store', 'Магазин'),
  skills('/skills', 'Навички'),
  editSkill('/edit_skill', 'Редагування навички'),
  register('/register', 'Реєстрація'),
  allQuests('/quests', 'Квести'),
  editQuest('/edit_quest', 'Редагування квесту');

  final String route;
  final String title;

  const AppRoute(this.route, this.title);

  static AppRoute? maybeOf(BuildContext context) {
    final location = GoRouter.of(context).location;

    return values.where((route) => route.route == location).firstOrNull;
  }

  String params(List<String> params) => QueryParam.compose(route, params);
}
