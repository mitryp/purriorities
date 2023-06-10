import 'package:dio/dio.dart';

import '../../../data/models/quest_category.dart';
import '../util/fetch_result.dart';
import 'fetch_service.dart';

class CategoriesFetchService extends FetchService<QuestCategory>
    with GetManyFetchMixin<QuestCategory>, ModifyFetchMixin<QuestCategory> {
  const CategoriesFetchService(Dio client)
      : super(
          path: 'categories',
          client: client,
          fromJsonConverter: QuestCategory.fromJson,
        );

  Future<FetchResult<QuestCategory>> getDefault() => getOne('default');
}
