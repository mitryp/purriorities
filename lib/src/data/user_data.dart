import 'package:flutter/material.dart';

import 'models/punishments.dart';
import 'models/quest.dart';
import 'models/user.dart';

class UserData with ChangeNotifier {
  User? _user;
  List<Quest> _quests = [];
  List<PendingPunishment> _punishments = [];

  User? get user => _user;

  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  List<Quest> get quests => _quests;

  set quests(List<Quest> quests) {
    _quests = quests;
    notifyListeners();
  }

  List<PendingPunishment> get pendingPunishments => _punishments;

  set pendingPunishments(List<PendingPunishment> punishments) {
    _punishments = punishments;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;
}
