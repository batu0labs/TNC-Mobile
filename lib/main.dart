import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const CatalogApp());
}

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Katalog',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315CFD)),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      ),
      home: const HomeScreen(),
    );
  }
}
