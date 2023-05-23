import 'package:flutter/material.dart';

typedef ButtonBuilder = Widget Function({required VoidCallback onPressed, required Widget child});

class ProgressIndicatorButton extends StatefulWidget {
  late final Widget defaultChild;
  late final ButtonBuilder buttonBuilder;
  final Future Function() onPressed;

  ProgressIndicatorButton.elevated(
      {required Text textCaption, required this.onPressed, super.key}) {
    defaultChild = textCaption;
    buttonBuilder = ({required VoidCallback onPressed, required Widget child}) =>
        ElevatedButton(onPressed: onPressed, child: child);
  }

  ProgressIndicatorButton.outlined(
      {required Text textCaption, required this.onPressed, super.key}) {
    defaultChild = textCaption;
    buttonBuilder = ({required VoidCallback onPressed, required Widget child}) =>
        OutlinedButton(onPressed: onPressed, child: child);
  }

  ProgressIndicatorButton.text({required Text textCaption, required this.onPressed, super.key}) {
    defaultChild = textCaption;
    buttonBuilder = ({required VoidCallback onPressed, required Widget child}) =>
        TextButton(onPressed: onPressed, child: child);
  }

  ProgressIndicatorButton.icon({required Icon icon, required this.onPressed, super.key}) {
    defaultChild = icon;
    buttonBuilder = ({required VoidCallback onPressed, required Widget child}) =>
        IconButton(onPressed: onPressed, icon: child);
  }

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
            : widget.defaultChild);
  }

  void _handlePress() {
    if (isProcessing) return;

    setState(() => isProcessing = true);

    widget.onPressed().whenComplete(() => setState(() => isProcessing = false));
  }
}
