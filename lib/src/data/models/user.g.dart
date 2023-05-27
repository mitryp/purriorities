// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      joinDate: DateTime.parse(json['joinDate'] as String),
      locale: json['locale'] as String,
      timezone: json['timezone'] as String,
      level: json['level'] as int,
      levelExp: json['levelExp'] as int,
      feed: json['feed'] as int,
      catnip: json['catnip'] as int,
      trust: json['trust'] as int,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'email': instance.email,
      'joinDate': instance.joinDate.toIso8601String(),
      'locale': instance.locale,
      'timezone': instance.timezone,
      'level': instance.level,
      'levelExp': instance.levelExp,
      'feed': instance.feed,
      'catnip': instance.catnip,
      'trust': instance.trust,
    };
