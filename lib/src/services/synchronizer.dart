import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../data/models/punishments.dart';
import '../data/models/quest.dart';
import '../data/models/quest_category.dart';
import '../data/models/user.dart';
import '../data/user_data.dart';
import 'helpers/pagination_data.dart';
import 'http/fetch/categories_fetch_service.dart';
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

  FetchServiceBundle _bundle() => _context.read<FetchServiceBundle>();

  CategoriesFetchService _categoryFetchService() => _bundle().categoriesFetchService;

  UsersFetchService _userFetchService() => _bundle().usersFetchService;

  QuestsFetchService _questFetchService() => _bundle().questsFetchService;

  T? _updateUserData<T>(T? Function(UserData data) upd) {
    if (!_context.mounted) return null;

    return upd(_context.read<UserData>());
  }

  /// Synchronizes the current user from the server and updates the [UserData] of [_context]
  /// accordingly.
  Future<User?> syncUser() async {
    log('synchronizing user', name: 'Synchronizer');

    final user =
        await _userFetchService().me().then((res) => res.isSuccessful ? res.result() : null);

    return _updateUserData<User>((data) => data.user = user);
  }

  /// Synchronizes all the active quests of the current user from the server and updates the
  /// [UserData] of [_context] with the obtained value.
  Future<List<Quest>?> syncQuests() async {
    const activeQuestsPaginationData = PaginationData(filter: {'finishDate': '\$null'});

    log('synchronizing quests', name: 'Synchronizer');

    final quests = await _questFetchService()
        .getMany(activeQuestsPaginationData)
        .then((res) => res.isSuccessful ? res.map((p) => p.data) : null);

    return _updateUserData((data) => data.quests = quests ?? []);
  }

  /// Synchronizes the inbox category of the current user and updates the [UserData] of [_context]
  /// with the received value.
  Future<QuestCategory?> syncDefaultCategory() async {
    log('synchronizing inbox category', name: 'Synchronizer');

    final category = await _categoryFetchService()
        .getDefault()
        .then((res) => res.isSuccessful ? res.result() : null);

    return _updateUserData((data) => data.defaultCategory = category);
  }

  /// Synchronizes the pending punishment, updates the [UserData] of [_context] with the received
  /// value.
  Future<PendingPunishment?> syncPunishment() async {
    final punishment = await _userFetchService()
        .pendingPunishment()
        .then((res) => res.isSuccessful ? res.result() : null);

    return _updateUserData((data) => data.pendingPunishment = punishment);
  }
}
