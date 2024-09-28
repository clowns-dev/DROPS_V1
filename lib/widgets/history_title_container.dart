import 'package:flutter/material.dart';

class HistoryTitleContainer extends StatelessWidget {
  final String titleTable;
  const HistoryTitleContainer( 
    {required this.titleTable, super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child:  Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.description,
            color: Colors.black,
            size: 24.0,
          ),
          const SizedBox(width: 8.0),
          Text(
            titleTable,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
