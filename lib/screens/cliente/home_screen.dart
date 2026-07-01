import 'package:flutter/material.dart';
import 'solicitar_viaje_screen.dart';
import 'vehiculos_screen.dart';
import 'historial_screen.dart';
import 'perfil_screen.dart';

// ===========================================================
// PALETA DE COLORES CENTRALIZADA
// ===========================================================
class AppColors {
  static const Color background = Color(0xFF071A2C);
  static const Color surface = Color(0xFF0F2A42);
  static const Color surfaceAlt = Color(0xFF0A2236);
  static const Color surfaceElevated = Color(0xFF143352);
  static const Color accent = Color(0xFFFFA43A);
  static const Color accentSoft = Color(0xFFFFC679);
  static const Color success = Color(0xFF34D399);
  static const Color danger = Color(0xFFEF5350);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFA9BDD0);
  static const Color divider = Color(0x14FFFFFF);
}

class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );
  static const TextStyle h2 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle body = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13.5,
    height: 1.3,
  );
  static const TextStyle caption = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
  );
}

// ===========================================================
// Modelo simple de un reporte de novedad/incidente
// (Solo lectura: estos reportes provienen de viajes anteriores,
// generados por el subproceso "Reporte de novedades" en backend)
// ===========================================================
class ReporteViaje {
  final String categoria;
  final String descripcion;
  final DateTime fecha;
  final String estado; // "Pendiente" | "Revisado"

  ReporteViaje({
    required this.categoria,
    required this.descripcion,
    required this.fecha,
    this.estado = "Pendiente",
  });

  IconData get icono {
    switch (categoria) {
      case "Accidente":
        return Icons.car_crash_rounded;
      case "Tráfico":
        return Icons.traffic_rounded;
      case "Falla del vehículo":
        return Icons.build_rounded;
      case "Comportamiento del conductor":
        return Icons.sentiment_dissatisfied_rounded;
      default:
        return Icons.report_problem_rounded;
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomePage(),
    VehiculosScreen(),
    HistorialScreen(),
    PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        border: const Border(
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.accent,
            unselectedItemColor: AppColors.textSecondary,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedLabelStyle: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
            ),
            currentIndex: currentIndex,
            onTap: (index) => setState(() => currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: "Inicio",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_car_outlined),
                activeIcon: Icon(Icons.directions_car_rounded),
                label: "Vehículos",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_outlined),
                activeIcon: Icon(Icons.history_rounded),
                label: "Historial",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: "Perfil",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Historial de reportes generados durante viajes anteriores.
  // Solo lectura: en producción vendría del backend (subproceso
  // "Reporte de novedades" / "Gestión de Trazabilidad y Control
  // del Servicio"). Esta pantalla no crea reportes nuevos.
  final List<ReporteViaje> _reportes = [
    ReporteViaje(
      categoria: "Tráfico",
      descripcion: "Congestión fuerte en la Av. Principal, retraso de 15 min.",
      fecha: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      estado: "Revisado",
    ),
    ReporteViaje(
      categoria: "Falla del vehículo",
      descripcion: "Luz de batería encendida durante el trayecto.",
      fecha: DateTime.now().subtract(const Duration(days: 6)),
      estado: "Revisado",
    ),
  ];

  // ---------------- Notificaciones ----------------
  void _abrirNotificaciones() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _SheetHandle(),
            Text("Notificaciones", style: AppTextStyles.h2),
            SizedBox(height: 14),
            _NotificationTile(
              icon: Icons.directions_car_filled_rounded,
              title: "Conductor asignado",
              subtitle: "Carlos Pérez fue asignado a tu servicio",
            ),
            SizedBox(height: 10),
            _NotificationTile(
              icon: Icons.star_rounded,
              title: "Califica tu último servicio",
              subtitle: "Cuéntanos cómo fue tu experiencia",
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Historial de reportes (solo lectura) ----------------
  // Se abre al pulsar el botón "Historial de reportes". Muestra
  // únicamente las novedades registradas en viajes anteriores.
  void _abrirHistorialReportes() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: _SheetHandle()),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.fact_check_rounded,
                            color: AppColors.accent, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Historial de reportes", style: AppTextStyles.h2),
                            const SizedBox(height: 2),
                            Text(
                              "${_reportes.length} novedad(es) registradas en tus viajes",
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _reportes.isEmpty
                        ? _buildEmptyReportes()
                        : ListView.separated(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _reportes.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              return _ReporteCard(
                                reporte: _reportes[index],
                                formatearFecha: _formatearFecha,
                                onTap: () => _verDetalleReporte(_reportes[index]),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyReportes() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle_outline_rounded,
                color: AppColors.textSecondary, size: 30),
            SizedBox(height: 10),
            Text("Aún no tienes reportes registrados", style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }

  void _verDetalleReporte(ReporteViaje reporte) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(reporte.icono, color: AppColors.accent, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(reporte.categoria,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reporte.descripcion, style: AppTextStyles.body),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(_formatearFecha(reporte.fecha), style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cerrar", style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final dias = DateTime.now().difference(fecha).inDays;
    if (dias == 0) return "Hoy";
    if (dias == 1) return "Ayer";
    return "Hace $dias días";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // -------- Fondo: mapa oscuro estilizado (dibujado en código) --------
          const Positioned.fill(child: _DarkMapBackground()),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withOpacity(0.35),
                    AppColors.background.withOpacity(0.92),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 18),
                  const Text("Bienvenido de nuevo", style: AppTextStyles.body),
                  const SizedBox(height: 2),
                  const Text("¿Listo para tu próximo servicio?", style: AppTextStyles.h1),

                  const SizedBox(height: 22),
                  _buildStatusBanner(),

                  const SizedBox(height: 24),
                  const Text("Servicios", style: AppTextStyles.h2),
                  const SizedBox(height: 12),
                  _buildServiceCard(context),

                  const SizedBox(height: 22),
                  const Text("Accesos rápidos", style: AppTextStyles.h2),
                  const SizedBox(height: 12),
                  _buildQuickActions(context),

                  const SizedBox(height: 22),
                  _buildReportesSection(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Encabezado ----------------
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(Icons.directions_car_filled_rounded, color: AppColors.accent, size: 24),
            SizedBox(width: 8),
            Text(
              "Mi conductor ",
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 21,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        _circleIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: _abrirNotificaciones,
          showDot: true,
        ),
      ],
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool showDot = false,
  }) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: AppColors.textPrimary, size: 22),
              if (showDot)
                Positioned(
                  right: -1,
                  top: -1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Banner de estado ----------------
  Widget _buildStatusBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surfaceElevated, AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.verified_user_rounded, color: AppColors.success, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sin servicios activos", style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )),
                SizedBox(height: 2),
                Text("Solicita un viaje cuando lo necesites", style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Tarjeta principal de servicios ----------------
  Widget _buildServiceCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          _ServiceTile(
            icon: Icons.car_rental_rounded,
            title: "Pedir Viaje",
            subtitle: "Solicita un conductor para tu vehículo",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SolicitarViajeScreen()),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(color: AppColors.divider, height: 1),
          ),
          _ServiceTile(
            icon: Icons.directions_car_filled_outlined,
            title: "Mis Vehículos",
            subtitle: "Gestiona los vehículos registrados",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VehiculosScreen()),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(color: AppColors.divider, height: 1),
          ),
          _ServiceTile(
            icon: Icons.receipt_long_rounded,
            title: "Historial de servicios",
            subtitle: "Revisa tus viajes y novedades reportadas",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistorialScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------- Accesos rápidos ----------------
  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.person_outline_rounded,
            label: "Mi\nperfil",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PerfilScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.receipt_long_outlined,
            label: "Ver\nhistorial",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistorialScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------- Sección de reportes (acceso de solo lectura) ----------------
  Widget _buildReportesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.fact_check_rounded, color: AppColors.accent, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Reportes de viaje", style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    )),
                    const SizedBox(height: 2),
                    const Text(
                      "Consulta las novedades registradas en tus viajes anteriores",
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${_reportes.length}",
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                side: BorderSide(color: AppColors.accent.withOpacity(0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _abrirHistorialReportes,
              icon: const Icon(Icons.history_rounded, size: 18),
              label: const Text(
                "Historial de reportes",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// Tarjeta de reporte usada dentro del panel de "Historial de
// reportes" (solo lectura).
// ===========================================================
class _ReporteCard extends StatelessWidget {
  final ReporteViaje reporte;
  final String Function(DateTime) formatearFecha;
  final VoidCallback onTap;

  const _ReporteCard({
    required this.reporte,
    required this.formatearFecha,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool revisado = reporte.estado == "Revisado";
    return Material(
      color: AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(reporte.icono, color: AppColors.accent, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reporte.categoria, style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
                    const SizedBox(height: 2),
                    Text(
                      reporte.descripcion,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 4),
                    Text(formatearFecha(reporte.fecha), style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    )),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: (revisado ? AppColors.success : AppColors.accent)
                      .withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  reporte.estado,
                  style: TextStyle(
                    color: revisado ? AppColors.success : AppColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================
// Fondo de "mapa oscuro" dibujado por código (sin depender de
// assets externos): cuadrícula sutil, vías principales curvas
// y puntos de interés con resplandor, estilo mapa premium.
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
        colors: [Color(0xFF0B2238), Color(0xFF071A2C)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgGradient);

    // -------- Cuadrícula sutil tipo mapa --------
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

    // -------- Vías principales (curvas tipo avenidas) --------
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

    // -------- Punto de interés con resplandor (estilo "tu ubicación") --------
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

// ===========================================================
// Componente reutilizable para las opciones de la tarjeta
// ===========================================================
class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.accent, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                    )),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.caption),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textSecondary, size: 15),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================
// Tarjeta compacta de acceso rápido
// ===========================================================
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.accent, size: 24),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================
// Tile usado en el panel de notificaciones
// ===========================================================
class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                )),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}