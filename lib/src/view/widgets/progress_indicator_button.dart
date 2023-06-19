import 'dart:async';

import 'package:flutter/material.dart';

typedef ButtonBuilder = Widget Function({
  required VoidCallback? onPressed,
  required Widget child,
  ButtonStyle? style,
});

class ProgressIndicatorButton extends StatefulWidget {
  final Widget child;
  final ButtonBuilder buttonBuilder;
  final FutureOr Function()? onPressed;
  final ButtonStyle? style;

  const ProgressIndicatorButton({
    required this.buttonBuilder,
    required this.child,
    required this.onPressed,
    this.style,
    super.key,
  });

  const ProgressIndicatorButton.elevated({
    required this.child,
    required this.onPressed,
    this.style,
    super.key,
  }) : buttonBuilder = _elevatedButtonBuilder;

  const ProgressIndicatorButton.outlined({
    required Text textCaption,
    required this.onPressed,
    this.style,
    super.key,
  })  : child = textCaption,
        buttonBuilder = _outlinedButtonBuilder;

  const ProgressIndicatorButton.text({
    required Text textCaption,
    required this.onPressed,
    this.style,
    super.key,
  })  : child = textCaption,
        buttonBuilder = _textButtonBuilder;

  @override
  State<ProgressIndicatorButton> createState() => ProgressIndicatorButtonState();
}

class ProgressIndicatorButtonState extends State<ProgressIndicatorButton> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return widget.buttonBuilder(
      style: widget.style,
      onPressed: widget.onPressed != null ? handlePress : null,
      child: isProcessing
          ? Transform.scale(scale: 0.5, child: const CircularProgressIndicator())
          : widget.child,
    );
  }

  void handlePress() {
    if (isProcessing) return;

    setState(() => isProcessing = true);

    Future.value(widget.onPressed!()).whenComplete(() {
      if (!mounted) return;
      setState(() => isProcessing = false);
    });
  }
}

Widget _outlinedButtonBuilder({
  required VoidCallback? onPressed,
  required Widget child,
  ButtonStyle? style,
}) =>
    OutlinedButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );

Widget _elevatedButtonBuilder({
  required VoidCallback? onPressed,
  required Widget child,
  ButtonStyle? style,
}) =>
    ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );

Widget _textButtonBuilder({
  required VoidCallback? onPressed,
  required Widget child,
  ButtonStyle? style,
}) =>
    TextButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );
