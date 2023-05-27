import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/enums/app_route.dart';
import '../widgets/add_button.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/quests_list.dart';

const skills = [
  'Всі',
  'Навчання',
  'Програмування',
  'Тайм-менеджмент',
];

const categories = [
  'Завдання',
  'Програмування',
  'Самоорганізація',
];

class QuestsPage extends StatelessWidget {
  const QuestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutSelector(
      mobileLayoutBuilder: (context) => const _MobileQuestsPage(),
      desktopLayoutBuilder: (context) => const Placeholder(),
    );
  }
}

final List<(String name, bool isRepeated, DateTime? deadline)> questsData = [
  ('Нявчитися писати бекенд...', false, DateTime(2023, 05, 24, 23, 59)),
  ('Позайматися', true, DateTime(2023, 05, 24, 18, 0)),
  ('Нявчитися нявати', false, DateTime(2023, 05, 30, 23, 59)),
  ('Помуркотіти коханого :3', false, null),
];

class _MobileQuestsPage extends StatelessWidget {
  const _MobileQuestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      appBar: AppBar(
        title: const Text('Квести'),
      ),
      floatingActionButton: AddButton(onPressed: () => GoRouter.of(context).push(AppRoute.editQuest.route)),
      children: [
        _buildFilters(),
        Card(
          child: QuestsList(items: questsData),
        )
      ],
    );
  }

  Widget _buildFilters() {
    return Card(
      child: Row(
        children: [
          _buildFilter(caption: 'Навичка', items: skills, initialSelection: skills[0]),
          _buildFilter(caption: 'Категорія', items: categories, initialSelection: categories[0]),
        ],
      ),
    );
  }

  Widget _buildFilter({required String caption, required List items, required initialSelection}) {
    return DropdownMenu(
      helperText: caption,
      enableSearch: true,
      initialSelection: initialSelection,
      dropdownMenuEntries: items.map((item) {
        return DropdownMenuEntry(value: item, label: item);
      }).toList(),
    );
  }
}
