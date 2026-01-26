import 'package:flutter/material.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';

class TopProducts extends StatelessWidget {
  final products = const [
    {"name": "iPhone 14", "sales": "120"},
    {"name": "Running Shoes", "sales": "95"},
    {"name": "Smart Watch", "sales": "80"},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black26
                : Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.topSellingProducts,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          ...products.map(
                (p) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                    theme.colorScheme.primary.withOpacity(0.15),
                    child: Icon(
                      Icons.shopping_bag,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      p["name"]! == "iPhone 14" ? t.iphone14 :
                      p["name"]! == "Running Shoes" ? t.runningShoes :
                      t.smartWatch,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),

                  Text(
                    "${p["sales"]} ${t.sales}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}