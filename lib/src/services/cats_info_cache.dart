import '../data/models/cat.dart';
import 'http/fetch/cat_fetch_service.dart';

class CatsInfoCache {
  final CatFetchService _catFetchService;

  late final List<Cat> _cats;

  bool _isLoaded = false;

  CatsInfoCache(this._catFetchService);

  bool get isLoaded => _isLoaded;

  List<Cat> get cats => isLoaded ? _cats : const [];

  Future<bool> loadCats() async {
    if (isLoaded) return true;

    final result = await _catFetchService.getMany();

    if (!result.isSuccessful) return false;

    _cats = result.result().data;
    _isLoaded = true;

    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatsInfoCache && runtimeType == other.runtimeType && _isLoaded == other._isLoaded;

  @override
  int get hashCode => _isLoaded.hashCode;
}
