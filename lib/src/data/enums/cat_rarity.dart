import 'package:json_annotation/json_annotation.dart';

/// A enumeration of the cat rarity values: [common], [rare], [legendary].
@JsonEnum()
enum CatRarity {
  @JsonValue(0)
  common,
  @JsonValue(1)
  rare,
  @JsonValue(2)
  legendary;
}
