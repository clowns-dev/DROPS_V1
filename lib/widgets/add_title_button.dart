import 'package:flutter/material.dart';

class AddTitleButton extends StatelessWidget {
  final String titleButton;
  const AddTitleButton({
    required this.titleButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      titleButton,
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}