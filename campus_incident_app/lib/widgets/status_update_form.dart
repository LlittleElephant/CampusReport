import 'package:flutter/material.dart';
import 'package:neobrutalism_ui/neobrutalism_ui.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/report.dart';
import '../providers/auth_provider.dart';
import '../providers/report_provider.dart';
import 'brutal_widgets.dart';

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
    return NeoCard(
      color: kYellow,
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FieldBlock(
          label: 'New status',
          child: ChipSelect(
            options: kStatuses,
            selected: _status,
            colorFor: (_) => Colors.white,
            onSelected: (v) => setState(() => _status = v),
          ),
        ),
        const SizedBox(height: 16),
        FieldBlock(
          label: 'Note for the student (optional)',
          child: NeoTextField(
            controller: _note,
            placeholder: 'e.g. Technician assigned',
            minLines: 3,
            maxLines: 5,
          ),
        ),
        const SizedBox(height: 18),
        NeoButton(
          width: double.infinity,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          isLoading: busy,
          onPressed: busy ? null : _save,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('SAVE UPDATE',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    color: Colors.white)),
          ),
        ),
      ]),
    );
  }
}