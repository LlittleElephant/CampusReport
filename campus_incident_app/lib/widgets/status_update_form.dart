import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/report.dart';
import '../providers/auth_provider.dart';
import '../providers/report_provider.dart';

class StatusUpdateForm extends StatefulWidget {
  final Report report;
  const StatusUpdateForm(this.report, {super.key});
  @override
  State<StatusUpdateForm> createState() => _StatusUpdateFormState();
}

class _StatusUpdateFormState extends State<StatusUpdateForm> {
  late String _status = widget.report.status;
  final _note = TextEditingController();

  @override
  void dispose() { _note.dispose(); super.dispose(); }

  Future<void> _save() async {
    final staff = context.read<AuthProvider>().user!;
    final rp = context.read<ReportProvider>();
    final ok = await rp.updateStatus(
      id: widget.report.id,
      status: _status,
      note: _note.text.trim(),
      staffName: staff.name,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? 'Status updated' : rp.error ?? 'Failed')));
    if (ok) {
      _note.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.watch<ReportProvider>().submitting;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Update status',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: const InputDecoration(labelText: 'New status'),
            items: kStatuses
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => setState(() => _status = v!),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _note,
            maxLines: 3,
            decoration: const InputDecoration(
                labelText: 'Note for the student (optional)',
                alignLabelWithHint: true),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: busy ? null : _save,
              child: const Text('Save update'),
            ),
          ),
        ]),
      ),
    );
  }
}