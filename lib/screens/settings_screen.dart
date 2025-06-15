import 'package:flutter/material.dart';
import 'package:pocketapi/theme/theme_provider.dart';
import 'package:provider/provider.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        leading: const Icon(Icons.light_mode),
        title: const Text('Enable Light Mode'),
        subtitle: const Text('Switch between dark and light theme'),
        trailing: Switch(
          value: themeProvider.isLightMode,
          onChanged: (value) => themeProvider.toggleTheme(value),
        ),
      ),
    );
  }
}
