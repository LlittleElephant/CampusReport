import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/report.dart';
import '../services/report_service.dart';

class ReportProvider extends ChangeNotifier {
  final _service = ReportService();
  StreamSubscription<List<Report>>? _sub;
  List<Report> _reports = [];
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  List<Report> get reports => _reports;
  bool get loading => _loading;
  bool get submitting => _submitting;
  String? get error => _error;

  List<Report> mine(String uid) =>
      _reports.where((r) => r.reporterId == uid).toList();

  ReportProvider() {
    _sub = _service.allReports().listen((data) {
      _reports = data;
      _loading = false;
      notifyListeners();
    }, onError: (e) {
      _error = 'Could not load reports.';
      _loading = false;
      notifyListeners();
    });
  }

  Future<bool> submit({
    required String title,
    required String description,
    required String category,
    required String location,
    required String reporterId,
    required String reporterName,
    String? imageUrl,
  }) async {
    _submitting = true; _error = null; notifyListeners();
    try {
      await _service.createReport(
        title: title, description: description, category: category,
        location: location, reporterId: reporterId,
        reporterName: reporterName, imageUrl: imageUrl,
      );
      return true;
    } catch (e) {
      _error = 'Could not submit the report. Try again.';
      return false;
    } finally {
      _submitting = false; notifyListeners();
    }
  }

  Future<bool> updateStatus({
    required String id,
    required String status,
    required String note,
    required String staffName,
  }) async {
    _submitting = true; _error = null; notifyListeners();
    try {
      await _service.updateStatus(
          id: id, status: status, note: note, staffName: staffName);
      return true;
    } catch (e) {
      _error = 'Could not update the status.';
      return false;
    } finally {
      _submitting = false; notifyListeners();
    }
  }

  @override
  void dispose() { _sub?.cancel(); super.dispose(); }
}