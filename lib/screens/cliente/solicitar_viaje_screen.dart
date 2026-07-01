import 'package:flutter/material.dart';
import 'esperando_asignacion_screen.dart';

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
  static const Color success = Color(0xFF4CAF50);
}

// Modelo de Vehículo según los campos de la Ficha Técnica
class Vehiculo {
  final String marca;
  final String modelo;
  final String placa;
  final String chasis;
  final String color;
  final IconData icon;

  const Vehiculo({
    required this.marca,
    required this.modelo,
    required this.placa,
    required this.chasis,
    required this.color,
    this.icon = Icons.directions_car_filled_outlined,
  });

  String get descripcionCorta => "$marca $modelo • $placa";
  String get detalleCompleto => "$color | Chasis: $chasis";
}

class SolicitarViajeScreen extends StatefulWidget {
  const SolicitarViajeScreen({super.key});

  @override
  State<SolicitarViajeScreen> createState() => _SolicitarViajeScreenState();
}

class _SolicitarViajeScreenState extends State<SolicitarViajeScreen> {
  final _formKey = GlobalKey<FormState>();

  final origenController = TextEditingController();
  final destinoController = TextEditingController();
  final observacionController = TextEditingController();

  // Lista de vehículos registrados del cliente (según el subproceso de Gestión de Vehículos)
  final List<Vehiculo> _misVehiculos = [
    const Vehiculo(
      marca: "Mazda",
      modelo: "2",
      placa: "ABC123",
      chasis: "9JK32H84F012356",
      color: "Gris Metálico",
      icon: Icons.directions_car,
    ),
    const Vehiculo(
      marca: "Kia",
      modelo: "Picanto",
      placa: "XYZ456",
      chasis: "8HG21K93L405928",
      color: "Rojo Cereza",
      icon: Icons.directions_car,
    ),
  ];

  late Vehiculo _vehiculoSeleccionado;
  String _metodoPago = "Efectivo";
  double _tarifaEstimada = 0.0;

  @override
  void initState() {
    super.initState();
    _vehiculoSeleccionado = _misVehiculos.first;

    // Escuchar cambios para calcular tarifa estimativa en tiempo real
    origenController.addListener(_actualizarTarifa);
    destinoController.addListener(_actualizarTarifa);
  }

  @override
  void dispose() {
    origenController.dispose();
    destinoController.dispose();
    observacionController.dispose();
    super.dispose();
  }

  void _actualizarTarifa() {
    final ori = origenController.text.trim();
    final dest = destinoController.text.trim();

    if (ori.isEmpty || dest.isEmpty) {
      setState(() {
        _tarifaEstimada = 0.0;
      });
      return;
    }

    // Algoritmo de tarifa simulada en base a la longitud de direcciones
    double base = 18000.0; // Tarifa básica de conductor elegido
    double distanciaSimulada = (ori.length + dest.length) * 0.25; // km simulados
    double tarifaCalculada = base + (distanciaSimulada * 1200); // base + $1200 por km

    setState(() {
      _tarifaEstimada = tarifaCalculada;
    });
  }

  // Abre un Bottom Sheet estilizado para seleccionar el vehículo sin errores de desbordamiento (overflow)
  void _mostrarSelectorVehiculos() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.directions_car_outlined, color: AppColors.accent, size: 22),
                  SizedBox(width: 8),
                  Text(
                    "Selecciona tu Vehículo",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                "Escoge el auto registrado en el cual el conductor realizará el servicio.",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 18),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _misVehiculos.length,
                  itemBuilder: (context, index) {
                    final v = _misVehiculos[index];
                    final esSeleccionado = v.placa == _vehiculoSeleccionado.placa;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: esSeleccionado ? AppColors.accent.withOpacity(0.1) : AppColors.field,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: esSeleccionado ? AppColors.accent : Colors.white.withOpacity(0.04),
                          width: esSeleccionado ? 1.5 : 1.0,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.directions_car, color: AppColors.accent, size: 20),
                        ),
                        title: Text(
                          v.descripcionCorta,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          v.detalleCompleto,
                          style: const TextStyle(color: AppColors.textHint, fontSize: 11),
                        ),
                        trailing: esSeleccionado
                            ? const Icon(Icons.check_circle, color: AppColors.accent)
                            : null,
                        onTap: () {
                          setState(() {
                            _vehiculoSeleccionado = v;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Solicitar Conductor",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Mapa de fondo sutil para contextualizar movilidad
          const Positioned.fill(child: _DarkMapBackground()),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withOpacity(0.4),
                    AppColors.background.withOpacity(0.92),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubHeader(),
                    const SizedBox(height: 18),
                    
                    // Tarjeta Principal del Formulario
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppColors.divider),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- INDICADOR DE RUTA (ORIGEN Y DESTINO CONECTADOS) ---
                          const _SectionHeader(title: "Ruta del Servicio", icon: Icons.map_outlined),
                          const SizedBox(height: 14),
                          _buildRutaCampos(),
                          const SizedBox(height: 24),

                          // --- VEHÍCULO DEL CLIENTE ---
                          const _SectionHeader(title: "Vehículo para el Servicio", icon: Icons.directions_car_outlined),
                          const SizedBox(height: 12),
                          _buildVehiculoSelector(),
                          const SizedBox(height: 24),

                          // --- MÉTODO DE PAGO ---
                          const _SectionHeader(title: "Método de Pago", icon: Icons.payment_outlined),
                          const SizedBox(height: 12),
                          _buildMetodoPagoSelector(),
                          const SizedBox(height: 24),

                          // --- OBSERVACIONES ---
                          const _SectionHeader(title: "Instrucciones Especiales", icon: Icons.edit_note_outlined),
                          const SizedBox(height: 12),
                          _StyledTextField(
                            controller: observacionController,
                            hintText: "Ej: Llaves en recepción, parqueadero subterráneo...",
                            icon: Icons.notes_outlined,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 28),

                          // --- RESUMEN Y TARIFA ---
                          if (_tarifaEstimada > 0) ...[
                            _buildResumenTarifa(),
                            const SizedBox(height: 20),
                          ],

                          // --- BOTÓN DE CONFIRMACIÓN ---
                          _buildSubmitButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "GO DRIVER",
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "• Conductor Elegido",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          "Solicita un chofer profesional para que conduzca tu auto de forma segura.",
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  // Layout elegante para conectar Origen y Destino de forma visual
  Widget _buildRutaCampos() {
    return Stack(
      children: [
        // Línea vertical punteada de conexión
        Positioned(
          left: 27,
          top: 36,
          bottom: 36,
          child: Column(
            children: List.generate(
              6,
              (index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                width: 2,
                height: 4,
                color: AppColors.textHint.withOpacity(0.4),
              ),
            ),
          ),
        ),
        Column(
          children: [
            _StyledTextField(
              controller: origenController,
              hintText: "Punto de recogida (Dirección actual)",
              icon: Icons.circle,
              iconColor: AppColors.success,
              validatorMsg: "Ingresa el punto de recogida",
            ),
            const SizedBox(height: 14),
            _StyledTextField(
              controller: destinoController,
              hintText: "¿A dónde nos dirigimos?",
              icon: Icons.location_on,
              iconColor: AppColors.accent,
              validatorMsg: "Ingresa el destino del viaje",
            ),
          ],
        ),
      ],
    );
  }

  // Selector visual interactivo de vehículos personalizado (Sin Dropdown para evitar desbordamientos)
  Widget _buildVehiculoSelector() {
    return InkWell(
      onTap: _mostrarSelectorVehiculos,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.field,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.04)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions_car, color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _vehiculoSeleccionado.descripcionCorta,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _vehiculoSeleccionado.detalleCompleto,
                    style: TextStyle(
                      color: AppColors.textHint.withOpacity(0.8),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.accent, size: 20),
          ],
        ),
      ),
    );
  }

  // Selector en botones tipo chip horizontales elegantes
  Widget _buildMetodoPagoSelector() {
    final metodos = [
      {"nombre": "Efectivo", "icon": Icons.money},
      {"nombre": "Tarjeta (**** 4321)", "icon": Icons.credit_card},
    ];

    return Row(
      children: metodos.map((metodo) {
        final esSeleccionado = _metodoPago == metodo["nombre"];
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _metodoPago = metodo["nombre"] as String;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: esSeleccionado ? AppColors.accent.withOpacity(0.15) : AppColors.field,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: esSeleccionado ? AppColors.accent : Colors.white.withOpacity(0.04),
                  width: esSeleccionado ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    metodo["icon"] as IconData,
                    color: esSeleccionado ? AppColors.accent : AppColors.textHint,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    metodo["nombre"] as String == "Efectivo" ? "Efectivo" : "Tarjeta",
                    style: TextStyle(
                      color: esSeleccionado ? AppColors.textPrimary : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: esSeleccionado ? FontWeight.bold : FontWeight.normal,
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

  // Panel elegante que muestra el cálculo de tarifa estimada y tiempo
  Widget _buildResumenTarifa() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Valor Estimado",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Conductor Asegurado 24/7",
                style: TextStyle(
                  color: AppColors.textHint,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          Text(
            "\$${_tarifaEstimada.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Botón de confirmación y solicitud
  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.black87,
          elevation: 6,
          shadowColor: AppColors.accent.withOpacity(0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: _enviarSolicitud,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch_outlined, color: Colors.black87, size: 20),
            SizedBox(width: 10),
            Text(
              "Solicitar Conductor Ahora",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _enviarSolicitud() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ingresa la dirección de origen y destino"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (origenController.text.trim().toLowerCase() ==
        destinoController.text.trim().toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("El origen y el destino no pueden ser idénticos"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EsperandoAsignacionScreen(),
      ),
    );
  }
}

// ===========================================================
// Sub-cabeceras de sección con íconos
// ===========================================================
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary.withOpacity(0.8), size: 16),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 11,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

// ===========================================================
// Campo de texto estilizado reutilizable con soporte de íconos
// ===========================================================
class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Color? iconColor;
  final int maxLines;
  final String? validatorMsg;

  const _StyledTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.iconColor,
    this.maxLines = 1,
    this.validatorMsg,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      validator: validatorMsg == null
          ? null
          : (value) => (value == null || value.trim().isEmpty)
              ? validatorMsg
              : null,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.textHint.withOpacity(0.6), fontSize: 14),
        filled: true,
        fillColor: AppColors.field,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? 22 : 0),
          child: Icon(
            icon,
            color: iconColor ?? AppColors.accent.withOpacity(0.8),
            size: icon == Icons.circle ? 10 : 20,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
        ),
      ),
    );
  }
}

// ===========================================================
// Fondo de mapa oscuro dibujado en CustomPaint
// ===========================================================
class _DarkMapBackground extends StatelessWidget {
  const _DarkMapBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.background),
      child: CustomPaint(painter: _DarkMapPainter(), size: Size.infinite),
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
      ..color = Colors.white.withOpacity(0.02)
      ..strokeWidth = 1;
    const spacing = 36.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final roadPaintAccent = Paint()
      ..color = AppColors.accent.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    Path road1 = Path()
      ..moveTo(-20, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.1, size.width * 0.6, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.45, size.width + 20, size.height * 0.35);
    canvas.drawPath(road1, roadPaint);

    Path road2 = Path()
      ..moveTo(-20, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.5, size.width * 0.55, size.height * 0.65)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.8, size.width + 20, size.height * 0.68);
    canvas.drawPath(road2, roadPaintAccent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}