import 'package:flutter/material.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';

class QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;

    return Row(
      children: [
        _action(context, Icons.add_box, t.addProduct),
        const SizedBox(width: 16),
        _action(context, Icons.local_offer, t.createCoupon),
        const SizedBox(width: 16),
        _action(context, Icons.list_alt, t.viewOrders),
        const SizedBox(width: 16),
        _action(context, Icons.notifications, t.sendAlert),
      ],
    );
  }

  Widget _action(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: theme.brightness == Brightness.dark
                  ? Colors.black26
                  : Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}