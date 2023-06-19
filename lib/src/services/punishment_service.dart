import 'dart:async';
import 'dart:developer';

import 'package:comparators/comparators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/punishments.dart';
import '../data/models/quest.dart';
import '../data/user_data.dart';
import '../util/extensions/context_synchronizer.dart';
import '../util/extensions/datetime_extensions.dart';
import 'synchronizer.dart';

/// A class for planning the punishment synchronization.
///
/// Depends on [UserData] and [Synchronizer] of the [_context], so make sure that their providers
/// are present in the widget tree above this ones.
class PunishmentTimerService {
  final BuildContext _context;
  Timer? _timer;

  PunishmentTimerService(this._context);

  bool get isSyncPlanned => _timer != null;

  bool reschedulePunishmentSync() {
    final nextPunishment = _nextQuestToPunishFor();

    if (nextPunishment == null) return false;

    _scheduleSyncAt(nextPunishment.deadline!.withDate(DateTime.now().toDate()));

    return true;
  }

  Quest? _nextQuestToPunishFor() {
    final activeQuests = _context
        .read<UserData>()
        .quests
        .where((e) => e.deadline != null)
        .toList(growable: false)
      ..sort(compare<Quest>((q) => q.deadline!));

    if (activeQuests.isEmpty) return null;

    final dateNow = DateTime.now();
    final nextQuests = activeQuests.skipWhile((q) => q.deadline!.isBefore(dateNow));

    return nextQuests.firstOrNull;
  }

  bool _scheduleSyncAt(DateTime dateTime) {
    final delta = dateTime.difference(DateTime.now());

    if (delta.isNegative) return false;

    _timer = Timer(delta, syncPunishments);
    log('Planned synchronization at $dateTime', name: 'PunishmentTimerService');

    return true;
  }

  Future<PendingPunishment?> syncPunishments() async {
    log('Synchronizing punishments', name: 'PunishmentTimerService');
    if (!_context.mounted) return null;

    final sync = _context.synchronizer();
    final punishment = await sync.syncPunishment();

    Future.wait([sync.syncUser(), sync.syncQuests()]).whenComplete(reschedulePunishmentSync);

    return punishment;
  }

  void cancel() {
    log('Canceling a planned synchronization', name: 'PunishmentTimerService');

    _timer?.cancel();
    _timer = null;
  }
}
