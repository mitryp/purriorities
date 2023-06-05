import 'package:json_annotation/json_annotation.dart';

part 'punishments.g.dart';

@JsonSerializable(createToJson: false)
class PendingPunishment {
  /// A list of quests whose deadlines were missed since the user hasn't been online.
  final List<OverdueQuest> overdueQuests;

  /// A list of cats who ran away since the user hasn't been online.
  final List<RunawayCat> runawayCats;

  const PendingPunishment({
    required this.overdueQuests,
    required this.runawayCats,
  });

  factory PendingPunishment.fromJson(Map<String, dynamic> json) =>
      _$PendingPunishmentFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingPunishment &&
          runtimeType == other.runtimeType &&
          overdueQuests == other.overdueQuests &&
          runawayCats == other.runawayCats;

  @override
  int get hashCode => overdueQuests.hashCode ^ runawayCats.hashCode;
}

@JsonSerializable(createToJson: false)
class OverdueQuest {
  /// An identifier of the quest which deadline was missed.
  final String id;

  /// An amount of trust lost as a result of missing the deadline.
  final int totalTrustLost;

  const OverdueQuest({required this.id, required this.totalTrustLost});

  factory OverdueQuest.fromJson(Map<String, dynamic> json) => _$OverdueQuestFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OverdueQuest &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          totalTrustLost == other.totalTrustLost;

  @override
  int get hashCode => id.hashCode ^ totalTrustLost.hashCode;
}

@JsonSerializable(createToJson: false)
class RunawayCat {
  /// An identifier of the cat which has run away.
  final String nameId;

  /// An amount of cat food lost as a result of the cat run away.
  final int feedLost;

  const RunawayCat({required this.nameId, required this.feedLost});

  factory RunawayCat.fromJson(Map<String, dynamic> json) => _$RunawayCatFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RunawayCat &&
          runtimeType == other.runtimeType &&
          nameId == other.nameId &&
          feedLost == other.feedLost;

  @override
  int get hashCode => nameId.hashCode ^ feedLost.hashCode;
}
