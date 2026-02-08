import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'create_flash_sale_page.dart';
import 'flash_sale_model.dart';
import 'package:shopease_admin/flash_sale_provider.dart';

class FlashSalesPage extends StatefulWidget {
  @override
  State<FlashSalesPage> createState() => _FlashSalesPageState();
}

class _FlashSalesPageState extends State<FlashSalesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => context.read<FlashSaleProvider>().loadFlashSales(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;
    final provider = context.watch<FlashSaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.flashSales),
        backgroundColor:
        isDark ? theme.colorScheme.surface : const Color(0xFF4CAF50),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateFlashSalePage(),
                  ),
                );

                if (result is FlashSale) {
                  await provider.addFlashSale(result);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text(t.flashSaleCreatedSuccessfully),
                      backgroundColor:
                      const Color(0xFF4CAF50),
                    ),
                  );
                }
              },
              child: Text(
                t.createFlashSale,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: provider.flashSales.isEmpty
                  ? Center(child: Text(t.noActiveFlashSales))
                  : ListView.builder(
                itemCount: provider.flashSales.length,
                itemBuilder: (context, index) {
                  final sale =
                  provider.flashSales[index];

                  return Card(
                    margin:
                    const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(sale.title),
                      subtitle: Text(
                        "${sale.discount}% • ${sale.startTime} to ${sale.endTime}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: sale.active,
                            activeColor:
                            const Color(0xFF4CAF50),
                            onChanged: (v) async {
                              sale.active = v;
                              await provider
                                  .updateFlashSale(sale);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    v
                                        ? "Flash sale activated"
                                        : "Flash sale deactivated",
                                  ),
                                  backgroundColor:
                                  const Color(0xFF4CAF50),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () =>
                                _confirmDelete(
                                    context, sale),
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

  Future<void> _confirmDelete(
      BuildContext context, FlashSale sale) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Flash Sale"),
        content: const Text(
            "Are you sure you want to delete this flash sale"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (ok == true) {
      await context
          .read<FlashSaleProvider>()
          .deleteFlashSale(sale.id!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Flash sale deleted successfully"),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    }
  }
}
