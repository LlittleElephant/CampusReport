import 'package:flutter/material.dart';
import '../models/report.dart';
import '../screens/shared/report_details_screen.dart';
import 'status_chip.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  final bool staff;
  const ReportCard(this.report, {super.key, this.staff = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(report.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('${report.category} • ${report.location}'),
        trailing: StatusChip(report.status),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ReportDetailsScreen(report: report, staffControls: staff)),
        ),
      ),
    );
  }
}