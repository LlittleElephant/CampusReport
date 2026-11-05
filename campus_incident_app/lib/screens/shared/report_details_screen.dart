import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/report.dart';
import '../../providers/report_provider.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/status_update_form.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Report report;
  final bool staffControls;
  const ReportDetailsScreen(
      {super.key, required this.report, this.staffControls = false});

  String _date(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final r = context.watch<ReportProvider>().reports.firstWhere(
        (x) => x.id == report.id,
        orElse: () => report);
    final reached = kStatuses.indexOf(r.status);

    return Scaffold(
      appBar: AppBar(title: const Text('Report details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(children: [
            Expanded(
              child: Text(r.title,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            StatusChip(r.status),
          ]),
          const SizedBox(height: 8),
          Text('${r.category} • ${r.location}'),
          Text('By ${r.reporterName} on ${_date(r.createdAt)}'),
          const SizedBox(height: 16),
          if (r.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(r.imageUrl!),
            ),
          const SizedBox(height: 16),
          Text(r.description),
          const SizedBox(height: 24),
          Text('Progress', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (var i = 0; i < kStatuses.length; i++)
            ListTile(
              dense: true,
              leading: Icon(
                i <= reached ? Icons.check_circle : Icons.radio_button_unchecked,
                color: i <= reached ? statusColor(kStatuses[i]) : Colors.grey,
              ),
              title: Text(kStatuses[i]),
            ),
          const SizedBox(height: 16),
          Text('Updates', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final h in r.statusHistory.reversed)
            ListTile(
              dense: true,
              title: Text(h['status'] ?? ''),
              subtitle: Text([
                if ((h['note'] ?? '').toString().isNotEmpty) h['note'],
                if (h['by'] != null) 'by ${h['by']}',
              ].join('\n')),
            ),
          if (staffControls) ...[
            const SizedBox(height: 16),
            StatusUpdateForm(r),
          ],
        ],
      ),
    );
  }
}