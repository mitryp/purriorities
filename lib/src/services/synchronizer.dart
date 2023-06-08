import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../data/models/quest.dart';
import '../data/models/user.dart';
import '../data/user_data.dart';
import 'http/fetch/quests_fetch_service.dart';
import 'http/fetch/user_fetch_service.dart';
import 'http/util/fetch_service_bundle.dart';

/// A class providing the synchronization functionality.
/// It depends on [FetchServiceBundle] and [UserData], so make sure that providers of those objects
/// are present in the widget tree above the [BuildContext] given during a [Synchronizer]
/// construction.
class Synchronizer {
  final BuildContext _context;

  /// Creates a [Synchronizer] with a given [BuildContext].
  /// The created object will use the [FetchServiceBundle] and [UserData] of the [BuildContext].
  const Synchronizer(BuildContext context) : _context = context;

  UsersFetchService get _userFetchService => _context.read<FetchServiceBundle>().usersFetchService;

  QuestsFetchService get _questFetchService =>
      _context.read<FetchServiceBundle>().questsFetchService;

  T? _updateUserData<T>(T? Function(UserData data) upd) {
    if (!_context.mounted) return null;

    return upd(_context.read<UserData>());
  }

  /// Synchronizes the current user from the server and updates the [UserData] of [_context]
  /// accordingly.
  Future<User?> syncUser() async {
    log('synchronizing user', name: 'Synchronizer');

    final user = await _userFetchService.me().then((res) => res.isSuccessful ? res.result() : null);

    return _updateUserData<User>((data) => data.user = user);
  }

  /// Currently, synchronizes all the quests of the current user from the server and updates the
  /// [UserData] of [_context] with the obtained value.
  Future<List<Quest>?> syncQuests() async {
    log('synchronizing quests', name: 'Synchronizer');

    final quests = await _questFetchService
        .getMany()
        .then((res) => res.isSuccessful ? res.map((p) => p.data) : null);

    log('got $quests', name: 'Synchronizer');

    return _updateUserData((data) => data.quests = quests ?? []);
  }
}
