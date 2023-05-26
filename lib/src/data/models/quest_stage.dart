import 'package:json_annotation/json_annotation.dart';

import 'quest.dart';

/// A class representing a single stage of a [Quest].
@JsonSerializable()
class QuestStage {
  /// An id of this quest stage.
  final String id;

  /// A user-defined name of this quest stage.
  /// Can be empty - might want to replace it with a placeholder.
  final String name;

  const QuestStage({
    required this.id,
    required this.name,
  });
}
