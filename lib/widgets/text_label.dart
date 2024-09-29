import 'package:flutter/material.dart';

class TextLabel extends StatelessWidget {
  final String content;
  const TextLabel({
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}