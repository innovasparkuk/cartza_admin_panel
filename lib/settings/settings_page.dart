import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';

import '../theme/theme_provider.dart';
import '../theme/locale_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text(t.darkMode),
            subtitle: Text(t.enableDarkTheme),
            value: themeProvider.isDark,
            onChanged: (val) {
              themeProvider.setTheme(val);
            },
          ),

          const Divider(height: 32),

          ListTile(
            title: Text(t.language),
            subtitle: Text(t.selectLanguage),
            trailing: DropdownButton<Locale>(
              value: localeProvider.locale,
              onChanged: (locale) {
                if (locale != null) {
                  localeProvider.setLocale(locale);
                }
              },
              items: [
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text(t.english),
                ),
                DropdownMenuItem(
                  value: const Locale('ur'),
                  child: Text(t.urdu),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}