import 'package:dio/dio.dart';

import '../../../data/models/cat.dart';
import 'fetch_service.dart';

class CatsFetchService extends FetchService<Cat> with GetManyFetchMixin<Cat> {
  const CatsFetchService(Dio client)
      : super(
          path: 'cats',
          client: client,
          fromJsonConverter: Cat.fromJson,
        );
}
