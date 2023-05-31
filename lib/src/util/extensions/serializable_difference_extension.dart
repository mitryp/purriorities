import '../../data/models/abs/serializable.dart';
import '../../data/util/serializable_difference.dart';

extension SerializableDifference<T extends Serializable> on T {
  /// Returns a json map with fields of the [newModel] which differ from the respective fields of
  /// this model.
  Map<String, dynamic> diff(T newModel) => serializableDifference(this, newModel);
}
