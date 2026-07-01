import 'package:flutter/material.dart';

/// ============================================================
/// MI CONDUCTOR — DESIGN SYSTEM
/// Paleta oficial basada en la guía de marca (Primary / Secondary /
/// Tertiary / Neutral) adaptada a una app mobile para conductores.
/// ============================================================
class AppColors {
  // ---------- PRIMARY (ámbar / naranja — acción, marca) ----------
  static const Color primary = Color(0xFFD97A1F);
  static const Color primaryLight = Color(0xFFF0A155);
  static const Color primaryDark = Color(0xFFA85C13);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ---------- SECONDARY (azul petróleo — confianza, navegación) ----------
  static const Color secondary = Color(0xFF0E4C5C);
  static const Color secondaryLight = Color(0xFF3E7A8C);
  static const Color secondaryDark = Color(0xFF083440);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // ---------- TERTIARY (marrón cálido — detalles, iconografía) ----------
  static const Color tertiary = Color(0xFF6B5545);
  static const Color tertiaryLight = Color(0xFF9C8674);
  static const Color tertiaryDark = Color(0xFF463628);

  // ---------- NEUTRAL SCALE (fondo / texto) ----------
  static const Color neutral900 = Color(0xFF14202A); // navy oscuro (marca)
  static const Color neutral700 = Color(0xFF344452);
  static const Color neutral500 = Color(0xFF6B7A87);
  static const Color neutral300 = Color(0xFFC4CDD4);
  static const Color neutral100 = Color(0xFFEAF0F1);
  static const Color neutral50  = Color(0xFFF4F6FA);

  // ---------- Alias compatibles con tu código actual ----------
  static const Color background = neutral50;
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = neutral100;
  static const Color textPrimary = neutral900;
  static const Color textSecondary = neutral500;
  static const Color divider = Color(0xFFE3E6ED);

  // ---------- ESTADOS (según ficha: activo / inactivo / en ruta) ----------
  static const Color success = Color(0xFF2FAE60); // activo
  static const Color danger  = Color(0xFFE14B4B); // inactivo / rechazado
  static const Color warning = Color(0xFFE8A93B); // en ruta / pendiente
  static const Color info    = Color(0xFF3A8FB7); // seguimiento en tiempo real

  static const Color onSuccessBg = Color(0xFFE6F7ED);
  static const Color onDangerBg  = Color(0xFFFCE9E9);
  static const Color onWarningBg = Color(0xFFFCF1DD);
  static const Color onInfoBg    = Color(0xFFE6F2F8);

  // ---------- GRADIENTES ----------
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [secondaryDark, secondary, primary],
    begin: Alignment.topCenter,
    end: Alignment.bottomRight,
  );
}

/// ============================================================
/// TIPOGRAFÍA
/// ============================================================
class AppTextStyles {
  static const String fontFamily = 'Poppins'; // agrega la fuente en pubspec.yaml

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  // Compatibilidad con tu estilo original
  static const TextStyle heading = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subheading = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textSecondary,
    fontSize: 12,
  );

  static const TextStyle cardValue = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cardLabel = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textSecondary,
    fontSize: 12,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
}

/// ============================================================
/// RADIOS, ESPACIADOS Y SOMBRAS
/// ============================================================
class AppRadius {
  static const double sm = 8;
  static const double md = 14;
  static const double lg = 20;
  static const double pill = 100;
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppShadows {
  static List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.neutral900.withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> button = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.35),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> floating = [
    BoxShadow(
      color: AppColors.neutral900.withOpacity(0.12),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

/// ============================================================
/// ESTADOS DEL CONDUCTOR (Ficha: activo, inactivo, en ruta)
/// Widget reutilizable de badge de estado.
/// ============================================================
enum DriverStatus { activo, inactivo, enRuta }

class StatusStyle {
  final Color color;
  final Color background;
  final String label;
  const StatusStyle(this.color, this.background, this.label);
}

class AppStatus {
  static StatusStyle of(DriverStatus status) {
    switch (status) {
      case DriverStatus.activo:
        return const StatusStyle(
            AppColors.success, AppColors.onSuccessBg, 'Activo');
      case DriverStatus.enRuta:
        return const StatusStyle(
            AppColors.warning, AppColors.onWarningBg, 'En ruta');
      case DriverStatus.inactivo:
        return const StatusStyle(
            AppColors.danger, AppColors.onDangerBg, 'Inactivo');
    }
  }
}

class StatusBadge extends StatelessWidget {
  final DriverStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final style = AppStatus.of(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: style.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            style.label,
            style: AppTextStyles.caption.copyWith(
              color: style.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================
/// TEMA GLOBAL DE LA APP (botones, inputs, appbar, cards)
/// Aplícalo en MaterialApp(theme: AppTheme.light)
/// ============================================================
class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTextStyles.heading,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.neutral300,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: AppTextStyles.button,
          elevation: 0,
        ).copyWith(
          overlayColor: WidgetStateProperty.all(
            AppColors.onPrimary.withOpacity(0.08),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondary,
          side: const BorderSide(color: AppColors.secondary, width: 1.4),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.neutral500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.4),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.neutral500,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}