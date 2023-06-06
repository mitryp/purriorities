import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/quest.dart';
import '../../data/user_data.dart';
import 'quests_list.dart';

class ActiveQuestsView extends StatelessWidget {
  const ActiveQuestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<UserData, List<Quest>>(
      selector: (context, data) => data.quests,
      builder: (_, items, __) => QuestsList(items: items),
    );
  }
}
