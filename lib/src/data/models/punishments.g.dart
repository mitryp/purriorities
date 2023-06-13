// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'punishments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingPunishment _$PendingPunishmentFromJson(Map<String, dynamic> json) => PendingPunishment(
      overdueQuests: (json['overdueQuests'] as List<dynamic>)
          .map((e) => OverdueQuest.fromJson(e as Map<String, dynamic>))
          .toList(),
      runawayCats: (json['runawayCats'] as List<dynamic>)
          .map((e) => RunawayCat.fromJson(e as Map<String, dynamic>))
          .toList(),
      extraTrustLost: json['extraTrustLost'] as int? ?? 0,
    );

OverdueQuest _$OverdueQuestFromJson(Map<String, dynamic> json) => OverdueQuest(
      id: json['id'] as String,
      totalTrustLost: json['totalTrustLost'] as int,
    );

RunawayCat _$RunawayCatFromJson(Map<String, dynamic> json) => RunawayCat(
      nameId: json['nameId'] as String,
      feedLost: json['feedLost'] as int,
    );
