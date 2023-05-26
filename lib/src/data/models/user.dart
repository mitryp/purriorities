import 'package:json_annotation/json_annotation.dart';

/// A class representing the current user of the application.
@JsonSerializable()
class User {
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
}
