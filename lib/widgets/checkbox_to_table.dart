import 'package:flutter/material.dart';

class CheckboxToTable extends StatelessWidget {
  final bool isChecked;

  const CheckboxToTable({super.key, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.0,
      height: 34.0,
      decoration: BoxDecoration(
        color: isChecked ? Colors.teal : Colors.transparent,
        border: Border.all(
          color: isChecked ? Colors.teal : Colors.grey.shade400,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: isChecked
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 20.0,
            )
          : null,
    );
  }
}
