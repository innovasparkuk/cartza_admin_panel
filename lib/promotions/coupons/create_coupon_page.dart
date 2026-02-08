import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'coupon_model.dart';
import 'package:flutter/services.dart';
import 'package:shopease_admin/coupon_provider.dart';
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
    final provider = context.read<CouponProvider>();

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
                items: const [
                  DropdownMenuItem(
                      value: "Percentage", child: Text("Percentage")),
                  DropdownMenuItem(value: "Flat", child: Text("Flat")),
                ],
                onChanged: (v) => setState(() => _type = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: t.discountValue),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return t.required;
                  if (int.tryParse(v) == null) return "Only numbers allowed";
                  if (int.parse(v) <= 0) return "Value must be greater than 0";
                  return null;
                },
                onSaved: (v) => _value = int.parse(v!),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final coupon = Coupon(
                      code: _code,
                      type: _type,
                      value: _value,
                      expiryDate:
                      DateTime.now().add(const Duration(days: 30)),
                    );

                    await provider.addCoupon(coupon);
                    Navigator.pop(context);
                  }
                },
                child: Text(t.saveCoupon,
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
