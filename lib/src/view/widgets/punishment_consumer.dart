import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/punishments.dart';
import '../../data/user_data.dart';
import '../dialogs/reward_punishment_dialog.dart';

class PunishmentConsumer extends StatelessWidget {
  final Widget child;

  const PunishmentConsumer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final punishment = context.select<UserData, PendingPunishment?>(
      (data) => data.pendingPunishment,
    );

    if (punishment != null) _requestDisplayPunishment(context, punishment);

    return child;
  }

  void _requestDisplayPunishment(BuildContext context, PendingPunishment punishment) {
    final userData = context.read<UserData>();

    if (punishment.isAbsent || userData.punishmentHasBeenDisplayed) return;

    userData.punishmentHasBeenDisplayed = true;
    log('Requesting dialog display', name: 'PunishmentConsumer');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        userData.pendingPunishment = null;
        showRewardPunishmentDialog(
          label: 'Пропущені реченці',
          context: context,
          punishment: punishment,
        );
      }
    });
  }
}
