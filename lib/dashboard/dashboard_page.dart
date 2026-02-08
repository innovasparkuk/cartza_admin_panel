import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease_admin/customer_management.dart';
import 'package:shopease_admin/order_page.dart';

import 'dashboard_cards.dart';
import 'dashboard_charts.dart';
import 'sidebar.dart';

import 'package:shopease_admin/l10n/app_localizations.dart';
import 'package:shopease_admin/dashboard_provider.dart';

import 'package:shopease_admin/categories_page.dart';
import 'package:shopease_admin/product_management.dart';
import 'package:shopease_admin/top_products.dart';
import 'package:shopease_admin/user_growth_chart.dart';
import 'package:shopease_admin/promotions/promotions_page.dart';
import 'package:shopease_admin/cms/cms_page.dart';
import 'package:shopease_admin/notifications/notifications_page.dart';
import 'package:shopease_admin/settings/settings_page.dart';
import 'package:shopease_admin/analytics_report.dart';
import 'package:shopease_admin/ai_recommendations/ai_recommendations_page.dart';

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
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DashboardProvider>().loadDashboardData();
    });
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                _buildTopBar(context, t),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: _buildContent(context, t),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AppLocalizations t) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocus,
                            decoration: InputDecoration(
                              hintText: t.search,
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
              _topIcon(context, icon: Icons.mail_outline, onTap: () {}),
              const SizedBox(width: 24),
              CircleAvatar(
                radius: 20,
                backgroundColor: isDark
                    ? const Color(0xFF4CAF50)
                    : theme.colorScheme.primary,
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
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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

  Widget _buildContent(BuildContext context, AppLocalizations t) {
    switch (_selectedMenuIndex) {
      case 0:
        return Consumer<DashboardProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        provider.loadDashboardData();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // ✅ No parameters needed - DashboardCards reads from Provider directly
                  const DashboardCards(),
                  const SizedBox(height: 24),
                  // ✅ No parameters needed - DashboardCharts reads from Provider directly
                  const DashboardCharts(),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Expanded(
                        child: UserGrowthChart(),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TopProducts(),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      case 1:
        return const OrdersPageFinal();
      case 2:
        return const ProductManagementPage();
      case 3:
        return const CategoriesPage();
      case 4:
        return const CustomerManagementDashboard();
      case 5:
        return const NotificationsPage();
      case 6:
        return PromotionsPage();

      case 8:
        return CmsPage();
      case 9:
        return AnalyticsScreen();
      case 10:
        return const SettingsPage();

      default:
        return Center(
          child: Text(
            t.pageUnderDevelopment,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
          ),
        );
    }
  }
}