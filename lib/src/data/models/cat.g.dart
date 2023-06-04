// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cat _$CatFromJson(Map<String, dynamic> json) => Cat(
      nameId: json['nameId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      rarity: $enumDecode(_$CatRarityEnumMap, json['rarity']),
    );

Map<String, dynamic> _$CatToJson(Cat instance) => <String, dynamic>{
      'nameId': instance.nameId,
      'name': instance.name,
      'description': instance.description,
      'rarity': _$CatRarityEnumMap[instance.rarity]!,
    };

const _$CatRarityEnumMap = {
  CatRarity.common: 0,
  CatRarity.rare: 1,
  CatRarity.legendary: 2,
};
