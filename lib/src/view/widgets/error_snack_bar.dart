import 'package:flutter/material.dart';

class ErrorSnackBarContent extends StatelessWidget {
  final String titleText;
  final String? subtitleText;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const ErrorSnackBarContent({
    required this.titleText,
    this.subtitleText,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = backgroundColor ?? colorScheme.error;
    final txtColor = textColor ?? colorScheme.onError;
    final subtitleText = this.subtitleText;

    return ListTile(
      tileColor: bgColor,
      textColor: txtColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      title: Text(titleText),
      subtitle: subtitleText != null ? Text(subtitleText) : null,
      onTap: onTap,
    );
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackBar({
  required BuildContext context,
  required Widget content,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(padding: EdgeInsets.zero, content: content),
  );
}
