import 'package:flutter/material.dart';

import 'models/punishments.dart';
import 'models/quest.dart';
import 'models/quest_category.dart';
import 'models/user.dart';

class UserData with ChangeNotifier {
  User? _user;
  QuestCategory? _defaultCategory;
  List<Quest> _quests = [];
  PendingPunishment? _punishment;
  bool punishmentHasBeenDisplayed = false;

  User? get user => _user;

  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  QuestCategory? get defaultCategory => _defaultCategory;

  set defaultCategory(QuestCategory? category) {
    _defaultCategory = category;
    notifyListeners();
  }

  List<Quest> get quests => _quests;

  set quests(List<Quest> quests) {
    _quests = quests;
    notifyListeners();
  }

  void addQuest(Quest quest) {
    _quests
      ..add(quest)
      ..sort(
        (a, b) =>
            (a.deadline?.millisecondsSinceEpoch ?? 0) - (b.deadline?.millisecondsSinceEpoch ?? 0),
      );

    notifyListeners();
  }

  PendingPunishment? get pendingPunishment => _punishment;

  set pendingPunishment(PendingPunishment? punishment) {
    _punishment = punishment;
    punishmentHasBeenDisplayed = false;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;
}
