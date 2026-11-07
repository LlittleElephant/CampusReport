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
    case 'In Review': return kYellow;
    case 'In Progress': return kBlue;
    case 'Resolved': return kGreen;
    default: return const Color(0xFFD9D9D9);
  }
}

const kStudentDomain = 'alustudent.com';
const kStaffDomain = 'alueducation.com';
const kDomainMessage =
    'Use your ALU email.';

/// Returns 'student', 'staff', or null if the email is not an ALU address.
String? roleForEmail(String email) {
  final m = RegExp(r'^[^@\s]+@([^@\s]+)$').firstMatch(email.trim().toLowerCase());
  if (m == null) return null;
  final domain = m.group(1);
  if (domain == kStudentDomain) return 'student';
  if (domain == kStaffDomain) return 'staff';
  return null;
}