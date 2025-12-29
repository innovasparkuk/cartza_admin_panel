import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class ThemeSettingsTile extends StatelessWidget {
  const ThemeSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return SwitchListTile(
      title: const Text(
        "Dark Mode",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: const Text("Switch app appearance"),
      value: themeProvider.isDark,
      onChanged: (value) {
        themeProvider.setTheme(value);
      },
    );
  }
}
