import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Object? heroTag;

  const AddButton({required this.onPressed, this.heroTag, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    );
  }
}
