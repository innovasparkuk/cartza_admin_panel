import 'package:flutter/material.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'coupon_model.dart';

class CreateCouponPage extends StatefulWidget {
  @override
  State<CreateCouponPage> createState() => _CreateCouponPageState();
}

class _CreateCouponPageState extends State<CreateCouponPage> {
  final _formKey = GlobalKey<FormState>();

  String _code = "";
  String _type = "Percentage";
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
        isDark ? theme.colorScheme.surface : const Color(0xFF4CAF50),
        title: Text(t.createCoupon),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: t.couponCode),
                validator: (v) =>
                v == null || v.isEmpty ? t.required : null,
                onSaved: (v) => _code = v!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _type,
                decoration:
                InputDecoration(labelText: t.discountType),
                items: [
                  DropdownMenuItem(
                      value: "Percentage", child: Text(t.percentage)),
                  DropdownMenuItem(value: "Flat", child: Text(t.flat)),
                ],
                onChanged: (v) => setState(() => _type = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration:
                InputDecoration(labelText: t.discountValue),
                keyboardType: TextInputType.number,
                onSaved: (v) =>
                _value = int.tryParse(v ?? "0") ?? 0,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final coupon = Coupon(
                      code: _code,
                      type: _type,
                      value: _value,
                      expiryDate:
                      DateTime.now().add(const Duration(days: 30)),
                    );
                    Navigator.pop(context, coupon);
                  }
                },
                child: Text(t.saveCoupon,style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}