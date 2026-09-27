import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';
import 'services/grocery_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storage = GroceryStorage(prefs);
  runApp(GroceryApp(storage: storage));
}

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key, required this.storage});

  final GroceryStorage storage;

  static const Color _premiumGreen = Color(0xFF1B5E20);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E7D32),
      brightness: Brightness.light,
      primary: _premiumGreen,
    );

    return MaterialApp(
      title: 'Grocery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: Colors.transparent,
        useMaterial3: true,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: _premiumGreen,
          foregroundColor: colorScheme.onPrimary,
          elevation: 6,
          highlightElevation: 8,
          extendedPadding: const EdgeInsets.symmetric(horizontal: 22),
          extendedIconLabelSpacing: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: HomeScreen(storage: storage),
    );
  }
}
