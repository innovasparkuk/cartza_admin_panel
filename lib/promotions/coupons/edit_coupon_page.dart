import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'coupon_model.dart';
import 'package:shopease_admin/coupon_provider.dart';

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
    final provider = context.read<CouponProvider>();

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
              decoration: InputDecoration(labelText: t.discountType),
              items: const [
                DropdownMenuItem(
                    value: "Percentage", child: Text("Percentage")),
                DropdownMenuItem(value: "Flat", child: Text("Flat")),
              ],
              onChanged: (v) => _type = v!,
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
              onPressed: () async {
                widget.coupon
                  ..code = _code
                  ..type = _type
                  ..value = _value;

                await provider.updateCoupon(widget.coupon);
                Navigator.pop(context);
              },
              child:
              Text(t.update, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
