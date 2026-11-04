import 'package:flutter/material.dart';

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