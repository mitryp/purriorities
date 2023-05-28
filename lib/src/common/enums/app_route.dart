enum AppRoute {
  dashboard('/dashboard'),
  cats('/cats'),
  store('/store'),
  skills('/skills'),
  login('/login'),
  register('/register'),
  editQuest('/edit_quest'),
  allQuests('/all_quests');

  final String route;

  const AppRoute(this.route);
}