import 'package:flutter/material.dart';
import 'utils/app_theme.dart';

/// Registro de las 4 fotografías obligatorias del vehículo, según la ficha:
/// vista frontal, vista trasera y dos vistas laterales.
///
/// Esta pantalla se reutiliza en dos momentos del servicio:
///  1) Al recibir el vehículo del cliente (antes de iniciar el viaje).
///  2) Al entregar el vehículo en el destino (verificación final).
///
/// Por ahora es una simulación (no usa cámara real ni backend): al tocar
/// un recuadro se marca como "capturada".
class FotosVehiculoScreen extends StatefulWidget {
  final String titulo;
  final String descripcion;

  const FotosVehiculoScreen({
    super.key,
    this.titulo = 'Fotos del Vehículo',
    this.descripcion =
        'Registra las 4 fotografías del vehículo para verificar su estado.',
  });

  @override
  State<FotosVehiculoScreen> createState() => _FotosVehiculoScreenState();
}

class _FotosVehiculoScreenState extends State<FotosVehiculoScreen> {
  final List<_FotoRequerida> _fotos = [
    _FotoRequerida('Vista Frontal', Icons.airline_seat_recline_normal_rounded),
    _FotoRequerida('Vista Trasera', Icons.airline_seat_recline_extra_rounded),
    _FotoRequerida('Lateral Izquierda', Icons.arrow_back_rounded),
    _FotoRequerida('Lateral Derecha', Icons.arrow_forward_rounded),
  ];

  int get _capturadas => _fotos.where((f) => f.capturada).length;
  bool get _todasCapturadas => _capturadas == _fotos.length;
  double get _progreso => _capturadas / _fotos.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(widget.titulo, style: AppTextStyles.heading.copyWith(fontSize: 18)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        automaticallyImplyLeading: false, // no se puede omitir este paso
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoBanner(),
              const SizedBox(height: 20),
              _buildProgresoHeader(),
              const SizedBox(height: 14),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.95,
                  children: _fotos.map((f) => _buildSlotFoto(f)).toList(),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: _todasCapturadas ? AppColors.primaryGradient : null,
                    color: _todasCapturadas ? null : AppColors.neutral300,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    boxShadow: _todasCapturadas ? AppShadows.button : null,
                  ),
                  child: ElevatedButton.icon(
                    icon: Icon(
                      _todasCapturadas ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
                      size: 18,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: _todasCapturadas ? AppColors.onPrimary : AppColors.neutral500,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                      elevation: 0,
                    ),
                    onPressed: _todasCapturadas ? () => Navigator.of(context).pop(true) : null,
                    label: const Text('CONFIRMAR Y CONTINUAR', style: AppTextStyles.button),
                  ),
                ),
              ),
              // Nota: no hay botón de "cancelar" porque, según la ficha, el
              // registro fotográfico es obligatorio para poder continuar
              // con el servicio (no es un paso opcional).
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.onInfoBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_rounded, color: AppColors.info, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.descripcion,
              style: AppTextStyles.body.copyWith(color: AppColors.secondaryDark, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgresoHeader() {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _progreso),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: AppColors.neutral100,
                color: _todasCapturadas ? AppColors.success : AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$_capturadas/4',
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w700,
            color: _todasCapturadas ? AppColors.success : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSlotFoto(_FotoRequerida foto) {
    return GestureDetector(
      onTap: () => setState(() => foto.capturada = !foto.capturada),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: foto.capturada ? AppColors.onSuccessBg : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: foto.capturada ? AppColors.success : AppColors.divider,
            width: foto.capturada ? 2 : 1,
          ),
          boxShadow: foto.capturada ? [] : AppShadows.card,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: foto.capturada
                          ? AppColors.success.withOpacity(0.15)
                          : AppColors.surfaceLight,
                    ),
                    child: Icon(
                      foto.capturada ? Icons.check_rounded : foto.icono,
                      color: foto.capturada ? AppColors.success : AppColors.secondary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    foto.nombre,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: foto.capturada ? AppColors.textPrimary : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    foto.capturada ? 'Foto capturada' : 'Toca para capturar',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: foto.capturada ? AppColors.success : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (foto.capturada)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FotoRequerida {
  final String nombre;
  final IconData icono;
  bool capturada;

  _FotoRequerida(this.nombre, this.icono, {this.capturada = false});
}