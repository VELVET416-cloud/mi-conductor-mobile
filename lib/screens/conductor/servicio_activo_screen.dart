import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'home_conductor_screen.dart';
import 'fotos_vehiculo_screen.dart';
import 'incidencias_screen.dart';

/// Etapas del servicio, siguiendo el orden que exige la ficha:
/// 1. asignado          -> el servicio ya fue asignado (no se puede rechazar)
/// 2. fotosRecepcion     -> registro fotográfico al recibir el vehículo
/// 3. listoParaIniciar  -> fotos de recepción completas, falta iniciar viaje
/// 4. enRuta            -> viaje iniciado, se muestra la ruta al destino
/// 5. fotosEntrega       -> registro fotográfico al entregar el vehículo
/// 6. finalizado         -> servicio completado
enum _EtapaServicio {
  asignado,
  fotosRecepcion,
  listoParaIniciar,
  enRuta,
  fotosEntrega,
  finalizado,
}

class ServicioActivoScreen extends StatefulWidget {
  final SolicitudServicio servicio;

  const ServicioActivoScreen({super.key, required this.servicio});

  @override
  State<ServicioActivoScreen> createState() => _ServicioActivoScreenState();
}

class _ServicioActivoScreenState extends State<ServicioActivoScreen> {
  _EtapaServicio _etapa = _EtapaServicio.asignado;

  // Índice del paso "visible" del stepper (0..3), agrupando las sub-etapas
  // de fotos con su paso principal para no saturar la barra de progreso.
  int get _pasoActual {
    switch (_etapa) {
      case _EtapaServicio.asignado:
      case _EtapaServicio.fotosRecepcion:
        return 0;
      case _EtapaServicio.listoParaIniciar:
        return 1;
      case _EtapaServicio.enRuta:
      case _EtapaServicio.fotosEntrega:
        return 2;
      case _EtapaServicio.finalizado:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Servicio Asignado', style: AppTextStyles.heading.copyWith(fontSize: 18)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        // No se permite salir del servicio una vez asignado (no hay opción de rechazo).
        automaticallyImplyLeading: _etapa == _EtapaServicio.finalizado,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildStepper(),
            const SizedBox(height: 18),
            _buildClienteCard(),
            const SizedBox(height: 16),
            _buildMapaPlaceholder(),
            const SizedBox(height: 16),
            _buildEtapaContenido(),
            const SizedBox(height: 16),
            if (_etapa != _EtapaServicio.finalizado) _buildReportarNovedadButton(),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------
  // STEPPER DE PROGRESO
  // --------------------------------------------------------------------

  Widget _buildStepper() {
    final pasos = ['Recogida', 'Inicio', 'En ruta', 'Entrega'];
    return Row(
      children: List.generate(pasos.length, (i) {
        final bool completado = i < _pasoActual;
        final bool activo = i == _pasoActual;
        final Color color = completado || activo ? AppColors.primary : AppColors.neutral300;

        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: completado ? AppColors.primary : AppColors.surface,
                      border: Border.all(color: color, width: 2),
                      boxShadow: activo ? AppShadows.button : null,
                    ),
                    child: Center(
                      child: completado
                          ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                          : Text(
                              '${i + 1}',
                              style: TextStyle(
                                color: activo ? AppColors.primary : AppColors.neutral500,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pasos[i],
                    style: AppTextStyles.caption.copyWith(
                      color: activo ? AppColors.textPrimary : AppColors.textSecondary,
                      fontWeight: activo ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (i != pasos.length - 1)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    height: 2,
                    color: completado ? AppColors.primary : AppColors.neutral300,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildClienteCard() {
    final s = widget.servicio;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceLight,
              border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
            ),
            child: const Icon(Icons.person_rounded, color: AppColors.secondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.cliente, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(s.tipo,
                      style: const TextStyle(color: AppColors.primaryDark, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          Text('\$${s.precio.toStringAsFixed(2)}',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 17)),
        ],
      ),
    );
  }

  Widget _buildMapaPlaceholder() {
    final bool enRuta = _etapa == _EtapaServicio.enRuta;
    return Container(
      height: 160,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: enRuta ? AppColors.secondaryGradient : null,
        color: enRuta ? null : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: enRuta ? AppShadows.card : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            enRuta ? Icons.alt_route_rounded : Icons.map_rounded,
            color: enRuta ? Colors.white : AppColors.textSecondary,
            size: 36,
          ),
          const SizedBox(height: 10),
          Text(
            enRuta ? 'Ruta completa hacia el destino (simulada)' : 'Vista de mapa / ruta (simulada)',
            style: enRuta
                ? AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600)
                : AppTextStyles.subheading,
          ),
        ],
      ),
    );
  }

  Widget _buildEtapaContenido() {
    switch (_etapa) {
      case _EtapaServicio.asignado:
        return _pasoAsignado();
      case _EtapaServicio.fotosRecepcion:
        return _pasoAsignado(bloqueado: true);
      case _EtapaServicio.listoParaIniciar:
        return _pasoListoParaIniciar();
      case _EtapaServicio.enRuta:
        return _pasoEnRuta();
      case _EtapaServicio.fotosEntrega:
        return _pasoEnRuta(bloqueado: true);
      case _EtapaServicio.finalizado:
        return _pasoFinalizado();
    }
  }

  Widget _pasoAsignado({bool bloqueado = false}) {
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
          _avisoAsignacion(),
          const SizedBox(height: 16),
          _pasoTitulo('Punto de recogida', Icons.trip_origin, AppColors.success),
          const SizedBox(height: 8),
          Text(widget.servicio.origen, style: AppTextStyles.body),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.schedule_rounded, size: 14, color: AppColors.textSecondary),
              SizedBox(width: 6),
              Text('Tiempo estimado de llegada: 8 min', style: AppTextStyles.subheading),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.pin_drop_rounded, size: 18),
              style: _botonPrincipalStyle(disabled: bloqueado),
              onPressed: bloqueado ? null : _heLlegadoAlPuntoDeRecogida,
              label: const Text('HE LLEGADO AL PUNTO DE RECOGIDA', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avisoAsignacion() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.onInfoBg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_rounded, color: AppColors.info, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Este servicio fue asignado automáticamente y debe realizarse.',
              style: TextStyle(color: AppColors.secondaryDark, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pasoListoParaIniciar() {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.onSuccessBg,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.check_rounded, color: AppColors.success, size: 16),
              ),
              const SizedBox(width: 10),
              Text('Fotos de recepción completas',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('El vehículo quedó registrado. Ya puedes iniciar el viaje.',
              style: AppTextStyles.subheading),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              style: _botonPrincipalStyle(),
              onPressed: _iniciarViaje,
              label: const Text('INICIAR VIAJE', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pasoEnRuta({bool bloqueado = false}) {
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
          _pasoTitulo('Destino', Icons.location_on_rounded, AppColors.danger),
          const SizedBox(height: 8),
          Text(widget.servicio.destino, style: AppTextStyles.body),
          const SizedBox(height: 8),
          Row(
            children: const [
              _PulsingDot(),
              SizedBox(width: 8),
              Text('Servicio en curso...', style: AppTextStyles.subheading),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.flag_rounded, size: 18),
              style: _botonPrincipalStyle(disabled: bloqueado),
              onPressed: bloqueado ? null : _confirmarLlegadaDestino,
              label: const Text('CONFIRMAR LLEGADA AL DESTINO', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pasoFinalizado() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(color: AppColors.onSuccessBg, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: AppColors.success, size: 34),
          ),
          const SizedBox(height: 14),
          Text('Servicio finalizado con éxito',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 4),
          const Text('Fotos de entrega registradas correctamente.',
              style: AppTextStyles.subheading, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.home_rounded, size: 18),
              style: _botonPrincipalStyle(),
              onPressed: () => Navigator.of(context).pop(),
              label: const Text('VOLVER AL INICIO', style: AppTextStyles.button),
            ),
          ),
          const SizedBox(height: 10),
          _buildReportarNovedadButton(),
        ],
      ),
    );
  }

  Widget _pasoTitulo(String texto, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Text(texto, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildReportarNovedadButton() {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.danger,
        side: const BorderSide(color: AppColors.danger, width: 1.2),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        minimumSize: const Size(double.infinity, 46),
      ),
      onPressed: _reportarNovedad,
      icon: const Icon(Icons.report_problem_rounded, size: 18),
      label: const Text('Reportar novedad', style: AppTextStyles.button),
    );
  }

  ButtonStyle _botonPrincipalStyle({bool disabled = false}) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      disabledBackgroundColor: AppColors.neutral300,
      disabledForegroundColor: AppColors.neutral500,
      padding: const EdgeInsets.symmetric(vertical: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
    );
  }

  // Paso 1: al llegar al punto de recogida, se deben tomar las 4 fotos
  // de RECEPCIÓN del vehículo antes de poder iniciar el viaje.
  Future<void> _heLlegadoAlPuntoDeRecogida() async {
    setState(() => _etapa = _EtapaServicio.fotosRecepcion);
    final bool? completadas = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const FotosVehiculoScreen(
          titulo: 'Recepción del Vehículo',
          descripcion:
              'Registra las 4 fotografías del vehículo antes de iniciar el viaje (frontal, trasera y ambos laterales).',
        ),
      ),
    );
    setState(() {
      _etapa = completadas == true ? _EtapaServicio.listoParaIniciar : _EtapaServicio.asignado;
    });
  }

  // Paso 2: una vez completadas las fotos de recepción, el conductor
  // puede iniciar el viaje. Aquí se despliega la ruta hacia el destino.
  void _iniciarViaje() {
    setState(() => _etapa = _EtapaServicio.enRuta);
  }

  // Paso 3: al confirmar la llegada al destino, se deben tomar otras
  // 4 fotos de ENTREGA para verificar el estado final del vehículo.
  Future<void> _confirmarLlegadaDestino() async {
    setState(() => _etapa = _EtapaServicio.fotosEntrega);
    final bool? completadas = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const FotosVehiculoScreen(
          titulo: 'Entrega del Vehículo',
          descripcion:
              'Registra las 4 fotografías del vehículo al momento de la entrega (frontal, trasera y ambos laterales).',
        ),
      ),
    );
    setState(() {
      _etapa = completadas == true ? _EtapaServicio.finalizado : _EtapaServicio.enRuta;
    });
  }

  Future<void> _reportarNovedad() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const IncidenciasScreen()),
    );
  }
}

/// Punto pulsante para indicar "servicio en curso" en tiempo real.
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.4, end: 1.0).animate(_controller),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(color: AppColors.warning, shape: BoxShape.circle),
      ),
    );
  }
}