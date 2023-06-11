import '../../../data/models/cat.dart';
import '../../../data/models/cat_ownership.dart';

class CollectionCat implements Comparable<CollectionCat> {
  final Cat info;
  final CatOwnership? ownership;

  const CollectionCat(this.info, this.ownership);

  bool get isOwned => ownership != null;

  int get _value => (isOwned ? 100 : 0) + (ownership?.xpBoost ?? 0).toInt();

  @override
  int compareTo(CollectionCat other) => other._value - _value;
}
