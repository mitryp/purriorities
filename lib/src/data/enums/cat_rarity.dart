import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/// A enumeration of the cat rarity values: [common], [rare], [legendary].
@JsonEnum()
enum CatRarity {
  @JsonValue(0)
  common(Color(0xff6e6e6e)),
  @JsonValue(1)
  rare(Color(0xee449944)),
  @JsonValue(2)
  legendary(Color(0xcbffc107));

  final Color? color;

  const CatRarity([this.color]);
}
