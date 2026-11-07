import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../widgets/brutal_widgets.dart';
import '../../widgets/report_card.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.watch<AuthProvider>().user!.uid;
    final rp = context.watch<ReportProvider>();
    final list = rp.mine(uid);

    return Scaffold(
      appBar: AppBar(title: const Text('My reports')),
      body: rp.loading
          ? const Center(child: CircularProgressIndicator())
          : list.isEmpty
              ? const EmptyState(
                  icon: Icons.inbox_outlined,
                  title: 'No reports yet',
                  message: 'Reports you submit will show up here.')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (_, i) => ReportCard(list[i]),
                ),
    );
  }
}