import 'package:flutter/material.dart';

class DropdownFilter extends StatelessWidget {
  final bool fullWidth;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownFilter({
    required this.fullWidth,
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : 150.0,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
        isExpanded: true,
      ),
    );
  }
}
