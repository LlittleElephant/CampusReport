import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../widgets/report_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNewReport;
  const HomeScreen({super.key, required this.onNewReport});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    final rp = context.watch<ReportProvider>();
    final mine = rp.mine(user.uid);
    final resolved = mine.where((r) => r.status == 'Resolved').length;
    final recent = rp.reports.take(5).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: rp.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(padding: const EdgeInsets.all(16), children: [
              Text('Hello, ${user.name.split(' ').first}',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Row(children: [
                _Stat('My reports', mine.length),
                _Stat('Open', mine.length - resolved),
                _Stat('Resolved', resolved),
              ]),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onNewReport,
                icon: const Icon(Icons.add),
                label: const Text('Report an issue'),
              ),
              const SizedBox(height: 24),
              Text('Recent on campus',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (recent.isEmpty)
                const Text('No reports yet.')
              else
                ...recent.map(ReportCard.new),
            ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  const _Stat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(children: [
            Text('$value',
                style: Theme.of(context).textTheme.headlineMedium),
            Text(label),
          ]),
        ),
      ),
    );
  }
}