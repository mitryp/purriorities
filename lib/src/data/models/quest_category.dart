import 'package:json_annotation/json_annotation.dart';

import 'quest.dart';

/// A class representing a user-defined category of [Quest]s.
@JsonSerializable()
class QuestCategory {
  /// A user-defined name of this category.
  final String name;

  /// An id of this category.
  final int id;

  const QuestCategory({
    required this.name,
    required this.id,
  });
}
