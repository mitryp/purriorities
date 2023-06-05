import '../../../data/models/cat.dart';
import 'fetch_service.dart';

class CatFetchService extends FetchService<Cat> with GetManyFetchMixin<Cat> {
  const CatFetchService({required super.client})
      : super(
          path: 'cats',
          fromJsonConverter: Cat.fromJson,
        );
}
