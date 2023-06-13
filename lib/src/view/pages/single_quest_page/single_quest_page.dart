import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/enums/quest_priority.dart';
import '../../../data/models/quest.dart';
import '../../../data/models/quest_stage.dart';
import '../../../data/models/task.dart';
import '../../../data/util/notifier_wrapper.dart';
import '../../../util/extensions/string_capitalize.dart';
import '../../../util/time_format.dart';
import '../../dialogs/task_completion_dialog.dart';
import '../../widgets/authorizer.dart';
import '../../widgets/layouts/layout_selector.dart';
import '../../widgets/layouts/mobile.dart';

part 'quest_info_tiles.dart';

class SingleQuestPage extends StatelessWidget {
  final Quest quest;

  const SingleQuestPage(this.quest, {super.key});

  @override
  Widget build(BuildContext context) {
    return Authorizer(
      child: ChangeNotifierProvider<NotifierWrapper<Quest>>(
        create: (context) => NotifierWrapper(quest),
        child: LayoutSelector(
          mobileLayoutBuilder: (_) => const _MobileQuestsPage(),
          desktopLayoutBuilder: (_) => const Placeholder(),
        ),
      ),
    );
  }
}

class _MobileQuestsPage extends StatelessWidget {
  static const TextStyle questTitleStyle = TextStyle(fontSize: 20);
  static const ListTileThemeData _listTileThemeData = ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 24),
    leadingAndTrailingTextStyle: TextStyle(fontSize: 14),
  );

  const _MobileQuestsPage();

  @override
  Widget build(BuildContext context) {
    return Selector<NotifierWrapper<Quest>, Quest>(
      selector: (context, wrapper) => wrapper.data,
      builder: (context, quest, _) {
        final priorityTextStyle = quest.priority.textStyleWithColor;

        return MobileLayout.child(
          appBar: AppBar(
            title: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Квест ', style: questTitleStyle),
                  TextSpan(text: quest.name, style: priorityTextStyle),
                ],
              ),
            ),
          ),
          child: CustomScrollView(
            slivers: [
              Theme(
                data: Theme.of(context).copyWith(listTileTheme: _listTileThemeData),
                child: _QuestInfoTiles(quest, priorityTextStyle: priorityTextStyle),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverList.builder(
                itemCount: quest.stages.length,
                itemBuilder: (context, index) => _QuestStageDisplay(
                  quest.stages[index],
                  index: index,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}