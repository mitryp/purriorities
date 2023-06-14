import 'dart:collection';
import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import '../../common/enums/currency.dart';
import 'abs/prototype.dart';
import 'abs/serializable.dart';
import 'cat_ownership.dart';
import 'punishments.dart';

part 'user.g.dart';

/// A class representing the current user of the application.
@JsonSerializable()
class User extends Serializable with Prototype<User> {
  /// A nickname of this user.
  final String nickname;

  /// An email of this user.
  final String email;

  /// A current level of this user.
  /// Must be non-negative.
  @JsonKey(includeToJson: false)
  final int level;

  /// An experience points which this user has gained on his [level].
  /// Must be non-negative.
  @JsonKey(includeToJson: false)
  final int levelExp;

  /// An amount of XP needed for the user to level up.
  @JsonKey(includeToJson: false)
  final int levelCap;

  /// An amount of cat food that this user has gained.
  /// Must be non-negative.
  @JsonKey(includeToJson: false)
  final int feed;

  /// An amount of catnip that this user has gained.
  /// Must be non-negative.
  @JsonKey(includeToJson: false)
  final int catnip;

  /// An amount of cats' trust that this user have.
  /// Must be non-negative.
  @JsonKey(includeToJson: false)
  final double trust;

  @JsonKey(includeToJson: false, required: false)
  final List<CatOwnership> catOwnerships;

  const User({
    required this.nickname,
    required this.email,
    required this.level,
    required this.levelExp,
    required this.levelCap,
    required this.feed,
    required this.catnip,
    required this.trust,
    this.catOwnerships = const [],
  });

  const User.register({
    required this.nickname,
    required this.email,
  })  : level = 0,
        levelExp = 0,
        levelCap = 0,
        feed = 0,
        catnip = 0,
        trust = 0,
        catOwnerships = const [];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          nickname == other.nickname &&
          email == other.email &&
          level == other.level &&
          levelExp == other.levelExp &&
          levelCap == other.levelCap &&
          feed == other.feed &&
          catnip == other.catnip &&
          trust == other.trust &&
          catOwnerships == other.catOwnerships;

  @override
  int get hashCode =>
      nickname.hashCode ^
      email.hashCode ^
      level.hashCode ^
      levelExp.hashCode ^
      levelCap.hashCode ^
      feed.hashCode ^
      catnip.hashCode ^
      trust.hashCode ^
      catOwnerships.hashCode;

  @override
  User copyWith({
    String? nickname,
    String? email,
    int? level,
    int? levelExp,
    int? levelCap,
    int? feed,
    int? catnip,
    double? trust,
    List<CatOwnership>? catOwnerships,
  }) =>
      User(
        nickname: nickname ?? this.nickname,
        email: email ?? this.email,
        level: level ?? this.level,
        levelExp: levelExp ?? this.levelExp,
        levelCap: levelCap ?? this.levelCap,
        feed: feed ?? this.feed,
        catnip: catnip ?? this.catnip,
        trust: trust ?? this.trust,
        catOwnerships: catOwnerships ?? this.catOwnerships,
      );

  /// Returns a copy of this user object after the given [punishment] applied.
  User applyPunishment(PendingPunishment punishment) {
    final trust = this.trust - punishment.overdueQuests.fold<int>(0, (val, e) => val + e.trustLost);
    final feed = this.feed - punishment.runawayCats.fold<int>(0, (val, e) => val + e.feedTaken);

    final runawayCatIds = HashSet.of(punishment.runawayCats.map((e) => e.nameId));
    final cats = catOwnerships.toList()
      ..removeWhere((cat) => runawayCatIds.contains(cat.catNameId));

    return copyWith(trust: trust, feed: feed, catOwnerships: cats.toList(growable: false));
  }

  /// Returns the amount of the given [currency] this user has.
  int amountOfCurrency(Currency currency) {
    return switch (currency) {
      Currency.feed => feed,
      Currency.catnip => catnip,
    };
  }

  /// Returns a copy of this user with the [amount] of [currency] removed from its balance.
  User removeCurrency(int amount, Currency currency) {
    return switch (currency) {
      Currency.feed => copyWith(feed: max(0, feed - amount)),
      Currency.catnip => copyWith(catnip: max(0, catnip - amount)),
    };
  }

  /// Returns a copy of this user with added or replaced [cat].
  User updateCatOwnership(CatOwnership cat) {
    final cats = catOwnerships.toList();
    cats
      ..removeWhere((c) => c.catNameId == cat.catNameId)
      ..add(cat);

    return copyWith(catOwnerships: cats.toList(growable: false));
  }
}
