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

  Future<void> updateStatus({
    required String id,
    required String status,
    required String note,
    required String staffName,
  }) {
    return _col.doc(id).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
      'statusHistory': FieldValue.arrayUnion([
        {'status': status, 'at': Timestamp.now(), 'note': note, 'by': staffName}
      ]),
    });
  }

  Stream<List<Report>> allReports() => _col
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Report.fromDoc).toList());
}