import 'package:flutter/material.dart';
import 'package:neobrutalism_ui/neobrutalism_ui.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/report_provider.dart';
import '../../widgets/brutal_widgets.dart';
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
      final text = q.isEmpty ||
          r.title.toLowerCase().contains(q) ||
          r.description.toLowerCase().contains(q) ||
          r.location.toLowerCase().contains(q);
      return text &&
          (_category == null || r.category == _category) &&
          (_status == null || r.status == _status);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: NeoTextField(
            placeholder: 'Search title, description, location',
            prefix: const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => _query = v.trim()),
          ),
        ),
        FilterRow(
          label: 'Category',
          options: kCategories,
          selected: _category,
          onSelected: (v) => setState(() => _category = v),
        ),
        FilterRow(
          label: 'Status',
          options: kStatuses,
          selected: _status,
          colorFor: statusColor,
          onSelected: (v) => setState(() => _status = v),
        ),
        Expanded(
          child: rp.loading
              ? const Center(child: CircularProgressIndicator())
              : results.isEmpty
                  ? const EmptyState(
                      icon: Icons.search_off,
                      title: 'Nothing found',
                      message: 'Try a different word or clear a filter.')
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      itemCount: results.length,
                      itemBuilder: (_, i) => ReportCard(results[i]),
                    ),
        ),
      ]),
    );
  }
}