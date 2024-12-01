import 'package:flutter/material.dart';

class AssignmentButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AssignmentButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 193, 89, 219),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: onPressed,
      child: const Text(
        'Asignar',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
