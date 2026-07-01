import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
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
class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}
class _PerfilScreenState extends State<PerfilScreen> {
  // Datos del cliente (según la Ficha Técnica del Proyecto Formativo "Mi Conductor")
  String _nombre = "Juan David Rivera Castillo";
  String _correo = "juandavidriveracastillo@gmail.com";
  String _telefono = "3145439798";
  String _direccion = "Cartagena de Indias, Barrio Prado";
  String _empresa = "Go Driver";
  bool _notificaciones = true;
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
          "Mi Perfil",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
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
                    AppColors.background.withOpacity(0.45),
                    AppColors.background.withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).padding.top > 0 ? 12 : 100,
                20,
                24,
              ),
              children: [
                _buildHeader(),
                const SizedBox(height: 28),
                const Text(
                  "Cuenta",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 10),
                _buildInfoCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // ---------------- Encabezado con avatar ----------------
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: const CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.accent,
              child: Icon(Icons.person, size: 52, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _nombre,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _correo,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _telefono,
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
  // ---------------- Tarjeta de opciones ----------------
  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _ProfileOption(
            icon: Icons.person_outline,
            label: "Datos personales",
            onTap: _editarDatosPersonales,
          ),
          const _OptionDivider(),
          _ProfileOption(
            icon: Icons.lock_outline,
            label: "Seguridad",
            onTap: _cambiarContrasena,
          ),
          const _OptionDivider(),
          _ProfileOption(
            icon: Icons.notifications_none,
            label: "Notificaciones",
            trailing: Switch(
              value: _notificaciones,
              activeColor: AppColors.accent,
              onChanged: (value) {
                setState(() => _notificaciones = value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? "Notificaciones activadas"
                          : "Notificaciones desactivadas",
                    ),
                  ),
                );
              },
            ),
            onTap: () => setState(() => _notificaciones = !_notificaciones),
          ),
          const _OptionDivider(),
          _ProfileOption(
            icon: Icons.help_outline,
            label: "Ayuda y soporte",
            onTap: _abrirAyuda,
          ),
          const _OptionDivider(),
          _ProfileOption(
            icon: Icons.logout,
            label: "Cerrar sesión",
            isDestructive: true,
            onTap: _confirmarCerrarSesion,
          ),
        ],
      ),
    );
  }
  // ---------------- Editar datos personales (Elegante BottomSheet) ----------------
  void _editarDatosPersonales() {
    final nombreController = TextEditingController(text: _nombre);
    final telefonoController = TextEditingController(text: _telefono);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 14,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tirador superior táctil
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
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Icon(Icons.badge_outlined, color: AppColors.accent, size: 24),
                    SizedBox(width: 10),
                    Text(
                      "Datos Personales",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Aquí se muestran tus datos de registro. Puedes modificar tu nombre y número de teléfono.",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                
                // --- SECCIÓN 1: CAMPOS MODIFICABLES ---
                const Text(
                  "CAMPOS EDITABLES",
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nombreController,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  decoration: _dialogFieldDecoration("Nombre Completo", Icons.person_outline),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: telefonoController,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  keyboardType: TextInputType.phone,
                  decoration: _dialogFieldDecoration("Número de Teléfono", Icons.phone_outlined),
                ),
                const SizedBox(height: 24),
                // --- SECCIÓN 2: DATOS DE REGISTRO (SOLO LECTURA) ---
                const Text(
                  "INFORMACIÓN DE REGISTRO (SOLO LECTURA)",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                _buildReadOnlyField("Correo Electrónico", _correo, Icons.email_outlined),
                const SizedBox(height: 10),
                _buildReadOnlyField("Dirección", _direccion, Icons.location_on_outlined),
                const SizedBox(height: 10),
                _buildReadOnlyField("Empresa", _empresa, Icons.business_outlined),
                const SizedBox(height: 30),
                // --- BOTONES DE ACCIÓN ---
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.divider),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          final nuevoNombre = nombreController.text.trim();
                          final nuevoTelefono = telefonoController.text.trim();
                          if (nuevoNombre.isEmpty || nuevoTelefono.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("El nombre y el teléfono no pueden estar vacíos"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }
                          setState(() {
                            _nombre = nuevoNombre;
                            _telefono = nuevoTelefono;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Datos actualizados"),
                              backgroundColor: AppColors.surface,
                            ),
                          );
                        },
                        child: const Text(
                          "Guardar",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // Widget personalizado para mostrar información de registro de solo lectura
  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.field.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary.withOpacity(0.5), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textHint.withOpacity(0.6),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.lock_outline,
            color: AppColors.textHint.withOpacity(0.3),
            size: 15,
          ),
        ],
      ),
    );
  }
  // ---------------- Cambiar contraseña (funcional, con validación e íconos) ----------------
  void _cambiarContrasena() {
    final actualController = TextEditingController();
    final nuevaController = TextEditingController();
    final confirmarController = TextEditingController();
    String? error;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Cambiar contraseña",
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: actualController,
                obscureText: true,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _dialogFieldDecoration("Contraseña actual", Icons.lock_outline),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nuevaController,
                obscureText: true,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _dialogFieldDecoration("Nueva contraseña", Icons.lock_reset),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmarController,
                obscureText: true,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _dialogFieldDecoration("Confirmar contraseña", Icons.lock_person_outlined),
              ),
              if (error != null) ...[
                const SizedBox(height: 10),
                Text(
                  error!,
                  style: const TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                if (actualController.text.isEmpty ||
                    nuevaController.text.isEmpty) {
                  setStateDialog(() => error = "Completa todos los campos");
                  return;
                }
                if (nuevaController.text.length < 6) {
                  setStateDialog(
                    () => error =
                        "La nueva contraseña debe tener mínimo 6 caracteres",
                  );
                  return;
                }
                if (nuevaController.text != confirmarController.text) {
                  setStateDialog(() => error = "Las contraseñas no coinciden");
                  return;
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Contraseña actualizada correctamente"),
                  ),
                );
              },
              child: const Text(
                "Guardar",
                style: TextStyle(color: AppColors.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // ---------------- Ayuda y soporte (funcional) ----------------
  void _abrirAyuda() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ayuda y soporte",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const _SoporteItem(
              icon: Icons.phone_outlined,
              text: "Línea de soporte: 314 543 9798",
            ),
            const SizedBox(height: 12),
            const _SoporteItem(
              icon: Icons.email_outlined,
              text: "soporte@godriver.com",
            ),
            const SizedBox(height: 12),
            const _SoporteItem(
              icon: Icons.chat_bubble_outline,
              text: "Chat en vivo disponible 24/7",
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Tu solicitud de soporte fue enviada"),
                    ),
                  );
                },
                child: const Text(
                  "Contactar soporte",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // ---------------- Cerrar sesión (funcional) ----------------
  void _confirmarCerrarSesion() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Cerrar sesión",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          "¿Seguro qué deaseas cerrar sesión?",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              "Cerrar sesión",
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    );
  }
  InputDecoration _dialogFieldDecoration(String label, [IconData? icon]) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      filled: true,
      fillColor: AppColors.field,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.accent.withOpacity(0.8), size: 20) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
    );
  }
}
// ===========================================================
// Opción de perfil (fila reutilizable dentro de la tarjeta)
// ===========================================================
class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  final VoidCallback onTap;
  final Widget? trailing;
  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.trailing,
  });
  @override
  Widget build(BuildContext context) {
    final Color color = isDestructive
        ? const Color(0xFFFF6B6B)
        : AppColors.textPrimary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: (isDestructive ? color : AppColors.accent).withOpacity(
                    0.12,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isDestructive ? color : AppColors.accent,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (trailing != null)
                trailing!
              else if (!isDestructive)
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 14,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
class _OptionDivider extends StatelessWidget {
  const _OptionDivider();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(color: Colors.white12, height: 1),
    );
  }
}
class _SoporteItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _SoporteItem({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
        ),
      ],
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
        size.width * 0.35,
        size.height * 0.05,
        size.width * 0.65,
        size.height * 0.28,
      )
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.45,
        size.width + 20,
        size.height * 0.30,
      );
    canvas.drawPath(road1, roadPaint);
    Path road2 = Path()
      ..moveTo(-20, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.42,
        size.width * 0.55,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.78,
        size.width + 20,
        size.height * 0.62,
      );
    canvas.drawPath(road2, roadPaintAccent);
    Path road3 = Path()
      ..moveTo(size.width * 0.12, -20)
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.4,
        size.width * 0.18,
        size.height * 0.75,
      )
      ..quadraticBezierTo(
        size.width * 0.15,
        size.height * 0.9,
        size.width * 0.1,
        size.height + 20,
      );
    canvas.drawPath(road3, roadPaint);
    Path road4 = Path()
      ..moveTo(size.width * 0.78, -20)
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.3,
        size.width * 0.82,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.8,
        size.width * 0.85,
        size.height + 20,
      );
    canvas.drawPath(road4, roadPaint);
    // -------- Punto de interés con resplandor --------
    final glowCenter = Offset(size.width * 0.62, size.height * 0.32);
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [AppColors.accent.withOpacity(0.35), Colors.transparent],
      ).createShader(Rect.fromCircle(center: glowCenter, radius: 60));
    canvas.drawCircle(glowCenter, 60, glowPaint);
    canvas.drawCircle(glowCenter, 5, Paint()..color = AppColors.accent);
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
