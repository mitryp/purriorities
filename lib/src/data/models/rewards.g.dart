// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewards.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkillReward _$SkillRewardFromJson(Map<String, dynamic> json) => SkillReward(
      id: json['id'] as String,
      levelExpGained: json['levelExpGained'] as int,
    );

Reward _$RewardFromJson(Map<String, dynamic> json) => Reward(
      mainLevelExpGained: json['mainLevelExpGained'] is int
          ? json['mainLevelExpGained'] as int
          : (json['mainLevelExpGained'] as double).round(),
      skillRewards: (json['skillRewards'] as List<dynamic>)
          .map((e) => SkillReward.fromJson(e as Map<String, dynamic>))
          .toList(),
      feedGained: json['feedGained'] as int,
      catnipGained: json['catnipGained'] as int,
      trustGained: json['trustGained'] as int,
    );
