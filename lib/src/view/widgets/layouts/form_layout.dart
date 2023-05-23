import 'package:flutter/material.dart';

class FormLayout extends StatelessWidget {
  final Widget form;
  final List<Widget> leading;

  const FormLayout({
    required this.form,
    this.leading = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...leading,
          form,
        ],
      ),
    );
  }
}
