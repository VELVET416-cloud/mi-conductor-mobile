import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'servicio_activo_screen.dart';

/// Modelo simple de una solicitud de servicio (datos de prueba / mock).
/// Cuando exista backend, esto se reemplaza por el modelo real que venga de la API.
class SolicitudServicio {
  final String cliente;
  final String tipo; // PREMIUM o ESTANDAR
  final double distanciaKm;
  final double precio;
  final String origen;
  final String destino;

  const SolicitudServicio({
    required this.cliente,
    required this.tipo,
    required this.distanciaKm,
    required this.precio,
    required this.origen,
    required this.destino,
  });
}

class HomeConductorScreen extends StatefulWidget {
  const HomeConductorScreen({super.key});

  @override
  State<HomeConductorScreen> createState() => _HomeConductorScreenState();
}

class _HomeConductorScreenState extends State<HomeConductorScreen> {
  int _tabIndex = 0;

  final List<String> _tabTitles = const ['Inicio', 'Servicios', 'Actividad', 'Perfil'];
  final List<IconData> _tabIcons = const [
    Icons.home_rounded,
    Icons.directions_car_rounded,
    Icons.bar_chart_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _tabIndex,
          children: [
            _InicioTab(onServicioAceptado: _abrirServicioActivo),
            const _ServiciosTab(),
            const _ActividadTab(),
            const _PerfilTab(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.floating,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_tabTitles.length, (index) {
          final bool selected = _tabIndex == index;
          final Color color = selected ? AppColors.primary : AppColors.neutral500;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tabIndex = index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary.withOpacity(0.10) : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_tabIcons[index], color: color, size: 22),
                    const SizedBox(height: 4),
                    Text(
                      _tabTitles[index],
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> _abrirServicioActivo(SolicitudServicio servicio) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ServicioActivoScreen(servicio: servicio)),
    );
  }
}

// ---------------------------------------------------------------------------
// TAB: INICIO
// ---------------------------------------------------------------------------

class _InicioTab extends StatefulWidget {
  final void Function(SolicitudServicio) onServicioAceptado;

  const _InicioTab({required this.onServicioAceptado});

  @override
  State<_InicioTab> createState() => _InicioTabState();
}

class _InicioTabState extends State<_InicioTab> {
  bool _disponible = true;

  // Dato de prueba (mock). En la vida real, el servicio llega YA asignado
  // por el administrador (no es una lista para que el conductor escoja).
  // Reemplazar por el servicio real que envíe la API/websocket cuando exista backend.
  final SolicitudServicio? _servicioAsignado = const SolicitudServicio(
    cliente: 'Carlos Mendoza',
    tipo: 'PREMIUM',
    distanciaKm: 1.2,
    precio: 22.40,
    origen: 'Hotel Intercontinental, Zona 10',
    destino: 'Aeropuerto Internacional La Aurora',
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        _buildResumenCards(),
        const SizedBox(height: 14),
        _buildEstadoServicioCard(),
        const SizedBox(height: 22),
        _buildSolicitudesHeader(),
        const SizedBox(height: 12),
        if (_disponible && _servicioAsignado != null)
          _buildSolicitudCard(_servicioAsignado!)
        else
          _buildSinSolicitudes(),
        const SizedBox(height: 16),
        _buildZonaDemanda(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.secondaryGradient,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mi Conductor', style: AppTextStyles.heading),
              Text('Panel del Conductor', style: AppTextStyles.subheading),
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _disponible ? AppColors.onSuccessBg : AppColors.onDangerBg,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _disponible ? AppColors.success : AppColors.danger,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _disponible ? 'DISPONIBLE' : 'DESCONECTADO',
                style: TextStyle(
                  color: _disponible ? AppColors.success : AppColors.danger,
                  fontSize: 11,
                  fontFamily: AppTextStyles.fontFamily,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResumenCards() {
    return Row(
      children: [
        Expanded(child: _infoCard('Ganancias Hoy', '\$145.50', Icons.payments_rounded, AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(child: _infoCard('Calificación', '4.9 ★', Icons.star_rounded, AppColors.warning)),
      ],
    );
  }

  Widget _infoCard(String label, String value, IconData icon, Color accent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(height: 10),
          Text(label, style: AppTextStyles.cardLabel),
          const SizedBox(height: 2),
          Text(value, style: AppTextStyles.cardValue),
        ],
      ),
    );
  }

  Widget _buildEstadoServicioCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estado de Servicio',
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Alterna para recibir solicitudes', style: AppTextStyles.subheading),
              ],
            ),
          ),
          Switch(
            value: _disponible,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withOpacity(0.3),
            onChanged: (value) => setState(() => _disponible = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSolicitudesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Servicio Asignado',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
        if (_disponible && _servicioAsignado != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: const Text(
              'NUEVO',
              style: TextStyle(color: AppColors.onPrimary, fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }

  Widget _buildSinSolicitudes() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Icon(
            _disponible ? Icons.hourglass_top_rounded : Icons.power_settings_new_rounded,
            color: AppColors.neutral500,
            size: 32,
          ),
          const SizedBox(height: 10),
          Text(
            _disponible
                ? 'Aún no tienes ningún servicio asignado. Mantente disponible.'
                : 'Estás desconectado. Actívate para poder recibir servicios asignados.',
            style: AppTextStyles.subheading,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSolicitudCard(SolicitudServicio s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withOpacity(0.35), width: 1.2),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
                ),
                child: const Icon(Icons.person_rounded, color: AppColors.secondary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.cliente,
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
                    Text('A ${s.distanciaKm} km de distancia', style: AppTextStyles.subheading),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(s.tipo,
                        style: const TextStyle(
                            color: AppColors.primaryDark, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 6),
                  Text('\$${s.precio.toStringAsFixed(2)}',
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Column(
              children: [
                _direccionRow(Icons.trip_origin, s.origen, AppColors.success),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Container(width: 1, height: 14, color: AppColors.divider),
                ),
                _direccionRow(Icons.location_on_rounded, s.destino, AppColors.danger),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 13, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Este servicio ya fue asignado. No es posible rechazarlo.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_rounded, size: 18),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              // Según la ficha: "Recibir e iniciar los servicios asignados" y
              // "No se permite rechazar solicitudes". Por eso solo existe
              // este botón de recibir/continuar, sin opción de rechazo.
              onPressed: () => widget.onServicioAceptado(s),
              label: const Text('RECIBIR SERVICIO', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _direccionRow(IconData icon, String texto, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            texto,
            style: AppTextStyles.body.copyWith(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildZonaDemanda() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(Icons.explore_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Moverse a Zona 4 para +20% bono',
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.white70),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TAB: SERVICIOS (historial) — mock con estados variados y detalle funcional
// ---------------------------------------------------------------------------

enum _EstadoHistorial { finalizado, cancelado }

class _ServicioHistorial {
  final String id;
  final String cliente;
  final String fecha;
  final double precio;
  final String origen;
  final String destino;
  final _EstadoHistorial estado;

  const _ServicioHistorial({
    required this.id,
    required this.cliente,
    required this.fecha,
    required this.precio,
    required this.origen,
    required this.destino,
    required this.estado,
  });
}

class _ServiciosTab extends StatelessWidget {
  const _ServiciosTab();

  static final List<_ServicioHistorial> _historial = [
    _ServicioHistorial(
      id: 'Servicio #1000',
      cliente: 'Ana Martínez',
      fecha: '28 jun · 6:40 p.m.',
      precio: 18.00,
      origen: 'Zona Rosa',
      destino: 'Aeropuerto La Aurora',
      estado: _EstadoHistorial.finalizado,
    ),
    _ServicioHistorial(
      id: 'Servicio #1001',
      cliente: 'Luis Pérez',
      fecha: '27 jun · 11:15 p.m.',
      precio: 12.50,
      origen: 'Restaurante Kacao',
      destino: 'Residencial Las Flores',
      estado: _EstadoHistorial.finalizado,
    ),
    _ServicioHistorial(
      id: 'Servicio #1002',
      cliente: 'Marta Gómez',
      fecha: '26 jun · 9:05 p.m.',
      precio: 9.80,
      origen: 'Zona Viva',
      destino: 'Condado Naranjo',
      estado: _EstadoHistorial.cancelado,
    ),
    _ServicioHistorial(
      id: 'Servicio #1003',
      cliente: 'Roberto Díaz',
      fecha: '25 jun · 8:20 p.m.',
      precio: 24.30,
      origen: 'Cayalá',
      destino: 'Muxbal',
      estado: _EstadoHistorial.finalizado,
    ),
    _ServicioHistorial(
      id: 'Servicio #1004',
      cliente: 'Sofía Reyes',
      fecha: '24 jun · 7:50 p.m.',
      precio: 15.60,
      origen: 'Oakland Mall',
      destino: 'Vista Hermosa',
      estado: _EstadoHistorial.finalizado,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Historial de Servicios', style: AppTextStyles.heading),
        const SizedBox(height: 16),
        ..._historial.map((s) => _buildServicioItem(context, s)),
      ],
    );
  }

  Widget _buildServicioItem(BuildContext context, _ServicioHistorial s) {
    final bool finalizado = s.estado == _EstadoHistorial.finalizado;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _mostrarDetalleServicio(context, s),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.directions_car_rounded, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.id, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(s.fecha, style: AppTextStyles.caption),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: finalizado ? AppColors.onSuccessBg : AppColors.onDangerBg,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  finalizado ? 'Finalizado' : 'Cancelado',
                  style: TextStyle(
                    color: finalizado ? AppColors.success : AppColors.danger,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarDetalleServicio(BuildContext context, _ServicioHistorial s) {
    final bool finalizado = s.estado == _EstadoHistorial.finalizado;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DetalleServicioSheet(servicio: s, finalizado: finalizado),
    );
  }
}

class _DetalleServicioSheet extends StatelessWidget {
  final _ServicioHistorial servicio;
  final bool finalizado;

  const _DetalleServicioSheet({required this.servicio, required this.finalizado});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(servicio.id, style: AppTextStyles.heading.copyWith(fontSize: 18)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: finalizado ? AppColors.onSuccessBg : AppColors.onDangerBg,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  finalizado ? 'Finalizado' : 'Cancelado',
                  style: TextStyle(
                    color: finalizado ? AppColors.success : AppColors.danger,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(servicio.fecha, style: AppTextStyles.subheading),
          const SizedBox(height: 18),
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.surfaceLight,
                child: Icon(Icons.person_rounded, color: AppColors.secondary, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(servicio.cliente,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
              ),
              Text('\$${servicio.precio.toStringAsFixed(2)}',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Column(
              children: [
                _fila(Icons.trip_origin, servicio.origen, AppColors.success),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Container(width: 1, height: 14, color: AppColors.divider),
                ),
                _fila(Icons.location_on_rounded, servicio.destino, AppColors.danger),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondary,
                side: const BorderSide(color: AppColors.secondary),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, size: 18),
              label: const Text('Cerrar', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fila(IconData icon, String texto, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 10),
        Expanded(child: Text(texto, style: AppTextStyles.body.copyWith(fontSize: 13))),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// TAB: ACTIVIDAD — ahora con sugerencias de comportamiento
// ---------------------------------------------------------------------------

/// Métrica individual de comportamiento (según la ficha: puntualidad,
/// seguridad, satisfacción del cliente) con su sugerencia de mejora.
class _MetricaComportamiento {
  final String nombre;
  final double valor; // 0.0 a 1.0
  final Color color;
  final IconData icono;
  final String sugerencia;

  const _MetricaComportamiento({
    required this.nombre,
    required this.valor,
    required this.color,
    required this.icono,
    required this.sugerencia,
  });

  /// Prioridad visual: si el indicador está por debajo del 90%, se resalta
  /// como sugerencia importante; si no, como buena práctica a mantener.
  bool get requiereAtencion => valor < 0.90;
}

class _ActividadTab extends StatelessWidget {
  const _ActividadTab();

  // Mock de métricas de desempeño. Reemplazar por los datos reales que
  // calcule el backend en el Subproceso de Gestión de Medición y Desempeño.
  static const List<_MetricaComportamiento> _metricas = [
    _MetricaComportamiento(
      nombre: 'Puntualidad',
      valor: 0.94,
      color: AppColors.success,
      icono: Icons.schedule_rounded,
      sugerencia: 'Llega 5 minutos antes al punto de recogida para mantener tu buen tiempo de respuesta.',
    ),
    _MetricaComportamiento(
      nombre: 'Seguridad al conducir',
      valor: 0.98,
      color: AppColors.secondary,
      icono: Icons.shield_rounded,
      sugerencia: 'Excelente nivel de seguridad. Sigue respetando los límites de velocidad y las señales de tránsito.',
    ),
    _MetricaComportamiento(
      nombre: 'Satisfacción del cliente',
      valor: 0.86,
      color: AppColors.warning,
      icono: Icons.emoji_emotions_rounded,
      sugerencia: 'Saluda al cliente al recogerlo y confirma el destino antes de iniciar el viaje. Pequeños gestos suben tu calificación.',
    ),
    _MetricaComportamiento(
      nombre: 'Registro fotográfico',
      valor: 0.99,
      color: AppColors.primary,
      icono: Icons.camera_alt_rounded,
      sugerencia: 'Tus evidencias fotográficas están completas casi siempre. Recuerda tomar las 4 fotos con buena luz.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Se muestran primero las métricas que requieren más atención.
    final sugerencias = [..._metricas]
      ..sort((a, b) => a.valor.compareTo(b.valor));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Actividad y Desempeño', style: AppTextStyles.heading),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _statCard(
                context,
                label: 'Viajes esta semana',
                value: '18',
                icon: Icons.route_rounded,
                accent: AppColors.secondary,
                detalle: 'Realizaste 18 viajes esta semana, 3 más que la semana pasada. ¡Buen ritmo!',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                context,
                label: 'Calificación prom.',
                value: '4.9 ★',
                icon: Icons.star_rounded,
                accent: AppColors.warning,
                detalle: 'Tu calificación promedio de los últimos 30 días es 4.9 sobre 5, basada en 42 evaluaciones de clientes.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Comportamiento del conductor',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 10),
        InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () => _mostrarComportamientoCompleto(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Puntualidad, seguridad y satisfacción del cliente basados en las calificaciones recibidas.',
                    style: AppTextStyles.subheading,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 26),
        Row(
          children: const [
            Icon(Icons.tips_and_updates_rounded, size: 18, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Sugerencias para mejorar',
                style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Basadas en tu desempeño reciente. Aplícalas para subir tu calificación.',
          style: AppTextStyles.subheading,
        ),
        const SizedBox(height: 12),
        ...sugerencias.map((m) => _buildSugerenciaCard(m)),
      ],
    );
  }

  Widget _buildSugerenciaCard(_MetricaComportamiento m) {
    final Color acento = m.requiereAtencion ? AppColors.warning : AppColors.success;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: acento.withOpacity(0.25)),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: m.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(m.icono, color: m.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(m.nombre,
                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13.5)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: acento.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        '${(m.valor * 100).toStringAsFixed(0)}%',
                        style: TextStyle(color: acento, fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(m.sugerencia, style: AppTextStyles.subheading.copyWith(fontSize: 12.5, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color accent,
    required String detalle,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () => _mostrarDetalleStat(context, label: label, value: value, icon: icon, accent: accent, detalle: detalle),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: accent),
            const SizedBox(height: 10),
            Text(label, style: AppTextStyles.cardLabel),
            const SizedBox(height: 2),
            Text(value, style: AppTextStyles.cardValue),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalleStat(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color accent,
    required String detalle,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            Icon(icon, color: accent),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppTextStyles.display.copyWith(fontSize: 26)),
            const SizedBox(height: 10),
            Text(detalle, style: AppTextStyles.body),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  void _mostrarComportamientoCompleto(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, scrollController) => Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
              Text('Comportamiento del conductor', style: AppTextStyles.heading.copyWith(fontSize: 18)),
              const SizedBox(height: 16),
              ..._metricas.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _barraIndicador(m),
                  )),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    side: const BorderSide(color: AppColors.secondary),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _barraIndicador(_MetricaComportamiento m) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(m.icono, size: 15, color: m.color),
                const SizedBox(width: 6),
                Text(m.nombre, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            Text('${(m.valor * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, color: m.color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: m.valor,
            minHeight: 8,
            backgroundColor: AppColors.neutral100,
            color: m.color,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// TAB: PERFIL — datos según ficha de registro (sin "Mi vehículo": el
// conductor no tiene vehículo propio, recoge el del cliente).
// ---------------------------------------------------------------------------

/// Datos del conductor, según los campos exactos con los que se registra
/// en la ficha: Documento de identidad, Nombres y Apellidos, Correo
/// electrónico y Teléfono. Mock local; en producción vendría del backend.
class _DatosConductor {
  String documento;
  String nombres;
  String correo;
  String telefono;

  _DatosConductor({
    required this.documento,
    required this.nombres,
    required this.correo,
    required this.telefono,
  });
}

class _PerfilTab extends StatefulWidget {
  const _PerfilTab();

  @override
  State<_PerfilTab> createState() => _PerfilTabState();
}

class _PerfilTabState extends State<_PerfilTab> {
  // Mock de datos, con la misma estructura que la tabla "Aprendices
  // participantes" de la ficha. Reemplazar por los datos reales del
  // conductor autenticado cuando exista backend.
  final _DatosConductor _datos = _DatosConductor(
    documento: '1017932365',
    nombres: 'Maria Paula',
    correo: 'mprymedina@gmail.com',
    telefono: '3234192386',
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                ),
                child: const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.surfaceLight,
                  child: Icon(Icons.person_rounded, size: 40, color: AppColors.secondary),
                ),
              ),
              const SizedBox(height: 14),
              Text(_datos.nombres, style: AppTextStyles.heading, textAlign: TextAlign.center),
              const SizedBox(height: 4),
              const StatusBadge(status: DriverStatus.activo),
              const SizedBox(height: 4),
              const Text('Licencia vigente: 12/2027', style: AppTextStyles.subheading),
            ],
          ),
        ),
        const SizedBox(height: 28),
        _perfilItem(
          context,
          icon: Icons.badge_rounded,
          label: 'Datos personales',
          onTap: () => _mostrarDatosPersonales(context),
        ),
        _perfilItem(
          context,
          icon: Icons.description_rounded,
          label: 'Documentos',
          onTap: () => _mostrarDocumentos(context),
        ),
        _perfilItem(
          context,
          icon: Icons.settings_rounded,
          label: 'Configuración',
          onTap: () => _mostrarConfiguracion(context),
        ),
        _perfilItem(
          context,
          icon: Icons.logout_rounded,
          label: 'Cerrar sesión',
          color: AppColors.danger,
          onTap: () => _confirmarCerrarSesion(context),
        ),
      ],
    );
  }

  Widget _perfilItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = AppColors.textPrimary,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label, style: AppTextStyles.body.copyWith(color: color, fontWeight: FontWeight.w600)),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------- Datos personales -------------------------
  // Documento y correo NO son editables (son el identificador con el que
  // el conductor quedó registrado, según la ficha). Nombre y teléfono SÍ
  // se pueden modificar.
  Future<void> _mostrarDatosPersonales(BuildContext context) async {
    final resultado = await showModalBottomSheet<_DatosConductor>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DatosPersonalesSheet(datos: _datos),
    );
    if (resultado != null) {
      setState(() {
        _datos.nombres = resultado.nombres;
        _datos.telefono = resultado.telefono;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
            content: Text('Datos actualizados correctamente', style: TextStyle(color: Colors.white)),
          ),
        );
      }
    }
  }

  // ------------------------- Documentos -------------------------
  void _mostrarDocumentos(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _InfoSheet(
        titulo: 'Documentos',
        icono: Icons.description_rounded,
        filas: const [
          _InfoFila('Licencia de conducir', 'Vigente hasta 12/2027', valorColor: AppColors.success),
          _InfoFila('Certificado de antecedentes', 'Vigente hasta 03/2027', valorColor: AppColors.success),
          _InfoFila('Curso de conducción segura', 'Vence en 18 días', valorColor: AppColors.warning),
        ],
      ),
    );
  }

  // ------------------------- Configuración -------------------------
  void _mostrarConfiguracion(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _ConfiguracionSheet(),
    );
  }

  // ------------------------- Cerrar sesión -------------------------
  void _confirmarCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        backgroundColor: AppColors.surface,
        title: const Text('¿Cerrar sesión?', style: AppTextStyles.heading),
        content: const Text(
          'Deberás iniciar sesión de nuevo para volver a recibir servicios.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // TODO: cuando exista pantalla de login/auth, reemplazar esto por:
              // Navigator.of(context).pushAndRemoveUntil(...)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.secondary,
                  content: Text('Sesión cerrada', style: TextStyle(color: Colors.white)),
                ),
              );
            },
            child: const Text('Cerrar sesión', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet de Datos Personales: campos bloqueados vs. editables
// ---------------------------------------------------------------------------

class _DatosPersonalesSheet extends StatefulWidget {
  final _DatosConductor datos;

  const _DatosPersonalesSheet({required this.datos});

  @override
  State<_DatosPersonalesSheet> createState() => _DatosPersonalesSheetState();
}

class _DatosPersonalesSheetState extends State<_DatosPersonalesSheet> {
  late final TextEditingController _nombresController =
      TextEditingController(text: widget.datos.nombres);
  late final TextEditingController _telefonoController =
      TextEditingController(text: widget.datos.telefono);

  @override
  void dispose() {
    _nombresController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  bool get _formularioValido =>
      _nombresController.text.trim().isNotEmpty && _telefonoController.text.trim().length >= 7;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.badge_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Text('Datos personales', style: AppTextStyles.heading.copyWith(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Estos son los datos con los que quedaste registrado. Solo el nombre y el teléfono se pueden modificar.',
              style: AppTextStyles.subheading,
            ),
            const SizedBox(height: 18),

            // ---- Campos NO editables (registro institucional) ----
            _campoBloqueado(
              label: 'Documento de identidad',
              valor: widget.datos.documento,
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 12),
            _campoBloqueado(
              label: 'Correo electrónico',
              valor: widget.datos.correo,
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 18),
            Row(
              children: const [
                Icon(Icons.edit_rounded, size: 14, color: AppColors.secondary),
                SizedBox(width: 6),
                Text('Puedes editar estos datos', style: TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 10),

            // ---- Campos editables ----
            _campoEditable(
              label: 'Nombres y apellidos',
              controller: _nombresController,
              icon: Icons.person_outline_rounded,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 12),
            _campoEditable(
              label: 'Teléfono',
              controller: _telefonoController,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      side: const BorderSide(color: AppColors.secondary),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar', style: AppTextStyles.button),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      disabledBackgroundColor: AppColors.neutral300,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                    ),
                    onPressed: _formularioValido
                        ? () {
                            widget.datos.nombres = _nombresController.text.trim();
                            widget.datos.telefono = _telefonoController.text.trim();
                            Navigator.of(context).pop(widget.datos);
                          }
                        : null,
                    child: const Text('Guardar', style: AppTextStyles.button),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _campoBloqueado({required String label, required String valor, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.neutral500),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                const SizedBox(height: 2),
                Text(valor, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.neutral500),
        ],
      ),
    );
  }

  Widget _campoEditable({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (_) => setState(() {}),
      style: AppTextStyles.body,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: AppColors.secondary),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets de apoyo para los modales de Perfil (Documentos / Configuración)
// ---------------------------------------------------------------------------

class _InfoFila {
  final String label;
  final String valor;
  final Color? valorColor;
  const _InfoFila(this.label, this.valor, {this.valorColor});
}

class _InfoSheet extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final List<_InfoFila> filas;

  const _InfoSheet({required this.titulo, required this.icono, required this.filas});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icono, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Text(titulo, style: AppTextStyles.heading.copyWith(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 18),
          ...filas.map((f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(f.label, style: AppTextStyles.subheading),
                    Text(
                      f.valor,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: f.valorColor ?? AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondary,
                side: const BorderSide(color: AppColors.secondary),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfiguracionSheet extends StatefulWidget {
  const _ConfiguracionSheet();

  @override
  State<_ConfiguracionSheet> createState() => _ConfiguracionSheetState();
}

class _ConfiguracionSheetState extends State<_ConfiguracionSheet> {
  bool _notificaciones = true;
  bool _sonidoSolicitudes = true;
  bool _modoNocturno = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          Text('Configuración', style: AppTextStyles.heading.copyWith(fontSize: 18)),
          const SizedBox(height: 16),
          _switchItem('Notificaciones de servicios', _notificaciones,
              (v) => setState(() => _notificaciones = v)),
          _switchItem('Sonido al recibir solicitudes', _sonidoSolicitudes,
              (v) => setState(() => _sonidoSolicitudes = v)),
          _switchItem('Modo nocturno', _modoNocturno, (v) => setState(() => _modoNocturno = v)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Guardar', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchItem(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.body)),
          Switch(
            value: value,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withOpacity(0.3),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}