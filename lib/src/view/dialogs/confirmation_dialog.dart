import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmationDialog extends StatelessWidget {
  static const Widget defaultConfirmLabel = Text('Прийняти');
  static const Widget defaultDenyLabel = Text('Скасувати');

  final Widget? title;
  final List<Widget> promptChildren;
  final VoidCallback? onConfirm;
  final VoidCallback? onDeny;
  final Widget confirmLabel;
  final Widget? denyLabel;
  final bool barrierDismissible;

  const ConfirmationDialog({
    required this.promptChildren,
    this.title,
    this.confirmLabel = defaultConfirmLabel,
    this.denyLabel,
    this.onConfirm,
    this.onDeny,
    this.barrierDismissible = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      titlePadding: const EdgeInsets.all(24).copyWith(bottom: 0, top: 16),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: promptChildren,
        ),
      ),
      contentPadding: const EdgeInsets.all(24).copyWith(top: title != null ? 0 : null),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: const EdgeInsets.all(24).copyWith(top: 0),
      actions: [
        if (denyLabel != null)
          OutlinedButton(
            onPressed: () => _processDeny(context),
            child: denyLabel,
          ),
        OutlinedButton(
          onPressed: () => _processConfirm(context),
          child: confirmLabel,
        ),
      ],
    );
  }

  void _processDeny(BuildContext context) {
    context.pop(false);
    onDeny?.call();
  }

  void _processConfirm(BuildContext context) {
    context.pop(true);
    onConfirm?.call();
  }
}

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String prompt,
  String confirmLabelText = 'Прийняти',
  String? denyLabelText,
  String? title,
  VoidCallback? onConfirm,
  VoidCallback? onDeny,
  bool barrierDismissible = true,
  TextStyle promptStyle = const TextStyle(fontSize: 16),
  TextStyle? titleStyle,
}) {
  return showDialog<bool>(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) => ConfirmationDialog(
      title: title != null ? Text(title, style: titleStyle) : null,
      promptChildren: [Text(prompt, style: promptStyle)],
      barrierDismissible: barrierDismissible,
      confirmLabel: Text(confirmLabelText),
      denyLabel: denyLabelText != null ? Text(denyLabelText) : null,
      onConfirm: onConfirm,
      onDeny: onDeny,
    ),
  ).then((value) => value ?? false);
}
