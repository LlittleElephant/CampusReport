import 'package:flutter/material.dart';

const kCream = Color(0xFFFFF4E0);
const kYellow = Color(0xFFFFDC58);
const kPink = Color(0xFFFF6B9D);
const kBlue = Color(0xFF6BCBFF);
const kGreen = Color(0xFF7CE38B);

const kCategories = [
  'Broken facility',
  'Water shortage',
  'Electricity outage',
  'Damaged furniture',
  'Sanitation',
  'Safety concern',
  'Other',
];

const kStatuses = ['Submitted', 'In Review', 'In Progress', 'Resolved'];

Color statusColor(String status) {
  switch (status) {
    case 'In Review': return Colors.orange;
    case 'In Progress': return Colors.blue;
    case 'Resolved': return Colors.green;
    default: return Colors.grey;
  }
}