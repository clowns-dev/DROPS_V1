import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final bool fullWidth;

  const SearchField({required this.fullWidth, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : 200.0,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar',
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
            size: 24.0,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        ),
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
