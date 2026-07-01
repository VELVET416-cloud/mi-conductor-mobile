import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.secondary,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: Colors.white70,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Inicio",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.car_rental),
          label: "Servicios",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: "Actividad",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Perfil",
        ),
      ],
    );
  }
}