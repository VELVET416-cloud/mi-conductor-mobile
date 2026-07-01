import 'package:flutter/material.dart';
import 'conductor_llegando_screen.dart';
import 'home_screen.dart' show AppColors, AppTextStyles;

// ===========================================================
// Pantalla de Seguimiento del Servicio
// Corresponde al subproceso "Seguimiento del servicio":
// ver el movimiento del vehículo y su trazabilidad mientras
// el conductor se dirige al punto de origen del cliente.
// ===========================================================
class SeguimientoScreen extends StatelessWidget {
  const SeguimientoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // -------- Fondo simulando mapa de seguimiento --------
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.surfaceElevated.withOpacity(0.6),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                const Spacer(),
                _buildMapPlaceholder(),
                const Spacer(),
                _buildBottomSheet(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.divider),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: AppColors.success, size: 8),
                SizedBox(width: 6),
                Text("En tiempo real", style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent.withOpacity(0.08),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Container(
            width: 104,
            height: 104,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withOpacity(0.16),
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              size: 54,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "El conductor está en camino",
          textAlign: TextAlign.center,
          style: AppTextStyles.h1,
        ),
        const SizedBox(height: 6),
        const Text(
          "Estamos rastreando la ubicación del vehículo",
          textAlign: TextAlign.center,
          style: AppTextStyles.body,
        ),
      ],
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              _InfoChip(
                icon: Icons.timer_outlined,
                label: "Llegada",
                value: "8 min",
              ),
              SizedBox(width: 12),
              _InfoChip(
                icon: Icons.route_outlined,
                label: "Distancia",
                value: "2.4 km",
              ),
            ],
          ),
          const SizedBox(height: 18),
          _buildDriverCard(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ConductorLlegandoScreen(),
                  ),
                );
              },
              child: const Text(
                "Ver llegada del conductor",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.surfaceElevated,
            child: Icon(Icons.person, color: Colors.white70),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Carlos Pérez", style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                )),
                SizedBox(height: 2),
                Text("Conductor asignado · Placa ABC-123",
                    style: AppTextStyles.caption),
              ],
            ),
          ),
          Material(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.call_rounded, color: AppColors.accent, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                Text(value, style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}