import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
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

    int count(String s) => rp.reports.where((r) => r.status == s).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Staff • ${user.name}'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().signOut(),
          ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search title, location, reporter',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _query = v.trim()),
          ),
        ),
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text('All (${rp.reports.length})'),
                  selected: _status == null,
                  onSelected: (_) => setState(() => _status = null),
                ),
              ),
              for (final s in kStatuses)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('$s (${count(s)})'),
                    selected: _status == s,
                    onSelected: (_) =>
                        setState(() => _status = _status == s ? null : s),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<String?>(
            isExpanded: true,
            value: _category,
            hint: const Text('Category'),
            items: [
              const DropdownMenuItem<String?>(
                  value: null, child: Text('All categories')),
              ...kCategories.map((c) =>
                  DropdownMenuItem<String?>(value: c, child: Text(c))),
            ],
            onChanged: (v) => setState(() => _category = v),
          ),
        ),
        Expanded(
          child: rp.loading
              ? const Center(child: CircularProgressIndicator())
              : list.isEmpty
                  ? const Center(child: Text('No reports match.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: list.length,
                      itemBuilder: (_, i) =>
                          ReportCard(list[i], staff: true),
                    ),
        ),
      ]),
    );
  }
}