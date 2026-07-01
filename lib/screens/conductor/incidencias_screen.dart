import 'package:flutter/material.dart';
import 'utils/app_theme.dart';

/// Reporte de novedades durante el servicio (tráfico, accidentes,
/// dificultades con el vehículo, etc.), con evidencia fotográfica simulada.
class IncidenciasScreen extends StatefulWidget {
  const IncidenciasScreen({super.key});

  @override
  State<IncidenciasScreen> createState() => _IncidenciasScreenState();
}

class _IncidenciasScreenState extends State<IncidenciasScreen> {
  final List<_TipoNovedad> _tipos = const [
    _TipoNovedad('Tráfico', Icons.traffic_rounded, AppColors.warning),
    _TipoNovedad('Accidente', Icons.car_crash_rounded, AppColors.danger),
    _TipoNovedad('Dificultad con el vehículo', Icons.build_circle_rounded, AppColors.secondary),
    _TipoNovedad('Otro', Icons.more_horiz_rounded, AppColors.neutral500),
  ];

  String? _tipoSeleccionado;
  final TextEditingController _descripcionController = TextEditingController();
  bool _evidenciaAdjunta = false;

  static const int _maxCaracteres = 300;

  @override
  void dispose() {
    _descripcionController.dispose();
    super.dispose();
  }

  bool get _formularioValido =>
      _tipoSeleccionado != null && _descripcionController.text.trim().isNotEmpty;

  _TipoNovedad? get _tipoActivo =>
      _tipos.where((t) => t.nombre == _tipoSeleccionado).firstOrNull;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Reportar Novedad', style: AppTextStyles.heading.copyWith(fontSize: 18)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionLabel('Tipo de novedad', Icons.category_rounded),
            const SizedBox(height: 10),
            _buildTiposGrid(),
            const SizedBox(height: 22),
            _buildSectionLabel('Descripción', Icons.notes_rounded),
            const SizedBox(height: 10),
            _buildDescripcion(),
            const SizedBox(height: 22),
            _buildSectionLabel('Evidencia fotográfica', Icons.photo_camera_rounded),
            const SizedBox(height: 10),
            _buildEvidencia(),
            const SizedBox(height: 30),
            _buildBotonEnviar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String texto, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.secondary),
        const SizedBox(width: 8),
        Text(texto, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
      ],
    );
  }

  Widget _buildTiposGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.6,
      children: _tipos.map((tipo) {
        final bool seleccionado = _tipoSeleccionado == tipo.nombre;
        return GestureDetector(
          onTap: () => setState(() => _tipoSeleccionado = tipo.nombre),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: seleccionado ? tipo.color.withOpacity(0.12) : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: seleccionado ? tipo.color : AppColors.divider,
                width: seleccionado ? 1.6 : 1,
              ),
              boxShadow: seleccionado ? [] : AppShadows.card,
            ),
            child: Row(
              children: [
                Icon(tipo.icono, size: 18, color: seleccionado ? tipo.color : AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tipo.nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: seleccionado ? AppColors.textPrimary : AppColors.textSecondary,
                      fontWeight: seleccionado ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDescripcion() {
    final int longitud = _descripcionController.text.length;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _descripcionController,
            maxLines: 4,
            maxLength: _maxCaracteres,
            style: AppTextStyles.body,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(14, 14, 14, 0),
              border: InputBorder.none,
              counterText: '',
              hintText: 'Describe brevemente lo ocurrido...',
              hintStyle: AppTextStyles.subheading,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14, bottom: 8),
            child: Text(
              '$longitud/$_maxCaracteres',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvidencia() {
    return GestureDetector(
      onTap: () => setState(() => _evidenciaAdjunta = !_evidenciaAdjunta),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _evidenciaAdjunta ? AppColors.onSuccessBg : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: _evidenciaAdjunta ? AppColors.success : AppColors.divider,
            width: _evidenciaAdjunta ? 1.6 : 1,
          ),
          boxShadow: _evidenciaAdjunta ? [] : AppShadows.card,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _evidenciaAdjunta
                    ? AppColors.success.withOpacity(0.15)
                    : AppColors.surfaceLight,
              ),
              child: Icon(
                _evidenciaAdjunta ? Icons.check_rounded : Icons.add_a_photo_rounded,
                color: _evidenciaAdjunta ? AppColors.success : AppColors.secondary,
                size: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _evidenciaAdjunta ? 'Evidencia adjuntada' : 'Toca para adjuntar una foto',
              style: AppTextStyles.subheading.copyWith(
                color: _evidenciaAdjunta ? AppColors.success : AppColors.textSecondary,
                fontWeight: _evidenciaAdjunta ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonEnviar() {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: _formularioValido ? AppColors.primaryGradient : null,
          color: _formularioValido ? null : AppColors.neutral300,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: _formularioValido ? AppShadows.button : null,
        ),
        child: ElevatedButton.icon(
          icon: Icon(_formularioValido ? Icons.send_rounded : Icons.lock_outline_rounded, size: 18),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: _formularioValido ? AppColors.onPrimary : AppColors.neutral500,
            padding: const EdgeInsets.symmetric(vertical: 14),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          ),
          onPressed: _formularioValido ? _enviarNovedad : null,
          label: const Text('ENVIAR NOVEDAD', style: AppTextStyles.button),
        ),
      ),
    );
  }

  void _enviarNovedad() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        content: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text('Novedad reportada correctamente', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
    Navigator.of(context).pop();
  }
}

class _TipoNovedad {
  final String nombre;
  final IconData icono;
  final Color color;

  const _TipoNovedad(this.nombre, this.icono, this.color);
}