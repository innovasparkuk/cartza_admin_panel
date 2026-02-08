import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'package:shopease_admin/BannerProvider.dart';
import 'package:shopease_admin/services/api_service.dart';

class CreateBannerPage extends StatefulWidget {
  @override
  State<CreateBannerPage> createState() => _CreateBannerPageState();
}

class _CreateBannerPageState extends State<CreateBannerPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _imageUrl = "";
  bool _active = true;
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadImage() async {
    final t = AppLocalizations.of(context)!;
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _isUploading = true);

    try {
      final bytes = await image.readAsBytes();
      final url = await ApiService.uploadImageBytes(bytes);
      setState(() => _imageUrl = url);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${t.uploadImage} uploaded")),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${t.uploadImage} failed")),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final provider = context.read<BannerProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.createBanner),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: t.bannerTitle,
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? t.required : null,
                onSaved: (val) => _title = val ?? "",
              ),
              const SizedBox(height: 20),

              OutlinedButton.icon(
                onPressed: _isUploading ? null : _pickAndUploadImage,
                icon: const Icon(Icons.upload),
                label: Text(
                  _isUploading ? "${t.uploadImage}..." : t.uploadImage,
                ),
              ),

              if (_imageUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _imageUrl,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              SwitchListTile(
                title: const Text("Active"),
                value: _active,
                onChanged: (val) => setState(() => _active = val),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please upload image")),
                      );
                      return;
                    }
                    _formKey.currentState!.save();
                    provider.addBanner(_title, _imageUrl, _active, context);
                    Navigator.pop(context);
                  }
                },
                child: Text(t.saveBanner),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
