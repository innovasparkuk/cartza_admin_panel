import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'package:shopease_admin/coupon_provider.dart';
import 'create_coupon_page.dart';
import 'edit_coupon_page.dart';

class CouponListPage extends StatefulWidget {
  @override
  State<CouponListPage> createState() => _CouponListPageState();
}

class _CouponListPageState extends State<CouponListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CouponProvider>().loadCoupons();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;
    final provider = context.watch<CouponProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.coupons),
        backgroundColor:
        isDark ? theme.colorScheme.surface : const Color(0xFF4CAF50),
      ),
      backgroundColor:
      isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF6F7F9),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(t.addCoupon,
                    style: const TextStyle(color: Colors.white)),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CreateCouponPage()),
                  );

                  if (result != null) {
                    try {
                      await provider.addCoupon(result);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color(0xFF4CAF50),
                          content: Text(
                            "Coupon added successfully",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Failed to add coupon",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: provider.coupons.isEmpty
                  ? Center(child: Text(t.noCouponsFound))
                  : ListView.builder(
                itemCount: provider.coupons.length,
                itemBuilder: (_, index) {
                  final c = provider.coupons[index];

                  return Card(
                    color: theme.colorScheme.surface,
                    margin:
                    const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(c.code),
                      subtitle: Text(
                          "${c.type} • ${c.value} • Exp ${c.expiryDate.toString().substring(0, 10)}"),
                      leading: Switch(
                        value: c.isActive,
                        activeColor: const Color(0xFF4CAF50),
                        onChanged: (v) async {
                          c.isActive = v;

                          try {
                            await provider.updateCoupon(c);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: const Color(0xFF4CAF50),
                                content: Text(
                                  v ? "Coupon activated" : "Coupon deactivated",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  "Failed to update status",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }
                        },
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditCouponPage(
                                          coupon: c),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Delete Coupon"),
                                  content: const Text(
                                    "Are you sure you want to delete this coupon?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);

                                        try {
                                          await provider.deleteCoupon(c.id!);

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Color(0xFF4CAF50),
                                              content: Text(
                                                "Coupon deleted successfully",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                "Failed to delete coupon",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
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
}
