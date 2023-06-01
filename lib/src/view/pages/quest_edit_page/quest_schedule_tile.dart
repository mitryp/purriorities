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
  static const int _firstYear = 2023;
  static const int _lastYear = 2050;
  static const Duration _initialDurationToDeadline = Duration(days: 1);

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
  });

  @override
  Widget build(BuildContext context) {
    final data = context.watch<NotifierWrapper<Quest>>();
    final quest = data.data;
    final currentDeadline = quest.deadline ?? DateTime.now().add(_initialDurationToDeadline);

    return Row(
      children: [
        Expanded(
          child: DateSelectorFormField(
            controller: deadlineDateController,
            initialDate: currentDeadline,
            firstDate: DateTime(_firstYear),
            lastDate: DateTime(_lastYear),
            label: isRepeating ? 'Перший термін' : 'Кінцевий термін',
            onSelected: _processDateSelection(currentDeadline, data),
          ),
        ),
        separator,
        Expanded(
          child: TimeSelectorFormField(
            controller: deadlineTimeController,
            initialTime: currentDeadline.toTime(),
            onSelected: _processTimeSelection(currentDeadline, data),
          ),
        ),
      ],
    );
  }

  Callback<DateTime?> _processDateSelection(
    DateTime currentDeadline,
    NotifierWrapper<Quest> data,
  ) =>
      (date) {
        if (date == null) return;

        final newDeadline = currentDeadline.withDate(date);

        _setQuestDeadline(data, deadline: newDeadline);
      };

  Callback<TimeOfDay?> _processTimeSelection(
    DateTime currentDeadline,
    NotifierWrapper<Quest> data,
  ) =>
      (time) {
        if (time == null) return;

        final newDeadline = currentDeadline.withTime(time);

        _setQuestDeadline(data, deadline: newDeadline);
      };

  void _setQuestDeadline(NotifierWrapper<Quest> wrapper, {required DateTime deadline}) {
    final quest = wrapper.data;
    final limit = quest.limit;
    final newLimit = limit == null ? null : maxDate(limit, deadline);
    if (limit != newLimit) {
      lastDateController.dateTime = newLimit;
    }

    wrapper.data = quest.copyWithSchedule(
      deadline: deadline,
      limit: newLimit,
      interval: quest.interval,
    );
  }
}

class _RepeatControls extends StatelessWidget {
  static const int _initialIntervalDays = 1;

  final bool isRepeating;
  final Callback<bool> onRepeatModeChanged;
  final Widget separator;
  final DateTimeEditingController lastDateController;

  const _RepeatControls({
    required this.isRepeating,
    required this.onRepeatModeChanged,
    required this.separator,
    required this.lastDateController,
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
      childrenPadding: _MobileQuestEditPageState._inputRowPadding.copyWith(bottom: 0),
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Інтервал',
                  suffixText: 'днів',
                ),
                initialValue: '${quest.interval ?? _initialIntervalDays}',
                onChanged: _changeQuestIntervalFor(data, quest),
              ),
            ),
            separator,
            Expanded(
              child: DateSelectorFormField(
                controller: lastDateController,
                initialDate: quest.limit ?? quest.deadline,
                firstDate: quest.deadline ?? DateTime.now(),
                lastDate: DateTime(_DeadlineRow._lastYear),
                onSelected: _changeQuestLastDateFor(data, quest),
                label: 'Зупинити після',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Callback<String?> _changeQuestIntervalFor(NotifierWrapper<Quest> wrapper, Quest quest) {
    return (value) {
      final interval = int.tryParse(value ?? '');

      if (interval == null) return;

      wrapper.data = quest.copyWithSchedule(
        deadline: quest.deadline,
        limit: quest.limit,
        interval: interval,
      );
    };
  }

  Callback<DateTime?> _changeQuestLastDateFor(NotifierWrapper<Quest> wrapper, Quest quest) {
    return (lastDate) {
      wrapper.data = quest.copyWithSchedule(
        deadline: quest.deadline,
        limit: lastDate,
        interval: quest.interval,
      );
    };
  }
}
