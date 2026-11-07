import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neobrutalism_ui/neobrutalism_ui.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../services/image_upload_service.dart';
import '../../widgets/brutal_widgets.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});
  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _loc = TextEditingController();
  final _picker = ImagePicker();
  final _uploader = ImageUploadService();

  String? _category;
  XFile? _image;
  Uint8List? _preview;
  bool _uploading = false;
  String? _titleError, _catError, _locError, _descError;

  @override
  void dispose() {
    _title.dispose(); _desc.dispose(); _loc.dispose();
    super.dispose();
  }

  void _snack(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  bool _validate() {
    setState(() {
      _titleError =
          _title.text.trim().length < 5 ? 'At least 5 characters' : null;
      _catError = _category == null ? 'Choose a category' : null;
      _locError = _loc.text.trim().isEmpty ? 'Enter a location' : null;
      _descError = _desc.text.trim().length < 15
          ? 'Describe the issue (at least 15 characters)'
          : null;
    });
    return [_titleError, _catError, _locError, _descError]
        .every((e) => e == null);
  }

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
      backgroundColor: kCream,
      shape: const Border(top: BorderSide(width: 3)),
      builder: (_) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose from gallery',
                style: TextStyle(fontWeight: FontWeight.w800)),
            onTap: () { Navigator.pop(context); _pick(ImageSource.gallery); },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Take a photo',
                style: TextStyle(fontWeight: FontWeight.w800)),
            onTap: () { Navigator.pop(context); _pick(ImageSource.camera); },
          ),
        ]),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_validate()) return;
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
      setState(() {
        _category = null; _image = null; _preview = null;
        _titleError = _catError = _locError = _descError = null;
      });
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
        padding: const EdgeInsets.fromLTRB(16, 16, 20, 24),
        child: NeoCard(
          color: Colors.white,
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FieldBlock(
              label: 'Title',
              error: _titleError,
              child: NeoTextField(
                  controller: _title, placeholder: 'e.g. Broken window'),
            ),
            const SizedBox(height: 18),
            FieldBlock(
              label: 'Category',
              error: _catError,
              child: ChipSelect(
                options: kCategories,
                selected: _category,
                onSelected: (v) => setState(() => _category = v),
              ),
            ),
            const SizedBox(height: 18),
            FieldBlock(
              label: 'Location',
              error: _locError,
              child: NeoTextField(
                  controller: _loc, placeholder: 'e.g. Block B, Room 204'),
            ),
            const SizedBox(height: 18),
            FieldBlock(
              label: 'Description',
              error: _descError,
              child: NeoTextField(
                controller: _desc,
                placeholder: 'What is wrong? Since when?',
                minLines: 4,
                maxLines: 6,
              ),
            ),
            const SizedBox(height: 18),
            FieldBlock(
              label: 'Photo (optional)',
              child: _preview != null
                  ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        decoration: BoxDecoration(border: Border.all(width: 3)),
                        child: Image.memory(_preview!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 12),
                      Wrap(spacing: 10, children: [
                        BrutalChip(
                            label: 'CHANGE',
                            selected: false,
                            onTap: busy ? () {} : _showPickerSheet),
                        BrutalChip(
                            label: 'REMOVE',
                            selected: false,
                            onTap: busy
                                ? () {}
                                : () => setState(
                                    () { _image = null; _preview = null; })),
                      ]),
                    ])
                  : NeoButton(
                      width: double.infinity,
                      backgroundColor: kBlue,
                      onPressed: busy ? null : _showPickerSheet,
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined),
                            SizedBox(width: 10),
                            Text('ADD PHOTO',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1)),
                          ]),
                    ),
            ),
            const SizedBox(height: 24),
            NeoButton(
              width: double.infinity,
              isLoading: busy,
              onPressed: busy ? null : _submit,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    _uploading ? 'UPLOADING PHOTO...' : 'SUBMIT REPORT',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}