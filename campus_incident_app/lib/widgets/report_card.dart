import 'package:flutter/material.dart';
import 'package:neobrutalism_ui/neobrutalism_ui.dart';
import '../models/report.dart';
import '../screens/shared/report_details_screen.dart';
import 'status_chip.dart';

void openReport(BuildContext context, Report r, {bool staff = false}) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (_) => ReportDetailsScreen(report: r, staffControls: staff)),
  );
}

class ReportCard extends StatelessWidget {
  final Report report;
  final bool staff;
  const ReportCard(this.report, {super.key, this.staff = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, right: 4),
      child: GestureDetector(
        onTap: () => openReport(context, report, staff: staff),
        child: NeoCard(
          color: Colors.white,
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(report.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 8),
              StatusChip(report.status),
            ]),
            const SizedBox(height: 6),
            Text('${report.category} • ${report.location}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    );
  }
}