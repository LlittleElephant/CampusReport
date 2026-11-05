import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../services/image_upload_service.dart';

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
  final _picker = ImagePicker();
  final _uploader = ImageUploadService();

  String? _category;
  XFile? _image;
  Uint8List? _preview;
  bool _uploading = false;

  @override
  void dispose() {
    _title.dispose(); _desc.dispose(); _loc.dispose();
    super.dispose();
  }

  void _snack(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _pick(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
          source: source, maxWidth: 1600, imageQuality: 80);
      if (file == null) return;
      final bytes = await file.readAsBytes();
      setState(() { _image = file; _preview = bytes; });
    } catch (_) {
      _snack('Could not open the photo picker.');
    }
  }

  void _showPickerSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose from gallery'),
            onTap: () { Navigator.pop(context); _pick(ImageSource.gallery); },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Take a photo'),
            onTap: () { Navigator.pop(context); _pick(ImageSource.camera); },
          ),
        ]),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final user = context.read<AuthProvider>().user!;
    final rp = context.read<ReportProvider>();

    String? imageUrl;
    if (_image != null) {
      setState(() => _uploading = true);
      try {
        imageUrl = await _uploader.upload(_image!);
      } catch (e) {
        if (!mounted) return;
        setState(() => _uploading = false);
        _snack(e.toString().replaceFirst('Exception: ', ''));
        return;
      }
      if (!mounted) return;
      setState(() => _uploading = false);
    }

    final ok = await rp.submit(
      title: _title.text.trim(),
      description: _desc.text.trim(),
      category: _category!,
      location: _loc.text.trim(),
      reporterId: user.uid,
      reporterName: user.name,
      imageUrl: imageUrl,
    );
    if (!mounted) return;

    if (ok) {
      _title.clear(); _desc.clear(); _loc.clear();
      setState(() { _category = null; _image = null; _preview = null; });
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _form.currentState?.reset());
      _snack('Report submitted');
    } else {
      _snack(rp.error ?? 'Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = _uploading || context.watch<ReportProvider>().submitting;
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
            const SizedBox(height: 16),
            if (_preview != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(_preview!,
                    height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
              Row(children: [
                TextButton.icon(
                  onPressed: busy ? null : _showPickerSheet,
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('Change'),
                ),
                TextButton.icon(
                  onPressed: busy
                      ? null
                      : () => setState(() { _image = null; _preview = null; }),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Remove'),
                ),
              ]),
            ] else
              OutlinedButton.icon(
                onPressed: busy ? null : _showPickerSheet,
                icon: const Icon(Icons.add_a_photo_outlined),
                label: const Text('Add photo (optional)'),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: busy ? null : _submit,
                child: busy
                    ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const SizedBox(height: 18, width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2)),
                        const SizedBox(width: 12),
                        Text(_uploading ? 'Uploading photo...' : 'Submitting...'),
                      ])
                    : const Text('Submit report'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}