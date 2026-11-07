import 'package:flutter/material.dart';
import '../constants.dart';

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor(status),
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(status.toUpperCase(),
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.black)),
    );
  }
}