import 'package:flutter/material.dart';
import 'package:shopease_admin/analytics_report.dart';
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
                  _menu(context, Icons.group, t.customersMenu, 4, isDark),
                  _menu(context, Icons.payment, t.paymentsMenu, 5, isDark),
                  _menu(context, Icons.local_offer, t.promotionsMenu, 6, isDark),
                  _menu(context, Icons.star, t.reviewsMenu, 7, isDark),
                  _menu(context, Icons.article, t.cmsMenu, 8, isDark),
                  _menu(context, Icons.analytics, t.analyticsMenu, 9, isDark),
                  _menu(context, Icons.settings, t.settingsMenu, 10, isDark),
                ],
              ),
            ),
          ),
        ],
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: isSelected ? primary : Colors.transparent,  // Poora background green
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            if (index == 9) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AnalyticsScreen(),
                ),
              );
            } else {
              onMenuSelected(index);
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black54),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,  // Bold text
                      color: isSelected
                          ? Colors.white  // Selected = white text
                          : Colors.black87,  // Not selected = dark black
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