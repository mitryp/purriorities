import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../data/models/quest.dart';
import '../../../data/models/quest_category.dart';
import '../../../data/models/skill.dart';

class QuestsPageData with ChangeNotifier {
  List<Skill?> skills = [null];
  bool _isFiltersLoaded = false;

  QuestCategory? _filterCategory;
  Skill? _filterSkill;

  List<Quest> _quests = [];
  bool _isLoaded = false;
  DioError? _error;

  bool get areFiltersApplied => _filterCategory != null || _filterSkill != null;

  QuestCategory? get filterCategory => _filterCategory;

  bool get areFiltersLoaded => _isFiltersLoaded;

  DioError? get error => _error;

  set error(DioError? error) {
    _error = error;
    notifyListeners();
  }

  set areFiltersLoaded(bool value) {
    _isFiltersLoaded = value;
    notifyListeners();
  }

  set filterCategory(QuestCategory? category) {
    _filterCategory = category;
    notifyListeners();
  }

  Skill? get filterSkill => _filterSkill;

  set filterSkill(Skill? skill) {
    _filterSkill = skill;
    notifyListeners();
  }

  bool get isLoaded => _isLoaded;

  set isLoaded(bool value) {
    _isLoaded = value;
    notifyListeners();
  }

  List<Quest> get quests => _quests;

  set quests(List<Quest> value) {
    _quests = value;
    notifyListeners();
  }
}
