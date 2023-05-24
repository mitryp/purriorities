import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSelectorFormField extends StatefulWidget {
  final TimeOfDay? initialTime;

  // final DateTime firstDate;
  // final DateTime lastDate;

  final void Function(TimeOfDay?) onSelected;

  final bool preserveWhenNotSelected;
  final String timeFormat;
  final String label;

  const TimeSelectorFormField({
    required this.initialTime,
    required this.onSelected,
    this.preserveWhenNotSelected = true,
    this.timeFormat = 'HH:mm',
    this.label = 'Час',
    super.key,
  }) : assert(!preserveWhenNotSelected || initialTime != null);

  @override
  State<TimeSelectorFormField> createState() => _TimeSelectorFormFieldState();
}

class _TimeSelectorFormFieldState extends State<TimeSelectorFormField> {
  late TimeOfDay? _selectedTime = widget.initialTime;
  late final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setTime(widget.initialTime);
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
    final initialTime = _selectedTime ?? TimeOfDay.now();

    TimeOfDay? time = await showTimePicker(context: context, initialTime: initialTime);

    if (!mounted) return;

    if (widget.preserveWhenNotSelected) {
      time ??= _selectedTime;
    }

    _setTime(time);
  }

  void _setTime(TimeOfDay? time) {
    final asDateTime = time != null ? DateTime(2022, 12, 31, time.hour, time.minute) : null;

    setState(() => _selectedTime = time);
    _controller.text = asDateTime != null ? DateFormat(widget.timeFormat).format(asDateTime) : '';
    widget.onSelected(time);
  }
}
