import 'package:flutter/material.dart';
import 'package:neobrutalism_ui/neobrutalism_ui.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../widgets/brutal_widgets.dart';
import '../../widgets/report_card.dart';

class StaffShell extends StatefulWidget {
  const StaffShell({super.key});
  @override
  State<StaffShell> createState() => _StaffShellState();
}

class _StaffShellState extends State<StaffShell> {
  String? _status;
  String? _category;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    final rp = context.watch<ReportProvider>();
    final q = _query.toLowerCase();

    final list = rp.reports.where((r) {
      final text = q.isEmpty ||
          r.title.toLowerCase().contains(q) ||
          r.location.toLowerCase().contains(q) ||
          r.reporterName.toLowerCase().contains(q);
      return text &&
          (_status == null || r.status == _status) &&
          (_category == null || r.category == _category);
    }).toList();

    final total = rp.reports.length;
    final resolved = rp.reports.where((r) => r.status == 'Resolved').length;
    final pending = total - resolved;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().signOut(),
          ),
        ],
      ),
      body: rp.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(padding: const EdgeInsets.only(bottom: 16), children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text('Hi, ${user.name.split(' ').first}',
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w900)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 20, 0),
                child: Row(children: [
                  _Stat('Total', total, kBlue),
                  const SizedBox(width: 12),
                  _Stat('Pending', pending, kPink),
                  const SizedBox(width: 12),
                  _Stat('Resolved', resolved, kGreen),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 20, 4),
                child: NeoTextField(
                  placeholder: 'Search title, location, reporter',
                  prefix: const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(Icons.search),
                  ),
                  onChanged: (v) => setState(() => _query = v.trim()),
                ),
              ),
              FilterRow(
                label: 'Status',
                options: kStatuses,
                selected: _status,
                colorFor: statusColor,
                onSelected: (v) => setState(() => _status = v),
              ),
              FilterRow(
                label: 'Category',
                options: kCategories,
                selected: _category,
                onSelected: (v) => setState(() => _category = v),
              ),
              const SizedBox(height: 8),
              if (list.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: EmptyState(
                      icon: Icons.inbox_outlined,
                      title: 'No reports match',
                      message: 'Try clearing a filter.'),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(children: [
                    for (final r in list) ReportCard(r, staff: true),
                  ]),
                ),
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
        child: Center(
          child: Column(children: [
            Text('$value',
                style: const TextStyle(
                    fontSize: 26, fontWeight: FontWeight.w900)),
            Text(label.toUpperCase(),
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1)),
          ]),
        ),
      ),
    );
  }
}