import 'package:flutter/material.dart';
import 'package:sentiric_assistant/ui/home_screen.dart';

void main() {
  runApp(const SentiricApp());
}

class SentiricApp extends StatelessWidget {
  const SentiricApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentiric Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF09090b),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366f1),
          secondary: Color(0xFF3b82f6),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}