// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat_ownership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CatOwnership _$CatOwnershipFromJson(Map<String, dynamic> json) => CatOwnership(
      level: json['level'] as int,
      acquireDate: DateTime.parse(json['acquireDate'] as String),
      catNameId: json['catNameId'] as String,
    );

Map<String, dynamic> _$CatOwnershipToJson(CatOwnership instance) => <String, dynamic>{
      'level': instance.level,
      'acquireDate': instance.acquireDate.toIso8601String(),
      'catNameId': instance.catNameId,
    };
