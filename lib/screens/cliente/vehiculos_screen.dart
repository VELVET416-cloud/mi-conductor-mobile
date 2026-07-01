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
  static const Color textHint = Colors.white54;
  static const Color divider = Color(0x14FFFFFF);
}

// ===========================================================
// Modelo de vehículo, según ficha (Subproceso Gestión de
// Vehículos del Cliente): marca, modelo, placa, chasis, color
// y foto.
// ===========================================================
class Vehiculo {
  String marca;
  String modelo;
  String placa;
  String chasis;
  String color;
  String anio;
  bool tieneFoto;

  Vehiculo({
    required this.marca,
    required this.modelo,
    required this.placa,
    required this.chasis,
    required this.color,
    required this.anio,
    this.tieneFoto = false,
  });

  String get nombre => "$marca $modelo";
}

class VehiculosScreen extends StatefulWidget {
  const VehiculosScreen({super.key});

  @override
  State<VehiculosScreen> createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  final List<Vehiculo> _vehiculos = [
    Vehiculo(
      marca: "Mazda",
      modelo: "2",
      placa: "ABC123",
      chasis: "9F2BX003912",
      color: "Gris",
      anio: "2022",
      tieneFoto: true,
    ),
    Vehiculo(
      marca: "Kia",
      modelo: "Picanto",
      placa: "XYZ456",
      chasis: "8KP1A990221",
      color: "Blanco",
      anio: "2023",
      tieneFoto: true,
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
          "Mis Vehículos",
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
            child: _vehiculos.isEmpty
                ? _buildEmptyState()
                : ListView(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      MediaQuery.of(context).padding.top > 0 ? 12 : 100,
                      20,
                      100,
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Vehículos registrados",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${_vehiculos.length}",
                              style: const TextStyle(
                                color: AppColors.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(_vehiculos.length, (index) {
                        final v = _vehiculos[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _VehiculoCard(
                            vehiculo: v,
                            onEditar: () =>
                                _abrirFormulario(vehiculo: v, index: index),
                            onEliminar: () => _confirmarEliminar(index),
                          ),
                        );
                      }),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        elevation: 4,
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add, color: Colors.black87),
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
              child: Icon(Icons.directions_car_outlined,
                  size: 38, color: AppColors.textSecondary.withOpacity(0.7)),
            ),
            const SizedBox(height: 18),
            const Text(
              "Aún no tienes vehículos registrados",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _abrirFormulario(),
              icon: const Icon(Icons.add, color: Colors.black87),
              label: const Text(
                "Agregar vehículo",
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Confirmación de eliminado ----------------
  void _confirmarEliminar(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Eliminar vehículo",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          "¿Deseas eliminar ${_vehiculos[index].nombre} (${_vehiculos[index].placa})?",
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar",
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              setState(() => _vehiculos.removeAt(index));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Vehículo eliminado")),
              );
            },
            child: const Text("Eliminar",
                style: TextStyle(color: Color(0xFFFF6B6B))),
          ),
        ],
      ),
    );
  }

  // ---------------- Formulario de agregar / editar ----------------
  void _abrirFormulario({Vehiculo? vehiculo, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _VehiculoFormSheet(
        vehiculo: vehiculo,
        onGuardar: (nuevo) {
          setState(() {
            if (index != null) {
              _vehiculos[index] = nuevo;
            } else {
              _vehiculos.add(nuevo);
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                index != null ? "Vehículo actualizado" : "Vehículo agregado",
              ),
            ),
          );
        },
      ),
    );
  }
}

// ===========================================================
// Tarjeta de vehículo con menú de acciones (Editar / Eliminar)
// ===========================================================
class _VehiculoCard extends StatelessWidget {
  final Vehiculo vehiculo;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const _VehiculoCard({
    required this.vehiculo,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  vehiculo.tieneFoto
                      ? Icons.directions_car
                      : Icons.no_photography_outlined,
                  size: 28,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehiculo.nombre,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Placa ${vehiculo.placa}",
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                color: AppColors.field,
                icon: const Icon(Icons.more_vert,
                    color: AppColors.textSecondary),
                onSelected: (value) {
                  if (value == "editar") onEditar();
                  if (value == "eliminar") onEliminar();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: "editar",
                    child: Text("Editar",
                        style: TextStyle(color: AppColors.textPrimary)),
                  ),
                  PopupMenuItem(
                    value: "eliminar",
                    child: Text("Eliminar",
                        style: TextStyle(color: Color(0xFFFF6B6B))),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white12, height: 1),
          ),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  icon: Icons.palette_outlined,
                  label: "Color",
                  value: vehiculo.color,
                ),
              ),
              Expanded(
                child: _InfoItem(
                  icon: Icons.calendar_today_outlined,
                  label: "Año",
                  value: vehiculo.anio,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _InfoItem(
            icon: Icons.confirmation_number_outlined,
            label: "Chasis",
            value: vehiculo.chasis,
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
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
}

// ===========================================================
// Formulario funcional para registrar/editar un vehículo,
// según los campos que exige la ficha:
// marca, modelo, placa, número de chasis, color y foto.
// ===========================================================
class _VehiculoFormSheet extends StatefulWidget {
  final Vehiculo? vehiculo;
  final ValueChanged<Vehiculo> onGuardar;

  const _VehiculoFormSheet({
    this.vehiculo,
    required this.onGuardar,
  });

  @override
  State<_VehiculoFormSheet> createState() => _VehiculoFormSheetState();
}

class _VehiculoFormSheetState extends State<_VehiculoFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final marcaController =
      TextEditingController(text: widget.vehiculo?.marca ?? "");
  late final modeloController =
      TextEditingController(text: widget.vehiculo?.modelo ?? "");
  late final placaController =
      TextEditingController(text: widget.vehiculo?.placa ?? "");
  late final chasisController =
      TextEditingController(text: widget.vehiculo?.chasis ?? "");
  late final colorController =
      TextEditingController(text: widget.vehiculo?.color ?? "");
  late final anioController =
      TextEditingController(text: widget.vehiculo?.anio ?? "");

  bool _fotoAgregada = false;

  @override
  void initState() {
    super.initState();
    _fotoAgregada = widget.vehiculo?.tieneFoto ?? false;
  }

  @override
  void dispose() {
    marcaController.dispose();
    modeloController.dispose();
    placaController.dispose();
    chasisController.dispose();
    colorController.dispose();
    anioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool esEdicion = widget.vehiculo != null;

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
          child: Form(
            key: _formKey,
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
                  esEdicion ? "Editar vehículo" : "Registrar vehículo",
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                _buildFotoPicker(),

                const SizedBox(height: 16),
                _buildField("Marca", marcaController),
                const SizedBox(height: 12),
                _buildField("Modelo", modeloController),
                const SizedBox(height: 12),
                _buildField("Placa", placaController, capitalize: true),
                const SizedBox(height: 12),
                _buildField("Color", colorController),
                const SizedBox(height: 12),
                _buildField("Año", anioController,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                _buildField("Número de chasis", chasisController),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _guardar,
                    child: Text(
                      esEdicion ? "Guardar cambios" : "Registrar vehículo",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFotoPicker() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // Simula la captura/selección de foto exigida por la
        // ficha para el registro del vehículo.
        setState(() => _fotoAgregada = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Foto del vehículo agregada")),
        );
      },
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.field,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _fotoAgregada
                ? AppColors.accent
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _fotoAgregada ? Icons.check_circle : Icons.add_a_photo_outlined,
              color: AppColors.accent,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              _fotoAgregada ? "Foto agregada" : "Agregar foto del vehículo",
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    bool capitalize = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization:
          capitalize ? TextCapitalization.characters : TextCapitalization.none,
      style: const TextStyle(color: AppColors.textPrimary),
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? "Campo requerido" : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.field,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
        ),
      ),
    );
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    if (!_fotoAgregada) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debes agregar una foto del vehículo"),
        ),
      );
      return;
    }

    widget.onGuardar(
      Vehiculo(
        marca: marcaController.text.trim(),
        modelo: modeloController.text.trim(),
        placa: placaController.text.trim().toUpperCase(),
        chasis: chasisController.text.trim(),
        color: colorController.text.trim(),
        anio: anioController.text.trim(),
        tieneFoto: _fotoAgregada,
      ),
    );
    Navigator.pop(context);
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