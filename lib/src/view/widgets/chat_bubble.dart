import 'package:flutter/material.dart';

const List<({double size, double left, double bottom})> _bubbles = [
  (size: 5, left: 0, bottom: 0),
  (size: 8, left: 7, bottom: 1),
  (size: 17, left: 15, bottom: 5),
];

const _bubbleColor = Colors.black;

class ChatBubble extends StatelessWidget {
  final String msg;

  const ChatBubble(this.msg, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 60,
      child: Stack(
        children: [
          ..._bubbles
              .map(
                (bubble) => _PositionedBubble(
                  size: bubble.size,
                  left: bubble.left,
                  bottom: bubble.bottom,
                ),
              )
              .toList(),
          const _PositionedBubble(
            size: 18,
            left: 32,
            bottom: 28,
          ),
          const _PositionedBubble(
            size: 35,
            left: 38,
            bottom: 9,
          ),
          const _PositionedBubble(
            size: 32,
            left: 30,
            bottom: 4,
          ),
          const _PositionedBubble(
            size: 18,
            left: 28,
            bottom: 3,
          ),
          Positioned(
            left: _bubbles.last.left - 1,
            bottom: _bubbles.last.bottom - 1,
            child: const Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              color: _bubbleColor,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 13.0,
                  vertical: 8.0,
                ),
                child: Text(
                  'Няв?',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionedBubble extends StatelessWidget {
  final double size;
  final double bottom;
  final double left;

  const _PositionedBubble({
    required this.size,
    required this.left,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      bottom: bottom,
      child: Container(
        decoration: ShapeDecoration.fromBoxDecoration(
          const BoxDecoration(
            shape: BoxShape.circle,
            color: _bubbleColor,
          ),
        ),
        height: size,
        width: size,
      ),
    );
  }
}
