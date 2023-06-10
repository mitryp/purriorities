import 'package:flutter/material.dart';

class FormLayout extends StatelessWidget {
  final Widget form;
  final List<Widget> leading;
  final List<Widget> trailing;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const FormLayout({
    required this.form,
    this.leading = const [],
    this.trailing = const [],
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
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
