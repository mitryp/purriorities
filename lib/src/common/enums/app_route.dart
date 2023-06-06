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
}
