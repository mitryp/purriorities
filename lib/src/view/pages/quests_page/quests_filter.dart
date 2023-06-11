import 'package:flutter/material.dart';

import '../../../typedefs.dart';

typedef StringTPresenter<T> = String Function(T);

class QuestsFilter<T> extends StatelessWidget {
  final String caption;
  final List<T> items;
  final T initialSelection;
  final Callback<T?> onChanged;
  final StringTPresenter<T> presenter;
  final EdgeInsetsGeometry? contentPadding;

  const QuestsFilter({
    required this.items,
    required this.caption,
    required this.initialSelection,
    required this.onChanged,
    required this.presenter,
    this.contentPadding = const EdgeInsets.all(12),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      onChanged: onChanged,
      value: initialSelection,
      decoration: InputDecoration(labelText: caption, contentPadding: contentPadding),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(presenter(item)),
        );
      }).toList(growable: false),
    );
  }
}
