import 'package:flutter/material.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';

class StatusBadge extends StatelessWidget {
  final bool active;

  const StatusBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;

    final bgColor = active
        ? const Color(0xFF4CAF50).withOpacity(0.15)
        : Colors.red.withOpacity(0.15);

    final textColor =
    active ? const Color(0xFF4CAF50) : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        active ? t.active : t.inactive,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}