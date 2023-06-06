import 'package:dio/dio.dart';

import '../../../data/models/cat.dart';
import 'fetch_service.dart';

class CatFetchService extends FetchService<Cat> with GetManyFetchMixin<Cat> {
  const CatFetchService(Dio client)
      : super(
          path: 'cats',
          client: client,
          fromJsonConverter: Cat.fromJson,
        );
}
