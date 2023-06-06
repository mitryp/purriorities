import 'package:dio/dio.dart';

import '../../../data/models/skill.dart';
import 'fetch_service.dart';

class SkillsFetchService extends FetchService<Skill>
    with GetManyFetchMixin<Skill>, ModifyFetchMixin<Skill> {
  const SkillsFetchService(Dio client)
      : super(
          path: 'skills',
          client: client,
          fromJsonConverter: Skill.fromJson,
        );
}
