import '../../data/models/quest.dart';

bool deadlineMissed(Quest quest) =>
    !quest.isFinished && (quest.deadline?.isBefore(DateTime.now()) ?? false);
