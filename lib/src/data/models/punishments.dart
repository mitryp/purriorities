import 'package:json_annotation/json_annotation.dart';

part 'punishments.g.dart';

@JsonSerializable(createToJson: false)
class PendingPunishment {
  /// A list of quests whose deadlines were missed since the user hasn't been online.
  final List<OverdueQuest> overdueQuests;

  /// A list of cats who ran away since the user hasn't been online.
  final List<RunawayCat> runawayCats;

  /// An amount of trust lost for reasons other than missing quest deadlines.
  final int extraTrustLost;

  const PendingPunishment({
    required this.overdueQuests,
    required this.runawayCats,
    this.extraTrustLost = 0,
  });

  const PendingPunishment.absent()
      : overdueQuests = const [],
        runawayCats = const [],
        extraTrustLost = 0;

  factory PendingPunishment.fromJson(Map<String, dynamic> json) =>
      _$PendingPunishmentFromJson(json);

  bool get isAbsent => overdueQuests.isEmpty && runawayCats.isEmpty && extraTrustLost == 0;

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
  final int trustLost;

  const OverdueQuest({required this.id, required this.trustLost});

  factory OverdueQuest.fromJson(Map<String, dynamic> json) => _$OverdueQuestFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OverdueQuest &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          trustLost == other.trustLost;

  @override
  int get hashCode => id.hashCode ^ trustLost.hashCode;
}

@JsonSerializable(createToJson: false)
class RunawayCat {
  /// An identifier of the cat which has run away.
  final String nameId;

  /// An amount of cat food lost as a result of the cat run away.
  final int feedTaken;

  const RunawayCat({required this.nameId, required this.feedTaken});

  factory RunawayCat.fromJson(Map<String, dynamic> json) => _$RunawayCatFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RunawayCat &&
          runtimeType == other.runtimeType &&
          nameId == other.nameId &&
          feedTaken == other.feedTaken;

  @override
  int get hashCode => nameId.hashCode ^ feedTaken.hashCode;
}
