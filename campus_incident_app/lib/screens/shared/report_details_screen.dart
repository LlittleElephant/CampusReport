import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/report.dart';
import '../../widgets/status_chip.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Report report;
  const ReportDetailsScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final r = report;
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
          Text('By ${r.reporterName} on '
              '${r.createdAt.day}/${r.createdAt.month}/${r.createdAt.year}'),
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
        ],
      ),
    );
  }
}