import 'package:dio/dio.dart';

import '../../../data/models/quest.dart';
import 'fetch_service.dart';

class QuestsFetchService extends FetchService<Quest>
    with GetManyFetchMixin<Quest>, ModifyFetchMixin<Quest> {
  const QuestsFetchService(Dio client)
      : super(
          path: 'quests',
          client: client,
          fromJsonConverter: Quest.fromJson,
        );
}
