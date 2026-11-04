import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report.dart';

class ReportService {
  final _col = FirebaseFirestore.instance.collection('reports');

  Future<void> createReport({
    required String title,
    required String description,
    required String category,
    required String location,
    required String reporterId,
    required String reporterName,
    String? imageUrl,
  }) {
    return _col.add({
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'status': 'Submitted',
      'reporterId': reporterId,
      'reporterName': reporterName,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'statusHistory': [
        {'status': 'Submitted', 'at': Timestamp.now(), 'note': ''}
      ],
    });
  }

  Stream<List<Report>> allReports() => _col
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Report.fromDoc).toList());
}