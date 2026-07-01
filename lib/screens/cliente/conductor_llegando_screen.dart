import 'package:flutter/material.dart';
import 'home_screen.dart' show AppColors, AppTextStyles;

// ===========================================================
// Pantalla "Llegada a destino" — VISTA DEL CLIENTE
// Según la ficha: al iniciar el servicio el CONDUCTOR registra
// 4 fotografías del vehículo (frontal, trasera, 2 laterales)
// como evidencia de su presencia en el lugar y el estado del
// vehículo. Esta pantalla muestra esas fotos YA ENVIADAS por
// el conductor, para que el cliente las revise.
// Además, al llegar a destino, el cliente puede RECTIFICAR
// (reportar una novedad) o CALIFICAR el servicio.
// El cliente NO toma las fotos, solo las visualiza.
// ===========================================================
class ConductorLlegandoScreen extends StatefulWidget {
  const ConductorLlegandoScreen({super.key});

  @override
  State<ConductorLlegandoScreen> createState() =>
      _ConductorLlegandoScreenState();
}

class _ConductorLlegandoScreenState extends State<ConductorLlegandoScreen> {
  int _rating = 0;
  final TextEditingController _comentarioController = TextEditingController();

  // Evidencia fotográfica enviada por el conductor (simulada).
  // En producción vendría del backend / storage del servicio.
  static const List<_FotoEvidencia> _fotosConductor = [
    _FotoEvidencia(label: "Frontal", icon: Icons.directions_car_rounded),
    _FotoEvidencia(label: "Trasera", icon: Icons.airline_seat_recline_normal_rounded),
    _FotoEvidencia(label: "Lateral izq.", icon: Icons.directions_car_filled_outlined),
    _FotoEvidencia(label: "Lateral der.", icon: Icons.directions_car_filled_rounded),
  ];

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  void _verFotoCompleta(BuildContext context, _FotoEvidencia foto) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                alignment: Alignment.center,
                child: Icon(foto.icon, color: AppColors.accent, size: 64),
              ),
              const SizedBox(height: 14),
              Text(
                "Vista ${foto.label}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Enviada por el conductor al iniciar el servicio",
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cerrar",
                      style: TextStyle(color: AppColors.accent)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _rectificarServicio(BuildContext context) {
    final TextEditingController motivoController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text("Rectificar servicio",
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Cuéntanos qué ocurrió con tu servicio. Revisaremos tu reporte.",
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: motivoController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Describe la novedad...",
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surfaceAlt,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar",
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Tu reporte fue enviado. Te contactaremos pronto."),
                  backgroundColor: AppColors.surface,
                ),
              );
            },
            child: const Text("Enviar reporte",
                style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  void _calificarServicio(BuildContext context) {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona una calificación antes de continuar"),
          backgroundColor: AppColors.surface,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text("¡Gracias por tu calificación!",
            style: TextStyle(color: Colors.white)),
        content: Text(
          "Calificaste tu servicio con $_rating estrella${_rating == 1 ? '' : 's'}.",
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text("Aceptar",
                style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Material(
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
              ),
              const SizedBox(height: 24),
              _buildIconBadge(),
              const SizedBox(height: 24),
              const Text(
                "Tu vehículo ha llegado\na su destino",
                textAlign: TextAlign.center,
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: 6),
              const Text(
                "Gracias por viajar con nosotros",
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 18),
              _buildPlacaChip(),
              const SizedBox(height: 30),

              // ---------------- Evidencia fotográfica (original) ----------------
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: const [
                    Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
                    SizedBox(width: 6),
                    Text("Evidencia del vehículo", style: AppTextStyles.h2),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Fotos enviadas por el conductor al iniciar el servicio",
                  style: AppTextStyles.caption,
                ),
              ),
              const SizedBox(height: 14),
              _buildFotosGrid(context),

              const SizedBox(height: 30),

              // ---------------- Calificación del servicio (nuevo) ----------------
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: const [
                    Icon(Icons.star_rounded, color: AppColors.accent, size: 18),
                    SizedBox(width: 6),
                    Text("Califica tu servicio", style: AppTextStyles.h2),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Tu opinión nos ayuda a mejorar",
                  style: AppTextStyles.caption,
                ),
              ),
              const SizedBox(height: 14),
              _buildEstrellas(),
              const SizedBox(height: 16),
              _buildComentarioField(),

              const SizedBox(height: 28),
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
                  onPressed: () => _calificarServicio(context),
                  child: const Text(
                    "Calificar servicio",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => _rectificarServicio(context),
                icon: const Icon(Icons.report_problem_outlined,
                    color: AppColors.textSecondary, size: 18),
                label: const Text(
                  "Rectificar servicio",
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Icono destacado con halo ----------------
  Widget _buildIconBadge() {
    return Container(
      width: 130,
      height: 130,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accent.withOpacity(0.08),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.35),
          width: 2,
        ),
      ),
      child: Container(
        width: 92,
        height: 92,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent.withOpacity(0.15),
        ),
        child: const Icon(
          Icons.car_rental_rounded,
          color: AppColors.accent,
          size: 50,
        ),
      ),
    );
  }

  // ---------------- Chip con la placa del vehículo ----------------
  Widget _buildPlacaChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            color: AppColors.accent,
            size: 18,
          ),
          SizedBox(width: 8),
          Text(
            "ABC-123",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Grilla de las 4 fotos enviadas por el conductor ----------------
  Widget _buildFotosGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.25,
      children: _fotosConductor.map((foto) {
        return Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _verFotoCompleta(context, foto),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.success.withOpacity(0.4)),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(foto.icon, color: AppColors.accent, size: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        foto.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text("Toca para ampliar", style: AppTextStyles.caption),
                    ],
                  ),
                  const Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------- Selector de estrellas funcional ----------------
  Widget _buildEstrellas() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final int starValue = index + 1;
        final bool filled = starValue <= _rating;
        return InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            setState(() {
              _rating = starValue;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_border_rounded,
              color: AppColors.accent,
              size: 38,
            ),
          ),
        );
      }),
    );
  }

  // ---------------- Campo de comentario opcional ----------------
  Widget _buildComentarioField() {
    return TextField(
      controller: _comentarioController,
      maxLines: 3,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Deja un comentario (opcional)",
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent),
        ),
        contentPadding: const EdgeInsets.all(14),
      ),
    );
  }
}

class _FotoEvidencia {
  final String label;
  final IconData icon;
  const _FotoEvidencia({required this.label, required this.icon});
}