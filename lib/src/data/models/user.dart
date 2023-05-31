import 'package:json_annotation/json_annotation.dart';

import 'abs/model.dart';
import 'abs/prototype.dart';

part 'user.g.dart';

/// A class representing the current user of the application.
@JsonSerializable()
class User with Prototype<User> implements Serializable {
  /// An id of this user.
  final String id;

  /// A nickname of this user.
  final String nickname;

  /// An email of this user.
  final String email;

  /// A date at which this user joined the service.
  final DateTime joinDate;

  /// A localization set for this user.
  final String locale;

  /// A timezone set for this user.
  final String timezone;

  /// A current level of this user.
  /// Must be non-negative.
  final int level;

  /// An experience points which this user has gained on his [level].
  /// Must be non-negative.
  final int levelExp;

  /// An amount of cat food that this user has gained.
  /// Must be non-negative.
  final int feed;

  /// An amount of catnip that this user has gained.
  /// Must be non-negative.
  final int catnip;

  /// An amount of cats' trust that this user have.
  /// Must be non-negative.
  final int trust;

  const User({
    required this.id,
    required this.nickname,
    required this.email,
    required this.joinDate,
    required this.locale,
    required this.timezone,
    required this.level,
    required this.levelExp,
    required this.feed,
    required this.catnip,
    required this.trust,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nickname == other.nickname &&
          email == other.email &&
          joinDate == other.joinDate &&
          locale == other.locale &&
          timezone == other.timezone &&
          level == other.level &&
          levelExp == other.levelExp &&
          feed == other.feed &&
          catnip == other.catnip &&
          trust == other.trust;

  @override
  int get hashCode =>
      id.hashCode ^
      nickname.hashCode ^
      email.hashCode ^
      joinDate.hashCode ^
      locale.hashCode ^
      timezone.hashCode ^
      level.hashCode ^
      levelExp.hashCode ^
      feed.hashCode ^
      catnip.hashCode ^
      trust.hashCode;

  @override
  User copyWith({
    String? nickname,
    String? email,
    String? locale,
    String? timezone,
  }) =>
      User(
        id: id,
        nickname: nickname ?? this.nickname,
        email: email ?? this.email,
        joinDate: joinDate,
        locale: locale ?? this.locale,
        timezone: timezone ?? this.timezone,
        level: level,
        levelExp: levelExp,
        feed: feed,
        catnip: catnip,
        trust: trust,
      );
}
