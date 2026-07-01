import 'package:flutter/material.dart';

class HomeConductorScreen extends StatelessWidget {
  const HomeConductorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021B2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF021B2C),
        title: const Text(
          "Panel Conductor",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text(
          "Bienvenido Conductor",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}