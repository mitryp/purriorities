import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/enums/priority.dart';
import '../../data/models/quest.dart';
import '../../util/extensions/datetime_extensions.dart';
import '../../util/extensions/widget_list_extensions.dart';
import '../../util/widget_wrapper.dart';
import '../theme.dart';
import '../widgets/date_selector_form_field.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/priority_selector.dart';
import '../widgets/time_selector_form_field.dart';

class QuestEditPage extends StatelessWidget {
  final QuestModel? initialQuest;

  const QuestEditPage({this.initialQuest, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: initialQuest ?? QuestModel(),
      child: LayoutSelector(
        mobileLayoutBuilder: (context) => MobileQuestEditPage(
          isEditing: initialQuest != null,
        ),
        desktopLayoutBuilder: (context) => const Placeholder(),
      ),
    );
  }
}

class MobileQuestEditPage extends StatefulWidget {
  final bool isEditing;

  const MobileQuestEditPage({this.isEditing = false, super.key});

  @override
  State<MobileQuestEditPage> createState() => _MobileQuestEditPageState();
}

class _MobileQuestEditPageState extends State<MobileQuestEditPage> {
  static const _inputRowPadding = EdgeInsets.symmetric(vertical: 8);
  static const _separator = SizedBox.square(dimension: 8);

  QuestPriority _selectedPriority = QuestPriority.regular;
  bool _isPlanerUsed = false;
  bool _isRepeating = false;

  @override
  Widget build(BuildContext context) {
    return MobileLayout.child(
      minimumSafeArea: MobileLayout.defaultSafeArea.copyWith(top: 0, left: 16, right: 16),
      appBar: AppBar(
        title: Text('${widget.isEditing ? 'Існуючий' : 'Новий'} квест'),
      ),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              _buildQuestForm(),
              // todo skills selector
              // todo stages&tasks block
            ]),
          )
        ],
      ),
    );
  }

  Widget _buildQuestForm() {
    final children = [
      TextFormField(
        decoration: const InputDecoration(labelText: 'Назва квесту'),
      ),
      _buildPriorityCategoryRow(),
      _buildScheduleTile(),
      // todo expansion tile with deadlines and scheduling
    ];

    return Form(
      child: Column(
        children: children.separate(_separator),
      ),
    );
  }

  Widget _buildPriorityCategoryRow() {
    final children = [
      _buildPrioritySelector(),
      _buildCategorySelector(),
    ].wrap(Expanded.new).separate(_separator);

    return Row(children: children);
  }

  Widget _buildPrioritySelector() {
    return PrioritySelector(
      onSelectChanged: (value) => setState(() => _selectedPriority = value),
      selected: _selectedPriority,
    );
  }

  Widget _buildCategorySelector() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: () {}, //todo
              borderRadius: defaultBorderRadius,
              child: const ListTile(
                title: FittedBox(child: Text('Обрати категорію', textAlign: TextAlign.center)),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildScheduleTile() {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: const Text('Планування'),
        trailing: Icon(_isPlanerUsed ? Icons.check : Icons.close),
        onExpansionChanged: (value) => setState(() => _isPlanerUsed = value),
        initiallyExpanded: _isPlanerUsed,
        maintainState: true,
        childrenPadding: _inputRowPadding,
        children: _buildExpansionTileChildren(),
      ),
    );
  }

  List<Widget> _buildExpansionTileChildren() {
    // final deadlineDatetime = context.select<QuestModel, DateTime>((quest) => quest.deadline);
    final deadlineDatetime = DateTime.now().copyWith(hour: 23, minute: 59); // todo
    final firstDate = DateTime(2023);
    final lastDate = DateTime(2050);

    return [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDeadlineRow(
            deadlineDatetime: deadlineDatetime,
            firstDate: firstDate,
            lastDate: lastDate,
          ),
          _buildRepeatControls(deadlineDatetime),
        ],
      ),
    ];
  }

  Row _buildDeadlineRow({
    required DateTime deadlineDatetime,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return Row(
      children: [
        DateSelectorFormField(
          initialDate: deadlineDatetime,
          firstDate: firstDate,
          lastDate: lastDate,
          label: _isRepeating ? 'Перший термін' :'Кінцевий термін',
          onSelected: (newDate) {}, // todo
        ),
        TimeSelectorFormField(
          initialTime: deadlineDatetime.toTime(),
          onSelected: (newTime) {}, // todo
        ),
      ].wrap(Expanded.new).separate(_separator),
    );
  }

  Widget _buildRepeatControls(DateTime deadlineDatetime) {
    return ExpansionTile(
      title: const Text('Повторення'),
      trailing: Icon(_isRepeating ? Icons.check : Icons.close),
      initiallyExpanded: _isRepeating,
      onExpansionChanged: (value) => setState(() => _isRepeating = value),
      childrenPadding: _inputRowPadding,
      children: [
        Row(
          children: [
            TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Інтервал',
                suffixText: 'днів',
              ),
              // todo
              initialValue: '1',
              onChanged: (value) {},
            ),
            DateSelectorFormField(
              initialDate: deadlineDatetime,
              firstDate: deadlineDatetime,
              lastDate: DateTime(2050),
              onSelected: (newFirstDate) {},
              label: 'Запинити після',
            ),
          ].wrap(Expanded.new).separate(_separator),
        ),
        _separator,
      ],
    );
  }
}
