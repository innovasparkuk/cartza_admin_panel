import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shopease_admin/product_management.dart';
import 'dashboard_cards.dart';
import 'dashboard_charts.dart';
import 'sidebar.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'package:shopease_admin/ai_recommendations/ai_recommendations_page.dart';
import 'package:shopease_admin/settings/settings_page.dart';
import 'package:shopease_admin/top_products.dart';
import 'package:shopease_admin/user_growth_chart.dart';
import 'package:shopease_admin/promotions/promotions_page.dart';
import 'package:shopease_admin/cms/cms_page.dart';
import 'package:shopease_admin/notifications/notifications_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedMenuIndex = 0;

  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Row(
        children: [
          SidebarMenu(
            selectedIndex: _selectedMenuIndex,
            onMenuSelected: (index) {
              setState(() => _selectedMenuIndex = index);
            },
          ),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context, isDark, t),
                Expanded(
                  child: Container(
                    color: theme.scaffoldBackgroundColor,
                    child: _buildContent(t),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(
      BuildContext context,
      bool isDark,
      AppLocalizations t,
      ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    FocusScope.of(context).requestFocus(_searchFocus);
                  },
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color:
                          theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocus,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: t.search,
                              hintStyle: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.5),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),

              _topIcon(
                context,
                icon: Icons.notifications_none,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  );
                },
              ),

              const SizedBox(width: 16),

              _topIcon(
                context,
                icon: Icons.mail_outline,
                onTap: () {},
              ),

              const SizedBox(width: 24),

              CircleAvatar(
                radius: 20,
                backgroundColor: isDark
                    ? const Color(0xFF4CAF50)
                    : (theme.appBarTheme.iconTheme?.color ??
                    theme.iconTheme.color ??
                    theme.colorScheme.primary),
                child: const Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            t.welcomeAdmin,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topIcon(
      BuildContext context, {
        required IconData icon,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildContent(AppLocalizations t) {
    switch (_selectedMenuIndex) {
      case 0:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              DashboardCards(),
              const SizedBox(height: 24),
              DashboardCharts(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: UserGrowthChart()),
                  const SizedBox(width: 20),
                  Expanded(child: TopProducts()),
                ],
              ),
            ],
          ),
        );
      case 2:
        return const ProductManagementPage();

      case 4:
        return const CmsPage();

      case 5:
        return const NotificationsPage();

      case 6:
        return PromotionsPage();

      case 9:
        return const SettingsPage();

      case 10:
        return AIRecommendationsPage();

      default:
        return Center(
          child: Text(
            t.pageUnderDevelopment,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.6),
            ),
          ),
        );
    }
  }
}