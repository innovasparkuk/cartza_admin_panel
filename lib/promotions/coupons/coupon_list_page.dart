import 'package:flutter/material.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'coupon_model.dart';
import 'create_coupon_page.dart';
import 'edit_coupon_page.dart';

class CouponListPage extends StatefulWidget {
  @override
  State<CouponListPage> createState() => _CouponListPageState();
}

class _CouponListPageState extends State<CouponListPage> {
  final List<Coupon> coupons = [
    Coupon(
      code: "SAVE10",
      type: "Percentage",
      value: 10,
      expiryDate: DateTime(2025, 12, 31),
    ),
    Coupon(
      code: "FLAT500",
      type: "Flat",
      value: 500,
      expiryDate: DateTime(2025, 10, 10),
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.coupons),
        backgroundColor:
        isDark ? theme.colorScheme.surface : const Color(0xFF4CAF50),
      ),
      backgroundColor:
      isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF6F7F9),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
                icon: const Icon(Icons.add,color: Colors.white,),
                label: Text(t.addCoupon,style: TextStyle(color: Colors.white),),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CreateCouponPage()),
                  );

                  if (result is Coupon) {
                    setState(() => coupons.add(result));
                    _success(t.couponAdded);
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: coupons.isEmpty
                  ? Center(
                child: Text(
                  t.noCouponsFound,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  final c = coupons[index];

                  return Card(
                    color: theme.colorScheme.surface,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        c.code,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        "${c.type} • ${c.value} • Exp ${c.expiryDate.toString().substring(0, 10)}",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                      leading: Switch(
                        value: c.isActive,
                        activeColor: const Color(0xFF4CAF50),
                        onChanged: (v) {
                          setState(() => c.isActive = v);
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color:
                              theme.colorScheme.onSurface,
                            ),
                            onPressed: () async {
                              final updated =
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditCouponPage(coupon: c),
                                ),
                              );

                              if (updated != null) {
                                setState(() {});
                                _success(t.couponUpdated);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _deleteConfirm(index, t);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteConfirm(int index, AppLocalizations t) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(t.deleteCoupon),
        content:
        Text(t.deleteCouponConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() => coupons.removeAt(index));
              Navigator.pop(context);
              _success(t.couponDeleted);
            },
            child: Text(
              t.delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _success(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }
}