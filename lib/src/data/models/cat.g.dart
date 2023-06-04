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

const _$CatRarityEnumMap = {
  CatRarity.common: 0,
  CatRarity.rare: 1,
  CatRarity.legendary: 2,
};
