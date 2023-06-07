import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../data/models/quest.dart';
import '../data/models/user.dart';
import '../data/user_data.dart';
import 'http/fetch/quests_fetch_service.dart';
import 'http/fetch/user_fetch_service.dart';
import 'http/util/fetch_service_bundle.dart';

class Synchronizer {
  final BuildContext _context;

  const Synchronizer(this._context);

  UsersFetchService get _userFetchService => _context.read<FetchServiceBundle>().usersFetchService;

  QuestsFetchService get _questFetchService =>
      _context.read<FetchServiceBundle>().questsFetchService;

  T? _updateUserData<T>(T? Function(UserData data) upd) {
    if (!_context.mounted) return null;

    return upd(_context.read<UserData>());
  }

  Future<User?> syncUser() async {
    log('synchronizing user', name: 'Synchronizer');

    final user = await _userFetchService.me().then((res) => res.isSuccessful ? res.result() : null);

    return _updateUserData<User>((data) => data.user = user);
  }

  Future<List<Quest>?> syncQuests() async {
    log('synchronizing quests', name: 'Synchronizer');

    final quests = await _questFetchService
        .getMany()
        .then((res) => res.isSuccessful ? res.map((p) => p.data) : null);

    log('got $quests', name: 'Synchronizer');

    return _updateUserData((data) => data.quests = quests ?? []);
  }
}
