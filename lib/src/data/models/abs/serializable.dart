/// Defines an interface of a serializable model classes with [toJson] methods.
abstract class Serializable {
  const Serializable();

  /// Creates a full json map from this [Serializable] with all keys.
  Map<String, dynamic> toJson();

  /// Returns a set of keys to be excluded from the create dto.
  Set<String> get generatedIdentifiers => {};

  /// Creates a json map from this [Serializable] with removed keys specified in the
  /// [generatedIdentifiers].
  Map<String, dynamic> toCreateJson() {
    final keysFilter = generatedIdentifiers;

    return toJson()..removeWhere((key, value) => keysFilter.contains(key));
  }
}
