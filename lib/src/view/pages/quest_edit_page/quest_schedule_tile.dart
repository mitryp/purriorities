part of 'quest_edit_page.dart';

class _ScheduleTile extends StatelessWidget {
  final bool isPlanerUsed;
  final Callback<bool> onPlanerModeChanged;
  final bool isRepeating;
  final Callback<bool> onRepeatingModeChanged;
  final EdgeInsetsGeometry childrenPadding;
  final Widget separator;
  final DateTimeEditingController deadlineDateController;
  final TimeEditingController deadlineTimeController;
  final DateTimeEditingController lastDateController;

  const _ScheduleTile({
    required this.isPlanerUsed,
    required this.onPlanerModeChanged,
    required this.isRepeating,
    required this.onRepeatingModeChanged,
    required this.childrenPadding,
    required this.separator,
    required this.deadlineDateController,
    required this.deadlineTimeController,
    required this.lastDateController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: const Text('Планування'),
        trailing: Icon(isPlanerUsed ? Icons.check : Icons.close),
        onExpansionChanged: onPlanerModeChanged,
        initiallyExpanded: isPlanerUsed,
        maintainState: true,
        childrenPadding: childrenPadding,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DeadlineRow(
                deadlineDateController: deadlineDateController,
                deadlineTimeController: deadlineTimeController,
                lastDateController: lastDateController,
                isRepeating: isRepeating,
                separator: separator,
              ),
              _RepeatControls(
                lastDateController: lastDateController,
                isRepeating: isRepeating,
                onRepeatModeChanged: onRepeatingModeChanged,
                separator: separator,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeadlineRow extends StatelessWidget {
  final bool isRepeating;
  final Widget separator;
  final DateTimeEditingController deadlineDateController;
  final TimeEditingController deadlineTimeController;

  // to shift the last date if it is before the deadline date.
  final DateTimeEditingController lastDateController;

  const _DeadlineRow({
    required this.isRepeating,
    required this.separator,
    required this.deadlineDateController,
    required this.deadlineTimeController,
    required this.lastDateController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.watch<NotifierWrapper<Quest>>();
    final quest = data.data;
    final currentDeadline = quest.deadline ?? DateTime.now().add(const Duration(days: 1));

    return Row(
      children: [
        DateSelectorFormField(
          controller: deadlineDateController,
          initialDate: currentDeadline,
          firstDate: DateTime(2023),
          lastDate: DateTime(2050),
          label: isRepeating ? 'Перший термін' : 'Кінцевий термін',
          onSelected: (date) {
            if (date == null) return;

            final newDeadline = currentDeadline.withDate(date);

            _setQuestDeadline(data, deadline: newDeadline);
          },
        ),
        TimeSelectorFormField(
          controller: deadlineTimeController,
          initialTime: currentDeadline.toTime(),
          onSelected: (time) {
            if (time == null) return;

            final newDeadline = currentDeadline.withTime(time);

            _setQuestDeadline(data, deadline: newDeadline);
          },
        ),
      ].wrap((child) => Expanded(child: child)).separate(separator),
    );
  }

  void _setQuestDeadline(NotifierWrapper<Quest> wrapper, {required DateTime deadline}) {
    final quest = wrapper.data;
    final limit = quest.limit;
    final newLimit = limit == null ? null : maxDate(limit, deadline);
    if (limit != newLimit) {
      lastDateController.dateTime = newLimit;
    }

    wrapper.data = quest.copyWith(
      deadline: deadline,
      limit: newLimit,
      interval: quest.interval,
    );
  }
}

class _RepeatControls extends StatelessWidget {
  final bool isRepeating;
  final Callback<bool> onRepeatModeChanged;
  final Widget separator;
  final DateTimeEditingController lastDateController;

  const _RepeatControls({
    required this.isRepeating,
    required this.onRepeatModeChanged,
    required this.separator,
    required this.lastDateController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.watch<NotifierWrapper<Quest>>();
    final quest = data.data;

    return ExpansionTile(
      title: const Text('Повторення'),
      trailing: Icon(isRepeating ? Icons.check : Icons.close),
      initiallyExpanded: isRepeating,
      onExpansionChanged: onRepeatModeChanged,
      childrenPadding: _MobileQuestEditPageState._inputRowPadding,
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
              initialValue: '${quest.interval ?? 1}',
              onChanged: _changeQuestIntervalFor(data, quest),
            ),
            DateSelectorFormField(
              controller: lastDateController,
              initialDate: quest.limit ?? quest.deadline,
              firstDate: quest.deadline ?? DateTime.now(),
              lastDate: DateTime(2050),
              onSelected: _changeQuestLastDateFor(data, quest),
              label: 'Зупинити після',
            ),
          ].wrap((child) => Expanded(child: child)).separate(separator),
        ),
        separator,
      ],
    );
  }

  Callback<String?> _changeQuestIntervalFor(NotifierWrapper<Quest> wrapper, Quest quest) {
    return (value) {
      final interval = int.tryParse(value ?? '');

      if (interval == null) return;

      wrapper.data = quest.copyWith(
        deadline: quest.deadline,
        limit: quest.limit,
        interval: interval,
      );
    };
  }

  Callback<DateTime?> _changeQuestLastDateFor(NotifierWrapper<Quest> wrapper, Quest quest) {
    return (lastDate) {
      wrapper.data = quest.copyWith(
        deadline: quest.deadline,
        limit: lastDate,
        interval: quest.interval,
      );
    };
  }
}
