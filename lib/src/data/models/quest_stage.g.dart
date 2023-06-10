// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_stage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestStage _$QuestStageFromJson(Map<String, dynamic> json) => QuestStage(
      id: json['id'] as String,
      name: json['name'] as String,
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      index: json['index'] as int? ?? -1,
    );

Map<String, dynamic> _$QuestStageToJson(QuestStage instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tasks': instance.tasks,
    };
