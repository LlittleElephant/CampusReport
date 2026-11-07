import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neobrutalism_ui/neobrutalism_ui.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/report.dart';
import '../../providers/report_provider.dart';
import '../../widgets/brutal_widgets.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/status_update_form.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Report report;
  final bool staffControls;
  const ReportDetailsScreen(
      {super.key, required this.report, this.staffControls = false});

  String _date(DateTime d) => '${d.day}/${d.month}/${d.year}';

  Widget _meta(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
        ]),
      );

  Widget _step(String s, bool done) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: done ? statusColor(s) : Colors.white,
              border: Border.all(width: 3),
            ),
            child: done ? const Icon(Icons.check, size: 18) : null,
          ),
          const SizedBox(width: 12),
          Text(s.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: done ? Colors.black : Colors.black45)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final r = context.watch<ReportProvider>().reports.firstWhere(
        (x) => x.id == report.id,
        orElse: () => report);
    final reached = kStatuses.indexOf(r.status);

    return Scaffold(
      appBar: AppBar(title: const Text('Report')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 20, 24),
        children: [
          NeoCard(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w900, height: 1.15)),
              const SizedBox(height: 10),
              StatusChip(r.status),
              const SizedBox(height: 8),
              _meta(Icons.category_outlined, r.category),
              _meta(Icons.place_outlined, r.location),
              _meta(Icons.person_outline, 'By ${r.reporterName}'),
              _meta(Icons.calendar_today_outlined, _date(r.createdAt)),
            ]),
          ),
          if (r.imageUrl != null) ...[
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(4, 4))
                ],
              ),
              child: Image.network(
                r.imageUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : const SizedBox(
                        height: 180,
                        child: Center(child: CircularProgressIndicator())),
                errorBuilder: (_, _, _) => const SizedBox(
                    height: 120,
                    child: Center(child: Text('Photo could not be loaded'))),
              ),
            ),
          ],
          const SectionTitle('Description'),
          NeoCard(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Text(r.description,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, height: 1.4)),
          ),
          const SectionTitle('Progress'),
          NeoCard(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              for (var i = 0; i < kStatuses.length; i++)
                _step(kStatuses[i], i <= reached),
            ]),
          ),
          const SectionTitle('Updates'),
          for (final h in r.statusHistory.reversed)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: NeoCard(
                color: Colors.white,
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    StatusChip(h['status'] ?? ''),
                    const SizedBox(width: 10),
                    Text(
                        h['at'] is Timestamp
                            ? _date((h['at'] as Timestamp).toDate())
                            : '',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ]),
                  if ((h['note'] ?? '').toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('${h['note']}',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  if (h['by'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text('by ${h['by']}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                ]),
              ),
            ),
          if (staffControls) ...[
            const SectionTitle('Staff actions'),
            StatusUpdateForm(r),
          ],
        ],
      ),
    );
  }
}