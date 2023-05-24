import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../util/datetime_comparison.dart';

class DateSelectorFormField extends StatefulWidget {
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
    this.initialDate,
    this.dateFormat = 'dd.MM.yyyy',
    this.preserveWhenNotSelected = true,
    this.label = 'Дата',
    super.key,
  }) : assert(!preserveWhenNotSelected || initialDate != null);

  @override
  State<DateSelectorFormField> createState() => _DateSelectorFormFieldState();
}

class _DateSelectorFormFieldState extends State<DateSelectorFormField> {
  late DateTime? _selectedDate = widget.initialDate;
  late final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setDate(widget.initialDate);
  }

  @override
  Widget build(BuildContext context) {
    log(_controller.text);
    return TextFormField(
      readOnly: true,
      controller: _controller,
      onTap: _showDatePicker,
      decoration: InputDecoration(labelText: widget.label),
    );
  }

  void _showDatePicker() async {
    final initialDate = _selectedDate ??
        minDate(
          maxDate(widget.firstDate, DateTime.now()),
          widget.lastDate,
        );

    DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (!mounted) return;

    if (widget.preserveWhenNotSelected) {
      date ??= _selectedDate;
    }

    _setDate(date);
  }

  void _setDate(DateTime? date) {
    setState(() => _selectedDate = date);
    _controller.text =
        _selectedDate != null ? DateFormat(widget.dateFormat).format(_selectedDate!) : '';
    widget.onSelected(date);
  }
}
