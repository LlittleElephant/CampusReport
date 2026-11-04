import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/report_provider.dart';
import '../../widgets/report_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  String? _category;
  String? _status;

  @override
  Widget build(BuildContext context) {
    final rp = context.watch<ReportProvider>();
    final q = _query.toLowerCase();
    final results = rp.reports.where((r) {
      final matchesText = q.isEmpty ||
          r.title.toLowerCase().contains(q) ||
          r.description.toLowerCase().contains(q) ||
          r.location.toLowerCase().contains(q);
      return matchesText &&
          (_category == null || r.category == _category) &&
          (_status == null || r.status == _status);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Search reports')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search title, description, location',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _query = v.trim()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Expanded(
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
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButton<String?>(
                isExpanded: true,
                value: _status,
                hint: const Text('Status'),
                items: [
                  const DropdownMenuItem<String?>(
                      value: null, child: Text('All statuses')),
                  ...kStatuses.map((s) =>
                      DropdownMenuItem<String?>(value: s, child: Text(s))),
                ],
                onChanged: (v) => setState(() => _status = v),
              ),
            ),
          ]),
        ),
        Expanded(
          child: rp.loading
              ? const Center(child: CircularProgressIndicator())
              : results.isEmpty
                  ? const Center(child: Text('No reports match your search.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: results.length,
                      itemBuilder: (_, i) => ReportCard(results[i]),
                    ),
        ),
      ]),
    );
  }
}