// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestCategory _$QuestCategoryFromJson(Map<String, dynamic> json) => QuestCategory(
      name: json['name'] as String,
      id: json['id'] as String,
      inbox: json['inbox'] as bool,
    );

Map<String, dynamic> _$QuestCategoryToJson(QuestCategory instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'inbox': instance.inbox,
    };
