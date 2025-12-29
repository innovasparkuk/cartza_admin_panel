import 'package:flutter/material.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';

class CreateBannerPage extends StatefulWidget {
  @override
  State<CreateBannerPage> createState() => _CreateBannerPageState();
}

class _CreateBannerPageState extends State<CreateBannerPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
        title: Text(t.createBanner,style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: t.bannerTitle),
                validator: (val) =>
                val == null || val.isEmpty ? t.required : null,
                onSaved: (val) => _title = val ?? "",
              ),
              SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.upload),
                label: Text(t.uploadImage),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
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