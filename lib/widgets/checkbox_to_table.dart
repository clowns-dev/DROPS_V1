import 'package:flutter/material.dart';

class CheckboxToTable extends StatelessWidget {
  final bool isChecked;
  final VoidCallback? onChanged;

  const CheckboxToTable({
    super.key,
    required this.isChecked,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        width: 20.0, 
        height: 20.0,
        decoration: BoxDecoration(
          color: isChecked ? Colors.teal : Colors.transparent,
          border: Border.all(
            color: isChecked ? Colors.teal : Colors.grey.shade400,
            width: 1.5, // Grosor más fino
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: isChecked
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 14.0, // Tamaño del ícono más pequeño
              )
            : null,
      ),
    );
  }
}
