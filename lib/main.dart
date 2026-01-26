import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shopease_admin/dashboard/dashboard_page.dart';
import 'package:shopease_admin/product_form.dart';
import 'package:shopease_admin/product_management.dart';

import 'stock_management.dart';
import 'theme/theme_provider.dart';
import 'theme/app_theme.dart';
import 'theme/locale_provider.dart';
import 'l10n/app_localizations.dart';
import 'admin_provider.dart'; // ✅ IMPORTANT

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()), // ✅ ADD THIS
      ],
      child: const ShopEaseAdminApp(),
    ),
  );
}

class ShopEaseAdminApp extends StatelessWidget {
  const ShopEaseAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      title: 'ShopEase Admin',
      debugShowCheckedModeBanner: false,

      locale: localeProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
      themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,

      home: DashboardPage(),
    );
  }
}
