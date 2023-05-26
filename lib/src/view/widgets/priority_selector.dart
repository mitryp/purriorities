import 'package:flutter/material.dart';

import '../../data/enums/quest_priority.dart';
import '../../util/extensions/string_capitalize.dart';

class PrioritySelector extends StatelessWidget {
  final void Function(QuestPriority newPriority) onSelectChanged;
  final List<QuestPriority> priorities;
  final QuestPriority? selected;

  const PrioritySelector({
    required this.onSelectChanged,
    this.selected,
    this.priorities = QuestPriority.values,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<QuestPriority>(
      value: selected,
      onChanged: _processChange,
      decoration: const InputDecoration(labelText: 'Рідкісність', contentPadding: EdgeInsets.zero),
      items: priorities
          .map((e) => DropdownMenuItem<QuestPriority>(value: e, child: _buildPriorityButton(e)))
          .toList(),
    );
  }

  Widget _buildPriorityButton(QuestPriority priority) {
    return PrioritySelectItem(
      priority: priority,
      onSelected: () => onSelectChanged(priority),
    );
  }

  void _processChange(QuestPriority? priority) {
    if (priority == null) return;
    onSelectChanged(priority);
  }
}

class PrioritySelectItem extends StatelessWidget {
  final QuestPriority priority;
  final VoidCallback onSelected;

  const PrioritySelectItem({
    required this.priority,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      priority.label.capitalize(),
      style: priority.textStyle.copyWith(color: priority.color),
    );
  }
}
