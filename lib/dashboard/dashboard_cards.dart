import 'package:flutter/material.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';

class DashboardCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;

    return Row(
      children: [
        _buildCard(
          context: context,
          icon: Icons.people,
          title: t.totalUsers,
          value: "1,234",
          color: theme.colorScheme.primary,
          onTap: () {
            debugPrint("Users card clicked");
          },
        ),

        const SizedBox(width: 16),

        _buildCard(
          context: context,
          icon: Icons.shopping_cart,
          title: t.totalOrders,
          value: "567",
          color: Colors.orange,
          onTap: () {
            debugPrint("Orders card clicked");
          },
        ),

        const SizedBox(width: 16),

        _buildCard(
          context: context,
          icon: Icons.currency_rupee,
          title: t.totalRevenue,
          value: "₹89,000",
          color: Colors.green,
          onTap: () {
            debugPrint("Revenue card clicked");
          },
        ),

        const SizedBox(width: 16),

        _buildCard(
          context: context,
          icon: Icons.inventory,
          title: t.activeProducts,
          value: "1,089",
          color: Colors.purple,
          onTap: () {
            debugPrint("Products card clicked");
          },
        ),
      ],
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : Colors.black12,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
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
                child: Icon(icon, size: 22, color: color),
              ),

              const SizedBox(height: 20),

              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}