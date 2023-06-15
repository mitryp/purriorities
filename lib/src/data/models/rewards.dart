import 'package:json_annotation/json_annotation.dart';

part 'rewards.g.dart';

@JsonSerializable(createToJson: false)
class SkillReward {
  /// An identifier of the skill.
  final String id;

  ///
  final int levelExpGained;

  const SkillReward({required this.id, required this.levelExpGained});

  factory SkillReward.fromJson(Map<String, dynamic> json) => _$SkillRewardFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillReward &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          levelExpGained == other.levelExpGained;

  @override
  int get hashCode => id.hashCode ^ levelExpGained.hashCode;
}

@JsonSerializable(createToJson: false)
class Reward {
  ///
  final double mainLevelExpGained;

  ///
  final List<SkillReward> skillRewards;

  ///
  final int feedGained;

  ///
  final int catnipGained;

  /// Taking 100 cap into account
  final double trustGained;

  const Reward({
    required this.mainLevelExpGained,
    required this.skillRewards,
    required this.feedGained,
    required this.catnipGained,
    required this.trustGained,
  });

  const Reward.absent()
      : mainLevelExpGained = 0,
        skillRewards = const [],
        feedGained = 0,
        catnipGained = 0,
        trustGained = 0;

  factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);

  bool get isAbsent =>
      mainLevelExpGained == 0 &&
      skillRewards.isEmpty &&
      feedGained == 0 &&
      catnipGained == 0 &&
      trustGained == 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reward &&
          runtimeType == other.runtimeType &&
          mainLevelExpGained == other.mainLevelExpGained &&
          skillRewards == other.skillRewards &&
          feedGained == other.feedGained &&
          catnipGained == other.catnipGained &&
          trustGained == other.trustGained;

  @override
  int get hashCode =>
      mainLevelExpGained.hashCode ^
      skillRewards.hashCode ^
      feedGained.hashCode ^
      catnipGained.hashCode ^
      trustGained.hashCode;
}
