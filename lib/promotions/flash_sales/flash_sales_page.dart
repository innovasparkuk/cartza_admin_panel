import 'package:flutter/material.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'create_flash_sale_page.dart';
import 'flash_sale_model.dart';

class FlashSalesPage extends StatefulWidget {
  @override
  State<FlashSalesPage> createState() => _FlashSalesPageState();
}

class _FlashSalesPageState extends State<FlashSalesPage> {
  final List<FlashSale> flashSales = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.flashSales),
        backgroundColor:
        isDark ? theme.colorScheme.surface : const Color(0xFF4CAF50),
      ),
      backgroundColor:
      isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF5F5F5),
      body: Padding(
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
                  setState(() => flashSales.add(result));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text(t.flashSaleCreatedSuccessfully),
                      backgroundColor: const Color(0xFF4CAF50),
                    ),
                  );
                }
              },
              child: Text(t.createFlashSale,style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: flashSales.isEmpty
                  ? Center(
                child: Text(
                  t.noActiveFlashSales,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface
                        .withOpacity(0.6),
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: flashSales.length,
                itemBuilder: (context, index) {
                  final sale = flashSales[index];
                  return Card(
                    color: theme.colorScheme.surface,
                    margin:
                    const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        sale.title,
                        style: TextStyle(
                          color:
                          theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        "${sale.discount}% • ${sale.startTime} - ${sale.endTime}",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                      trailing: Switch(
                        value: sale.active,
                        activeColor:
                        const Color(0xFF4CAF50),
                        onChanged: (v) {
                          setState(() => sale.active = v);
                        },
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