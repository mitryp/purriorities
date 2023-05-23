import 'package:flutter/material.dart';

class FormLayout extends StatelessWidget {
  final Widget form;
  final List<Widget> leading;
  final List<Widget> trailing;

  const FormLayout({
    required this.form,
    this.leading = const [],
    this.trailing = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...leading,
            form,
            ...trailing,
          ],
        ),
      ),
    );
  }
}
