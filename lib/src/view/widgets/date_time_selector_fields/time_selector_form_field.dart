import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../util/extensions/datetime_extensions.dart';
import 'datetime_editing_controller.dart';

class TimeSelectorFormField extends StatefulWidget {
  final TimeEditingController? controller;
  final TimeOfDay? initialTime;
  final void Function(TimeOfDay?) onSelected;

  final bool preserveWhenNotSelected;
  final String timeFormat;
  final String label;

  const TimeSelectorFormField({
    required this.onSelected,
    this.controller,
    this.initialTime,
    this.preserveWhenNotSelected = true,
    this.timeFormat = 'HH:mm',
    this.label = 'Час',
    super.key,
  });

  @override
  State<TimeSelectorFormField> createState() => _TimeSelectorFormFieldState();
}

class _TimeSelectorFormFieldState extends State<TimeSelectorFormField> {
  late final TimeEditingController _controller = widget.controller ??
      TimeEditingController(
        format: widget.timeFormat,
        selectedTime: widget.initialTime,
      );

  late TimeOfDay? _previousTime = widget.initialTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialTime != null) {
      _controller.time = widget.initialTime;
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
    final initialTime = _controller.time ?? TimeOfDay.now();

    TimeOfDay? time = await showTimePicker(context: context, initialTime: initialTime);

    if (!mounted) return;

    if (widget.preserveWhenNotSelected) {
      time ??= _previousTime;
    }

    _setTime(time);
  }

  void _setTime(TimeOfDay? time) {
    _controller.time = time;
    _previousTime = time;
    widget.onSelected(time);
  }
}
