import 'package:flutter/material.dart';

typedef ButtonBuilder = Widget Function({required VoidCallback onPressed, required Widget child});

class ProgressIndicatorButton extends StatefulWidget {
  final Widget child;
  final ButtonBuilder buttonBuilder;
  final Future Function() onPressed;

  const ProgressIndicatorButton({
    required this.buttonBuilder,
    required this.child,
    required this.onPressed,
    super.key,
  });

  const ProgressIndicatorButton.elevated({
    required Widget child,
    required this.onPressed,
    super.key,
  })  : child = child,
        buttonBuilder = ElevatedButton.new;

  const ProgressIndicatorButton.outlined({
    required Text textCaption,
    required this.onPressed,
    super.key,
  })  : child = textCaption,
        buttonBuilder = OutlinedButton.new;

  const ProgressIndicatorButton.text({
    required Text textCaption,
    required this.onPressed,
    super.key,
  })  : child = textCaption,
        buttonBuilder = TextButton.new;

  @override
  State<ProgressIndicatorButton> createState() => _ProgressIndicatorButtonState();
}

class _ProgressIndicatorButtonState extends State<ProgressIndicatorButton> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return widget.buttonBuilder(
      onPressed: _handlePress,
      child: isProcessing
          ? Transform.scale(scale: 0.5, child: const CircularProgressIndicator())
          : widget.child,
    );
  }

  void _handlePress() {
    if (isProcessing) return;

    setState(() => isProcessing = true);

    widget.onPressed().whenComplete(() {
      if (!mounted) return;
      setState(() => isProcessing = false);
    });
  }
}
