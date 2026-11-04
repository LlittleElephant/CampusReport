import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../widgets/status_chip.dart';
import '../shared/report_details_screen.dart';

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
              ? const Center(child: Text('You have not submitted any reports yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final r = list[i];
                    return Card(
                      child: ListTile(
                        title: Text(r.title),
                        subtitle: Text('${r.category} • ${r.location}'),
                        trailing: StatusChip(r.status),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ReportDetailsScreen(report: r)),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}