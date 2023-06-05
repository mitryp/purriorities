// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      locale: json['locale'] as String,
      timezone: json['timezone'] as String,
      level: json['level'] as int,
      levelExp: json['levelExp'] as int,
      levelCap: json['levelCap'] as int,
      feed: json['feed'] as int,
      catnip: json['catnip'] as int,
      trust: json['trust'] as int,
      cats: (json['cats'] as List<dynamic>)
          .map((e) => CatOwnership.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'nickname': instance.nickname,
      'email': instance.email,
      'locale': instance.locale,
      'timezone': instance.timezone,
    };
