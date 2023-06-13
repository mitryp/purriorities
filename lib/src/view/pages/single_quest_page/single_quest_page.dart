import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/util/helping_functions.dart';
import '../../../data/enums/quest_priority.dart';
import '../../../data/models/punishments.dart';
import '../../../data/models/quest.dart';
import '../../../data/models/quest_stage.dart';
import '../../../data/models/rewards.dart';
import '../../../data/models/task.dart';
import '../../../data/models/task_refuse_response.dart';
import '../../../data/user_data.dart';
import '../../../data/util/notifier_wrapper.dart';
import '../../../services/cats_info_cache.dart';
import '../../../services/http/util/fetch_service_bundle.dart';
import '../../../services/tasks_service.dart';
import '../../../util/extensions/context_synchronizer.dart';
import '../../../util/extensions/string_capitalize.dart';
import '../../../util/time_format.dart';
import '../../dialogs/confirmation_dialog.dart';
import '../../dialogs/reward_punishment_dialog.dart';
import '../../dialogs/task_completion_dialog.dart';
import '../../widgets/authorizer.dart';
import '../../widgets/error_snack_bar.dart';
import '../../widgets/layouts/layout_selector.dart';
import '../../widgets/layouts/mobile.dart';
import '../collection/collection_cat.dart';

part 'quest_info_tiles.dart';

part 'quest_stage_display.dart';

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
          floatingActionButton: quest.isFinished
              ? null
              : FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.red[600],
                  child: const Icon(Icons.delete),
                ),
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

  Future<void> _processDeleteTask(BuildContext context, Quest quest) async {
    final fetchService = context.read<FetchServiceBundle>().questsFetchService;

    final isConfirmed = await showConfirmationDialog(
      context: context,
      prompt: 'Ви справді хочете видалити цей квест?',
      confirmLabelText: 'Так',
      denyLabelText: 'Ні',
    );

    // ignore: use_build_context_synchronously
    if (!context.mounted || !isConfirmed) return;

    final res = await fetchService.delete(quest.id);

    // ignore: use_build_context_synchronously
    if (!context.mounted) return;

    if (res.isSuccessful && res.result()) {
      context.synchronizer().syncQuests();
      context.pop();

      return;
    }

    showErrorSnackBar(
      context: context,
      content: ErrorSnackBarContent(
        titleText: 'Сталася помилка під час видалення квесту',
        subtitleText: 'Повідомлення від сервера: ${res.errorMessage}',
      ),
    );
  }
}
