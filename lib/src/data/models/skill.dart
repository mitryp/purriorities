import 'package:json_annotation/json_annotation.dart';

import 'abs/serializable.dart';
import 'abs/prototype.dart';

part 'skill.g.dart';

/// A class representing a user-defined skill with the information about its current [level].
@JsonSerializable()
class Skill with Prototype<Skill> implements Serializable {
  /// A name of this skill, defined by the user during the skill creation.
  final String name;

  /// A level of this skill.
  final int level;

  /// An experience points which the current user has gained on this [level].
  final int levelExp;

  /// An id of this skill.
  final int id;

  const Skill({
    required this.name,
    required this.level,
    required this.levelExp,
    required this.id,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

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
          id == other.id;

  @override
  int get hashCode => name.hashCode ^ level.hashCode ^ levelExp.hashCode ^ id.hashCode;

  @override
  Skill copyWith({String? name}) => Skill(
      name: name ?? this.name,
      level: level,
      levelExp: levelExp,
      id: id,
    );
}
