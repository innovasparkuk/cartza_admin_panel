import 'package:flutter/material.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'package:shopease_admin/ai_recommendations/ai_recommendations_page.dart';

class SidebarMenu extends StatelessWidget {
  final Function(int) onMenuSelected;
  final int selectedIndex;

  const SidebarMenu({
    Key? key,
    required this.onMenuSelected,
    required this.selectedIndex,
  }) : super(key: key);

  static const darkSidebar = Color(0xFF0B0C10);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sidebarColor = isDark ? darkSidebar : Colors.white;
    final t = AppLocalizations.of(context)!;

    return Container(
      width: 258,
      color: sidebarColor,
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: sidebarColor,
            child: Image.asset(
              isDark
                  ? "assets/images/456.png"
                  : "assets/images/123.png",
              fit: BoxFit.cover,
            ),
          ),

          Expanded(
            child: Container(
              color: sidebarColor,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _menu(context, Icons.dashboard, t.dashboard, 0, isDark),
                  _menu(context, Icons.shopping_bag, t.ordersMenu, 1, isDark),
                  _menu(context, Icons.inventory, t.productsMenu, 2, isDark),
                  _menu(context, Icons.category, t.categoriesMenu, 3, isDark),
                  _menu(context, Icons.article, t.cmsMenu, 4, isDark),
                  _menu(context, Icons.local_offer, t.promotionsMenu, 6, isDark),

                  const SizedBox(height: 24),

                  _sectionTitle(t.analyticsSection, isDark),
                  _menu(context, Icons.analytics, t.reportsMenu, 7, isDark),
                  _menu(context, Icons.trending_up, t.insights, 8, isDark),
                  _menu(context, Icons.auto_awesome, t.aiInsights, 10, isDark),

                  const SizedBox(height: 24),

                  _sectionTitle(t.systemSection, isDark),
                  _menu(context, Icons.settings, t.settingsMenu, 9, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: isDark
              ? Colors.white.withOpacity(0.5)
              : Colors.black54,
        ),
      ),
    );
  }

  Widget _menu(
      BuildContext context,
      IconData icon,
      String label,
      int index,
      bool isDark,
      ) {
    final isSelected = selectedIndex == index;
    final primary = Color(0xFF4CAF50);

    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: isSelected
            ? (isDark
            ? Colors.white.withOpacity(0.08)
            : primary.withOpacity(0.1))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => onMenuSelected(index),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: isSelected
                ? BoxDecoration(
              border: Border(
                left: BorderSide(color: primary, width: 3),
              ),
            )
                : null,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primary
                        : Colors.white.withOpacity(isDark ? 0.08 : 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white : Colors.black),
                  ),

                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}