import '../models/abs/serializable.dart';

/// Returns a json map containing only the fields that differ between
Map<String, dynamic> serializableDifference<S extends Serializable>(
  S oldModel,
  S newModel, [
  Set<String> retainFields = const {},
]) {
  final oldJson = oldModel.toJson();

  return newModel.toJson()
    ..removeWhere(
      (key, value) => value == oldJson[key] && !retainFields.contains(key),
    );
}
