import 'package:flutter/material.dart';
import 'Branding.dart';
import 'roles_page.dart';
import 'team_page.dart';
import 'tax_page.dart';
import 'security_page.dart';
import 'shipping_page.dart';

/* ================= COLORS ================= */
class AppColors {
  static const primary = Color(0xFFFF6F00);
  static const primaryHover = Color(0xFFF57C00);
  static const dark = Color(0xFF212121);
  static const grey = Color(0xFF9E9E9E);
  static const lightGrey = Color(0xFFE0E0E0);
  static const bg = Color(0xFFFAFAFA);
  static const success = Color(0xFF4CAF50);
  static const danger = Color(0xFFF44336);
}

void main() {
  runApp(const SettingsDashboard());
}

class SettingsDashboard extends StatelessWidget {
  const SettingsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.bg,
      ),
      home: const DashboardHome(),
    );
  }
}

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  String currentView = 'branding';

  final Map<String, Map<String, String>> titles = {
    'branding': {
      'title': 'Branding Settings',
      'subtitle': 'Customize your brand identity and appearance',
    },
    'shipping': {
      'title': 'Shipping Settings',
      'subtitle': 'Configure shipping zones and rates',
    },
    'roles': {
      'title': 'Roles & Permissions',
      'subtitle': 'Control access and user permissions',
    },
    'team': {
      'title': 'Team Members',
      'subtitle': 'Manage your team and collaborators',
    },
    'taxes': {
      'title': 'Tax Settings',
      'subtitle': 'Manage tax rates and regulations',
    },
    'security': {
      'title': 'Security Settings',
      'subtitle': 'Protect your account and data',
    },
  };

  Widget getCurrentViewWidget() {
    switch (currentView) {
      case 'branding':
        return const  BrandingPage();
      case 'shipping':

        return const   ShippingPage();

      case 'roles':
        return const RolesPage();
      case 'team':
        return const TeamPage();
      case 'taxes':
        return const TaxSettingsPage();
      case 'security':
        return const SecurityPage();
      default:
        return Center(child: Text('Content for "$currentView"'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          /* ================= SIDEBAR ================= */
          Container(
            width: 280,
            color: AppColors.dark,
            child: Column(
              children: [
                /* Header */
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFF424242))),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.5),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.settings, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Settings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Configuration Panel',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /* Navigation */
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    children: [
                      navItem('branding', 'Branding', Icons.layers),
                      navItem('shipping', 'Shipping', Icons.local_shipping),
                      navItem('roles', 'Roles & Permissions', Icons.security),
                      navItem('team', 'Team Members', Icons.people),
                      navItem('taxes', 'Taxes', Icons.attach_money),
                      navItem('security', 'Security', Icons.lock),
                    ],
                  ),
                ),

                /* User Profile */
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFF424242))),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryHover],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'AD',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin User',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'admin@company.com',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /* ================= MAIN CONTENT ================= */
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* Header with 3D look */
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4), // subtle shadow for 3D effect
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /* Icon with shadow for 3D effect */
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.settings, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),

                      /* Header Text */
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titles[currentView]!['title']!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppColors.dark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            titles[currentView]!['subtitle']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /* Content Area */
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: getCurrentViewWidget(),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  /* ================= NAV ITEM ================= */
  Widget navItem(String id, String label, IconData icon) {
    final bool active = currentView == id;

    return GestureDetector(
      onTap: () => setState(() => currentView = id),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: active ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          border: Border(
            left: BorderSide(
              width: 3,
              color: active ? AppColors.primary : Colors.transparent,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: active ? AppColors.primary : AppColors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: active ? AppColors.primary : AppColors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
