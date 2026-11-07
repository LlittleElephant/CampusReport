import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neobrutalism_ui/neobrutalism_ui.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/report.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../widgets/brutal_widgets.dart';
import '../../widgets/report_card.dart';
import '../../widgets/status_chip.dart';

const _tips = [
  'Reports with a clear location and a photo get looked at faster. Add as much detail as you can.',
  'Spotted a safety concern? Report it right away so staff can respond quickly.',
  'Check Search before reporting. Someone may have already flagged the same issue.',
  'Every report you submit helps make campus better for everyone.',
];

class _Update {
  final Report report;
  final Map<String, dynamic> entry;
  final DateTime at;
  _Update(this.report, this.entry, this.at);
}

class HomeScreen extends StatelessWidget {
  final VoidCallback onNewReport, onSeeAll;
  const HomeScreen(
      {super.key, required this.onNewReport, required this.onSeeAll});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    final rp = context.watch<ReportProvider>();
    final mine = rp.mine(user.uid);
    final open = mine.where((r) => r.status != 'Resolved').length;
    final resolved = mine.length - open;
    final others =
        rp.reports.where((r) => r.reporterId != user.uid).take(4).toList();

    final updates = <_Update>[];
    for (final r in mine) {
      for (final h in r.statusHistory.skip(1)) {
        final ts = h['at'];
        if (ts is Timestamp) updates.add(_Update(r, h, ts.toDate()));
      }
    }
    updates.sort((a, b) => b.at.compareTo(a.at));
    final latest = updates.take(3).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: rp.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(padding: const EdgeInsets.all(16), children: [
              Text('${_greeting()},\n${user.name.split(' ').first}!',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w900, height: 1.1)),
              const SizedBox(height: 20),
              NeoCard(
                color: kYellow,
                padding: const EdgeInsets.all(22),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SEE SOMETHING BROKEN?',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              height: 1.1)),
                      const SizedBox(height: 10),
                      Text(_tips[DateTime.now().day % _tips.length],
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 20),
                      NeoButton(
                        width: double.infinity,
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        onPressed: onNewReport,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('REPORT AN ISSUE  →',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                  color: Colors.white)),
                        ),
                      ),
                    ]),
              ),
              const SizedBox(height: 20),
              Row(children: [
                _Stat('Reports', mine.length, kBlue),
                const SizedBox(width: 12),
                _Stat('Open', open, kPink),
                const SizedBox(width: 12),
                _Stat('Resolved', resolved, kGreen),
              ]),
              if (latest.isNotEmpty) ...[
                const SectionTitle('Updates on your reports'),
                for (final u in latest)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14, right: 4),
                    child: GestureDetector(
                      onTap: () => openReport(context, u.report),
                      child: NeoCard(
                        color: Colors.white,
                        padding: const EdgeInsets.all(14),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(u.report.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15)),
                              const SizedBox(height: 6),
                              Row(children: [
                                const Text('Now: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                                StatusChip(u.entry['status'] ?? ''),
                              ]),
                              if ((u.entry['note'] ?? '').toString().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text('"${u.entry['note']}"',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                            ]),
                      ),
                    ),
                  ),
              ],
              const SectionTitle('Recent on campus'),
              if (others.isEmpty)
                const Text('No reports from other students yet.',
                    style: TextStyle(fontWeight: FontWeight.w600))
              else
                ...others.map((r) => ReportCard(r)),
              const SizedBox(height: 4),
              NeoButton(
                width: double.infinity,
                backgroundColor: Colors.white,
                onPressed: onSeeAll,
                child: const Text('VIEW ALL REPORTS',
                    style: TextStyle(
                        fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
              const SizedBox(height: 16),
            ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _Stat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NeoCard(
        color: color,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(children: [
          Text('$value',
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          Text(label.toUpperCase(),
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
        ]),
      ),
    );
  }
}