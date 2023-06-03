import 'package:flutter/material.dart';

import '../../../util/datetime_comparison.dart';
import 'datetime_editing_controller.dart';

class DateSelectorFormField extends StatefulWidget {
  final DateTimeEditingController? controller;

  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  final void Function(DateTime?) onSelected;

  final String dateFormat;
  final bool preserveWhenNotSelected;
  final String label;

  const DateSelectorFormField({
    required this.firstDate,
    required this.lastDate,
    required this.onSelected,
    this.controller,
    this.initialDate,
    this.dateFormat = 'dd.MM.yyyy',
    this.preserveWhenNotSelected = true,
    this.label = 'Дата',
    super.key,
  });

  @override
  State<DateSelectorFormField> createState() => _DateSelectorFormFieldState();
}

class _DateSelectorFormFieldState extends State<DateSelectorFormField> {
  late final DateTimeEditingController _controller = widget.controller ??
      DateTimeEditingController(
        format: widget.dateFormat,
        selectedDate: widget.initialDate,
      );

  late DateTime? _previousDate = widget.initialDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _controller.dateTime = widget.initialDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: _controller,
      onTap: _showDatePicker,
      decoration: InputDecoration(labelText: widget.label),
    );
  }

  void _showDatePicker() async {
    final initialDate = _controller.dateTime ??
        minDate(
          maxDate(widget.firstDate, DateTime.now()),
          widget.lastDate,
        );

    DateTime? date = await showDatePicker(
      context: context,
      initialDate: minDate(maxDate(initialDate, widget.firstDate), widget.lastDate),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (!mounted) return;

    if (widget.preserveWhenNotSelected) {
      date ??= _previousDate;
    }

    _setDate(date);
  }

  void _setDate(DateTime? date) {
    // _selectedDate = date;
    _controller.dateTime = date;
    _previousDate = date;
    widget.onSelected(date);
  }
}
