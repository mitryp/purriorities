/// Defines an interface of a serializable model classes with [toJson] methods.
abstract interface class Serializable {
  /// Creates a json map from this [Serializable].
  Map<String, dynamic> toJson();
}
