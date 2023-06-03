// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      stageId: json['stageId'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      minutes: json['minutes'] as int,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'stageId': instance.stageId,
      'id': instance.id,
      'name': instance.name,
      'minutes': instance.minutes,
    };
