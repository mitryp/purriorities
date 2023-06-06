import 'package:dio/dio.dart';

import '../fetch/cat_fetch_service.dart';
import '../fetch/categories_fetch_service.dart';
import '../fetch/quests_fetch_service.dart';
import '../fetch/skills_fetch_service.dart';
import '../fetch/user_fetch_service.dart';

typedef FetchServiceBundle = ({
  CatsFetchService catsFetchService,
  CategoriesFetchService categoriesFetchService,
  QuestsFetchService questsFetchService,
  SkillsFetchService skillsFetchService,
  UsersFetchService usersFetchService,
});

FetchServiceBundle bundleFetchServices(Dio client) => (
      catsFetchService: CatsFetchService(client),
      categoriesFetchService: CategoriesFetchService(client),
      questsFetchService: QuestsFetchService(client),
      skillsFetchService: SkillsFetchService(client),
      usersFetchService: UsersFetchService(client),
    );
