import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'package:shopease_admin/dashboard_provider.dart';

class DashboardCards extends StatelessWidget {
  const DashboardCards({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    final dashboard = context.watch<DashboardProvider>();

    return Row(
      children: [
        _buildCard(
          context,
          Icons.people,
          t.totalUsers,
          dashboard.totalUsers.toString(),
          theme.colorScheme.primary,
        ),

        const SizedBox(width: 16),

        _buildCard(
          context,
          Icons.shopping_cart,
          t.totalOrders,
          dashboard.totalOrders.toString(),
          Colors.orange,
        ),

        const SizedBox(width: 16),

        _buildCard(
          context,
          Icons.currency_rupee,
          t.totalRevenue,
          '₹${_formatRevenue(dashboard.totalRevenue)}',
          Colors.green,
        ),

        const SizedBox(width: 16),

        _buildCard(
          context,
          Icons.inventory,
          t.activeProducts,
          dashboard.activeProducts.toString(),
          Colors.purple,
        ),
      ],
    );
  }

  // ✅ Helper method to format revenue nicely
  String _formatRevenue(double revenue) {
    if (revenue >= 10000000) {
      return '${(revenue / 10000000).toStringAsFixed(2)}Cr';
    } else if (revenue >= 100000) {
      return '${(revenue / 100000).toStringAsFixed(2)}L';
    } else if (revenue >= 1000) {
      return '${(revenue / 1000).toStringAsFixed(2)}K';
    }
    return revenue.toStringAsFixed(2);
  }

  Widget _buildCard(
      BuildContext context,
      IconData icon,
      String title,
      String value,
      Color color,
      ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),

            const SizedBox(height: 20),

            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}