import 'package:flutter/material.dart';

// ===========================================================
// PALETA DE COLORES CENTRALIZADA
// ===========================================================
class AppColors {
  static const Color background = Color(0xFF021B2C);
  static const Color surface = Color(0xFF0A314A);
  static const Color field = Color(0xFF06263A);
  static const Color accent = Color(0xFFFFA43A);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color divider = Color(0x14FFFFFF);
}

// ===========================================================
// Modelo de servicio (según ficha: Seguimiento del servicio,
// Reporte de novedades, Calificación cliente-conductor).
// ===========================================================
class ServicioHistorial {
  final String destino;
  final String origen;
  final String fecha;
  final String conductor;
  final String vehiculo;
  final String estado; // Completado, Cancelado, etc.
  double calificacion;
  String comentario;

  ServicioHistorial({
    required this.destino,
    required this.origen,
    required this.fecha,
    required this.conductor,
    required this.vehiculo,
    required this.estado,
    this.calificacion = 0,
    this.comentario = "",
  });
}

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final List<ServicioHistorial> _servicios = [
    ServicioHistorial(
      destino: "Centro Comercial Santa Fe",
      origen: "Barrio Prado, Cartagena",
      fecha: "25 Junio",
      conductor: "Julian Vance",
      vehiculo: "Mazda 2 - ABC123",
      estado: "Completado",
    ),
    ServicioHistorial(
      destino: "Aeropuerto",
      origen: "Calle 5 #12-34",
      fecha: "20 Junio",
      conductor: "Andrés Pérez",
      vehiculo: "Kia Picanto - XYZ456",
      estado: "Completado",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Historial",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          // -------- Fondo: mapa oscuro estilizado --------
          const Positioned.fill(child: _DarkMapBackground()),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withOpacity(0.45),
                    AppColors.background.withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: _servicios.isEmpty
                ? _buildEmptyState()
                : ListView(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      MediaQuery.of(context).padding.top > 0 ? 12 : 100,
                      20,
                      24,
                    ),
                    children: [
                      const Text(
                        "Servicios recientes",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(_servicios.length, (index) {
                        final s = _servicios[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _ServicioCard(
                            servicio: s,
                            onTap: () => _abrirDetalle(s),
                          ),
                        );
                      }),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.7),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider),
              ),
              child: Icon(Icons.history,
                  size: 38, color: AppColors.textSecondary.withOpacity(0.7)),
            ),
            const SizedBox(height: 18),
            const Text(
              "Aún no tienes servicios en tu historial",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Detalle del servicio (funcional) ----------------
  void _abrirDetalle(ServicioHistorial servicio) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetalleServicioSheet(servicio: servicio),
    );
  }
}

// ===========================================================
// Tarjeta de servicio del historial (interactiva)
// ===========================================================
class _ServicioCard extends StatelessWidget {
  final ServicioHistorial servicio;
  final VoidCallback onTap;

  const _ServicioCard({
    required this.servicio,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.history,
                    color: AppColors.accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        servicio.destino,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            servicio.fecha,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              servicio.estado,
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================
// Hoja de detalle del servicio: muestra origen/destino,
// conductor, vehículo y permite calificar (según ficha:
// "Calificación cliente-conductor de 1 a 5 estrellas, con
// comentario") y reportar una novedad sobre ese servicio.
// ===========================================================
class _DetalleServicioSheet extends StatefulWidget {
  final ServicioHistorial servicio;

  const _DetalleServicioSheet({required this.servicio});

  @override
  State<_DetalleServicioSheet> createState() => _DetalleServicioSheetState();
}

class _DetalleServicioSheetState extends State<_DetalleServicioSheet> {
  late double _calificacion = widget.servicio.calificacion;
  final _comentarioController = TextEditingController();

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.servicio;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                s.destino,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                s.fecha,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 18),

              _buildInfoRow(Icons.trip_origin, "Origen", s.origen),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.flag, "Destino", s.destino),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.person_outline, "Conductor", s.conductor),
              const SizedBox(height: 10),
              _buildInfoRow(
                  Icons.directions_car_outlined, "Vehículo", s.vehiculo),

              const SizedBox(height: 22),
              const Text(
                "Califica el servicio",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildEstrellas(),

              const SizedBox(height: 14),
              TextField(
                controller: _comentarioController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: "Deja un comentario (opcional)",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: AppColors.field,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.accent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Novedad reportada para este servicio",
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.report_gmailerrorred_outlined,
                          color: AppColors.accent, size: 18),
                      label: const Text(
                        "Reportar",
                        style: TextStyle(color: AppColors.accent),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _calificacion == 0
                          ? null
                          : () {
                              setState(() {
                                widget.servicio.calificacion = _calificacion;
                                widget.servicio.comentario =
                                    _comentarioController.text.trim();
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("¡Gracias por tu reseña!"),
                                ),
                              );
                            },
                      child: const Text(
                        "Enviar reseña",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.accent),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEstrellas() {
    return Row(
      children: List.generate(5, (index) {
        final estrella = index + 1;
        return IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => setState(() => _calificacion = estrella.toDouble()),
          icon: Icon(
            estrella <= _calificacion ? Icons.star : Icons.star_border,
            color: AppColors.accent,
            size: 28,
          ),
        );
      }),
    );
  }
}

// ===========================================================
// Fondo de "mapa oscuro" dibujado por código (mismo estilo
// usado en la pantalla de inicio): cuadrícula sutil, vías
// principales curvas y puntos de interés con resplandor.
// ===========================================================
class _DarkMapBackground extends StatelessWidget {
  const _DarkMapBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.background),
      child: CustomPaint(
        painter: _DarkMapPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _DarkMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgGradient = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0A2A40), AppColors.background],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgGradient);

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.035)
      ..strokeWidth = 1;
    const spacing = 38.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final roadPaintAccent = Paint()
      ..color = AppColors.accent.withOpacity(0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    Path road1 = Path()
      ..moveTo(-20, size.height * 0.18)
      ..quadraticBezierTo(
        size.width * 0.35, size.height * 0.05,
        size.width * 0.65, size.height * 0.28,
      )
      ..quadraticBezierTo(
        size.width * 0.9, size.height * 0.45,
        size.width + 20, size.height * 0.30,
      );
    canvas.drawPath(road1, roadPaint);

    Path road2 = Path()
      ..moveTo(-20, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.30, size.height * 0.42,
        size.width * 0.55, size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.8, size.height * 0.78,
        size.width + 20, size.height * 0.62,
      );
    canvas.drawPath(road2, roadPaintAccent);

    Path road3 = Path()
      ..moveTo(size.width * 0.12, -20)
      ..quadraticBezierTo(
        size.width * 0.22, size.height * 0.4,
        size.width * 0.18, size.height * 0.75,
      )
      ..quadraticBezierTo(
        size.width * 0.15, size.height * 0.9,
        size.width * 0.1, size.height + 20,
      );
    canvas.drawPath(road3, roadPaint);

    Path road4 = Path()
      ..moveTo(size.width * 0.78, -20)
      ..quadraticBezierTo(
        size.width * 0.7, size.height * 0.3,
        size.width * 0.82, size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.9, size.height * 0.8,
        size.width * 0.85, size.height + 20,
      );
    canvas.drawPath(road4, roadPaint);

    final glowCenter = Offset(size.width * 0.62, size.height * 0.32);
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [AppColors.accent.withOpacity(0.35), Colors.transparent],
      ).createShader(Rect.fromCircle(center: glowCenter, radius: 60));
    canvas.drawCircle(glowCenter, 60, glowPaint);
    canvas.drawCircle(
      glowCenter,
      5,
      Paint()..color = AppColors.accent,
    );

    final glowCenter2 = Offset(size.width * 0.22, size.height * 0.7);
    final glowPaint2 = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white.withOpacity(0.10), Colors.transparent],
      ).createShader(Rect.fromCircle(center: glowCenter2, radius: 50));
    canvas.drawCircle(glowCenter2, 50, glowPaint2);
    canvas.drawCircle(
      glowCenter2,
      4,
      Paint()..color = Colors.white.withOpacity(0.5),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}