import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String id, title, description, category, location, status;
  final String reporterId, reporterName;
  final String? imageUrl;
  final DateTime createdAt;
  final List<Map<String, dynamic>> statusHistory;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.status,
    required this.reporterId,
    required this.reporterName,
    required this.createdAt,
    required this.statusHistory,
    this.imageUrl,
  });

  factory Report.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data()!;
    return Report(
      id: doc.id,
      title: m['title'] ?? '',
      description: m['description'] ?? '',
      category: m['category'] ?? 'Other',
      location: m['location'] ?? '',
      status: m['status'] ?? 'Submitted',
      reporterId: m['reporterId'] ?? '',
      reporterName: m['reporterName'] ?? '',
      imageUrl: m['imageUrl'],
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      statusHistory: List<Map<String, dynamic>>.from(m['statusHistory'] ?? []),
    );
  }
}