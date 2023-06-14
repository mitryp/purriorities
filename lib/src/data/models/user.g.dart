// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      level: json['level'] as int,
      levelExp: (json['levelExp'] as num).toDouble(),
      levelCap: (json['levelCap'] as num).toDouble(),
      feed: json['feed'] as int,
      catnip: json['catnip'] as int,
      trust: (json['trust'] as num).toDouble(),
      catOwnerships: (json['catOwnerships'] as List<dynamic>?)
              ?.map((e) => CatOwnership.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'nickname': instance.nickname,
      'email': instance.email,
    };
