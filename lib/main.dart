import 'package:flutter/material.dart';
import 'package:pocketapi/screens/splash_screen.dart';
import 'package:pocketapi/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLightMode = prefs.getBool('isLightMode') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(initialMode: isLightMode),
      child: const PocketApiApp(),
    ),
  );
}

class PocketApiApp extends StatelessWidget {
  const PocketApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'PocketAPI',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isLightMode ? lightTheme : darkTheme,
      home: const SplashScreen(),
    );
  }
}
