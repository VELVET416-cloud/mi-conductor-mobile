import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const MiConductorApp());
}

class MiConductorApp extends StatelessWidget {
  const MiConductorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Conductor',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}