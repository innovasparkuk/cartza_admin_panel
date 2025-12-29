import 'package:flutter/material.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'coupon_model.dart';

class EditCouponPage extends StatefulWidget {
  final Coupon coupon;

  const EditCouponPage({required this.coupon});

  @override
  State<EditCouponPage> createState() => _EditCouponPageState();
}

class _EditCouponPageState extends State<EditCouponPage> {
  late String _code;
  late String _type;
  late int _value;

  @override
  void initState() {
    super.initState();
    _code = widget.coupon.code;
    _type = widget.coupon.type;
    _value = widget.coupon.value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
        isDark ? theme.colorScheme.surface : const Color(0xFF4CAF50),
        title: Text(t.editCoupon),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextFormField(
              initialValue: _code,
              decoration: InputDecoration(labelText: t.couponCode),
              onChanged: (v) => _code = v,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _type,
              items: [
                DropdownMenuItem(
                    value: "Percentage", child: Text(t.percentage)),
                DropdownMenuItem(value: "Flat", child: Text(t.flat)),
              ],
              onChanged: (v) => _type = v!,
              decoration:
              InputDecoration(labelText: t.discountType),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _value.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: t.value),
              onChanged: (v) =>
              _value = int.tryParse(v) ?? 0,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
              ),
              onPressed: () {
                widget.coupon
                  ..code = _code
                  ..type = _type
                  ..value = _value;
                Navigator.pop(context, widget.coupon);
              },
              child: Text(t.update,style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}