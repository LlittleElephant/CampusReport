import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});
  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _loc = TextEditingController();
  String? _category;

  @override
  void dispose() {
    _title.dispose(); _desc.dispose(); _loc.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final user = context.read<AuthProvider>().user!;
    final ok = await context.read<ReportProvider>().submit(
          title: _title.text.trim(),
          description: _desc.text.trim(),
          category: _category!,
          location: _loc.text.trim(),
          reporterId: user.uid,
          reporterName: user.name,
        );
    if (!mounted) return;
    if (ok) {
      _title.clear(); _desc.clear(); _loc.clear();
      setState(() => _category = null);
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _form.currentState?.reset());
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.read<ReportProvider>().error ?? 'Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitting = context.watch<ReportProvider>().submitting;
    return Scaffold(
      appBar: AppBar(title: const Text('New report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) => (v == null || v.trim().length < 5)
                  ? 'At least 5 characters' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: kCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v),
              validator: (v) => v == null ? 'Choose a category' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _loc,
              decoration: const InputDecoration(
                  labelText: 'Location (e.g. Block B, Room 204)'),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Enter a location' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _desc,
              maxLines: 5,
              decoration: const InputDecoration(
                  labelText: 'Description', alignLabelWithHint: true),
              validator: (v) => (v == null || v.trim().length < 15)
                  ? 'Describe the issue (at least 15 characters)' : null,
            ),
            const SizedBox(height: 12),
            // TODO(photo): replace with image picker once Firebase Storage is enabled
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text('Add photo (coming soon)'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: submitting ? null : _submit,
                child: submitting
                    ? const SizedBox(height: 18, width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Submit report'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}