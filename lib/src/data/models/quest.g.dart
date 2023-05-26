// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quest _$QuestFromJson(Map<String, dynamic> json) => Quest(
      id: json['id'] as int,
      name: json['name'] as String,
      priority: $enumDecode(_$QuestPriorityEnumMap, json['priority']),
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      limit: json['limit'] == null
          ? null
          : DateTime.parse(json['limit'] as String),
      category:
          QuestCategory.fromJson(json['category'] as Map<String, dynamic>),
      stages: (json['stages'] as List<dynamic>)
          .map((e) => QuestStage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestToJson(Quest instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'priority': _$QuestPriorityEnumMap[instance.priority]!,
      'deadline': instance.deadline?.toIso8601String(),
      'limit': instance.limit?.toIso8601String(),
      'category': instance.category,
      'stages': instance.stages,
    };

const _$QuestPriorityEnumMap = {
  QuestPriority.optional: 0,
  QuestPriority.regular: 1,
  QuestPriority.legendary: 2,
};
