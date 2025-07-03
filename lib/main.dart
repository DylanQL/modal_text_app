import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/inventario_provider.dart';
import 'screens/home_screen.dart';
import 'themes/app_themes.dart';

void main() {
  runApp(const InventarioApp());
}

class InventarioApp extends StatelessWidget {
  const InventarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InventarioProvider()..initializeDatabase(),
      child: MaterialApp(
        title: 'ModaText',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}


