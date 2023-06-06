import 'package:json_annotation/json_annotation.dart';

import 'abs/serializable.dart';
import 'abs/prototype.dart';

part 'skill.g.dart';

/// A class representing a user-defined skill with the information about its current [level].
@JsonSerializable()
class Skill extends Serializable with Prototype<Skill> {
  /// A name of this skill, defined by the user during the skill creation.
  final String name;

  /// A level of this skill.
  @JsonKey(includeToJson: false)
  final int level;

  /// An experience points which the current user has gained on this [level].
  @JsonKey(includeToJson: false)
  final int levelExp;

  /// An experience points required to level up this skill.
  @JsonKey(includeToJson: false)
  final int levelCap;

  /// An id of this skill.
  final String id;

  const Skill({
    required this.name,
    required this.level,
    required this.levelExp,
    required this.levelCap,
    required this.id,
  });

  const Skill.empty()
      : name = '',
        id = '',
        level = 0,
        levelCap = 0,
        levelExp = 0;

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  @override
  Set<String> get generatedIdentifiers => {'id'};

  @override
  Map<String, dynamic> toJson() => _$SkillToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Skill &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          level == other.level &&
          levelExp == other.levelExp &&
          levelCap == other.levelCap &&
          id == other.id;

  @override
  int get hashCode =>
      name.hashCode ^ level.hashCode ^ levelExp.hashCode ^ levelCap.hashCode ^ id.hashCode;

  @override
  Skill copyWith({String? name}) => Skill(
        name: name ?? this.name,
        level: level,
        levelExp: levelExp,
        levelCap: levelCap,
        id: id,
      );
}
