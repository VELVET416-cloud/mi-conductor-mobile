import 'package:flutter/material.dart';
import '../cliente/home_screen.dart';
import '../cliente/guest_home_screen.dart';
import '../conductor/home_conductor_screen.dart';

// ===========================================================
// PALETA DE COLORES (idéntica a la original)
// ===========================================================
class _Colors {
  static const Color background = Color(0xFF021B2C);
  static const Color backgroundAlt = Color(0xFF022B40);
  static const Color surface = Color(0xFF0A314A);
  static const Color field = Color(0xFF06263A);
  static const Color accent = Color(0xFFFFA43A);
  static const Color divider = Color(0x14FFFFFF);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool esCliente = true;
  bool _ocultarPassword = true;

  final correoController = TextEditingController();
  final passwordController = TextEditingController();

  void iniciarSesion() {
    final correo = correoController.text.trim();
    final password = passwordController.text.trim();

    // CLIENTE DEMO
    if (esCliente &&
        correo == "cliente@mi.com" &&
        password == "123456") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
      return;
    }

    // CONDUCTOR DEMO
    if (!esCliente &&
        correo == "conductor@mi.com" &&
        password == "123456") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeConductorScreen(),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Correo o contraseña incorrectos.",
        ),
      ),
    );
  }

  void entrarInvitado() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const GuestHomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    correoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Colors.background,
      body: Stack(
        children: [
          // -------- Fondo: mapa oscuro estilizado (mismo estilo de la app) --------
          const Positioned.fill(child: _DarkMapBackground()),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _Colors.background.withOpacity(0.55),
                    _Colors.background.withOpacity(0.97),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 20,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 28),

                  // -------- Logo / marca --------
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _Colors.accent.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: _Colors.accent.withOpacity(0.35),
                      ),
                    ),
                    child: const Icon(
                      Icons.directions_car_filled_rounded,
                      color: _Colors.accent,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Mi Conductor",
                    style: TextStyle(
                      color: _Colors.accent,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "Soluciones de conducción premium",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // -------- Tarjeta principal --------
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: _Colors.surface.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: _Colors.divider),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Bienvenido de nuevo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "Ingresa tus credenciales para acceder",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // -------- Selector Cliente / Conductor --------
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _Colors.field,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _RoleTab(
                                  label: "Cliente",
                                  icon: Icons.person_outline_rounded,
                                  selected: esCliente,
                                  onTap: () =>
                                      setState(() => esCliente = true),
                                ),
                              ),
                              Expanded(
                                child: _RoleTab(
                                  label: "Conductor",
                                  icon: Icons.badge_outlined,
                                  selected: !esCliente,
                                  onTap: () =>
                                      setState(() => esCliente = false),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 26),

                        _buildLabel("CORREO ELECTRÓNICO"),
                        const SizedBox(height: 8),
                        TextField(
                          controller: correoController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: _fieldDecoration(
                            hint: "correo@ejemplo.com",
                            icon: Icons.email_outlined,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _buildLabel("CONTRASEÑA"),
                        const SizedBox(height: 8),
                        TextField(
                          controller: passwordController,
                          obscureText: _ocultarPassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: _fieldDecoration(
                            hint: "********",
                            icon: Icons.lock_outline,
                            suffix: IconButton(
                              splashRadius: 18,
                              icon: Icon(
                                _ocultarPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white70,
                              ),
                              onPressed: () => setState(
                                () => _ocultarPassword = !_ocultarPassword,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 32),
                              tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {},
                            child: const Text(
                              "¿Olvidaste tu contraseña?",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _Colors.accent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: iniciarSesion,
                            child: const Text(
                              "Iniciar sesión",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        if (esCliente) ...[
                          const SizedBox(height: 6),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Registrarse",
                              style: TextStyle(
                                color: _Colors.accent,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: entrarInvitado,
                            child: const Text(
                              "Invitado",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 14),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          decoration: BoxDecoration(
                            color: _Colors.field,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            esCliente
                                ? "Demo Cliente · cliente@mi.com · 123456"
                                : "Demo Conductor · conductor@mi.com · 123456",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        Row(
                          children: const [
                            Expanded(
                                child: Divider(
                                    color: _Colors.divider, height: 1)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "O CONTINÚA CON",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Divider(
                                    color: _Colors.divider, height: 1)),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [
                            Expanded(
                              child: _SocialButton(
                                label: "Google",
                                icon: Icons.g_mobiledata_rounded,
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _SocialButton(
                                label: "Apple",
                                icon: Icons.apple_rounded,
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  RichText(
                    text: const TextSpan(
                      text: "¿Aún no eres cliente? ",
                      style: TextStyle(color: Colors.white70, fontSize: 13.5),
                      children: [
                        TextSpan(
                          text: "Regístrate ahora",
                          style: TextStyle(
                            color: _Colors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white60,
          fontWeight: FontWeight.bold,
          fontSize: 11.5,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white70, size: 20),
      suffixIcon: suffix,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: _Colors.field,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _Colors.accent, width: 1.4),
      ),
    );
  }
}

// ===========================================================
// Pestaña de selección de rol (Cliente / Conductor)
// ===========================================================
class _RoleTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? _Colors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: selected ? Colors.black87 : Colors.white70,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.black87 : Colors.white70,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================
// Botón social compacto (Google / Apple)
// ===========================================================
class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _Colors.field,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _Colors.divider),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white70, size: 20),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
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
// Fondo de "mapa oscuro" dibujado por código (mismo estilo
// que el resto de la aplicación): cuadrícula sutil, vías
// principales curvas y puntos de interés con resplandor.
// ===========================================================
class _DarkMapBackground extends StatelessWidget {
  const _DarkMapBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: _Colors.background),
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
        colors: [_Colors.backgroundAlt, _Colors.background],
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
      ..color = _Colors.accent.withOpacity(0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    Path road1 = Path()
      ..moveTo(-20, size.height * 0.16)
      ..quadraticBezierTo(
        size.width * 0.35, size.height * 0.04,
        size.width * 0.65, size.height * 0.24,
      )
      ..quadraticBezierTo(
        size.width * 0.9, size.height * 0.38,
        size.width + 20, size.height * 0.26,
      );
    canvas.drawPath(road1, roadPaint);

    Path road2 = Path()
      ..moveTo(-20, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.30, size.height * 0.38,
        size.width * 0.55, size.height * 0.56,
      )
      ..quadraticBezierTo(
        size.width * 0.8, size.height * 0.74,
        size.width + 20, size.height * 0.58,
      );
    canvas.drawPath(road2, roadPaintAccent);

    Path road3 = Path()
      ..moveTo(size.width * 0.1, -20)
      ..quadraticBezierTo(
        size.width * 0.2, size.height * 0.35,
        size.width * 0.16, size.height * 0.7,
      )
      ..quadraticBezierTo(
        size.width * 0.13, size.height * 0.88,
        size.width * 0.08, size.height + 20,
      );
    canvas.drawPath(road3, roadPaint);

    Path road4 = Path()
      ..moveTo(size.width * 0.8, -20)
      ..quadraticBezierTo(
        size.width * 0.72, size.height * 0.28,
        size.width * 0.84, size.height * 0.55,
      )
      ..quadraticBezierTo(
        size.width * 0.92, size.height * 0.75,
        size.width * 0.87, size.height + 20,
      );
    canvas.drawPath(road4, roadPaint);

    Path road5 = Path()
      ..moveTo(-20, size.height * 0.85)
      ..quadraticBezierTo(
        size.width * 0.3, size.height * 0.95,
        size.width * 0.6, size.height * 0.86,
      )
      ..quadraticBezierTo(
        size.width * 0.8, size.height * 0.8,
        size.width + 20, size.height * 0.9,
      );
    canvas.drawPath(road5, roadPaint);

    // -------- Puntos de interés con resplandor --------
    final glowCenter = Offset(size.width * 0.7, size.height * 0.22);
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [_Colors.accent.withOpacity(0.35), Colors.transparent],
      ).createShader(Rect.fromCircle(center: glowCenter, radius: 70));
    canvas.drawCircle(glowCenter, 70, glowPaint);
    canvas.drawCircle(glowCenter, 5, Paint()..color = _Colors.accent);

    final glowCenter2 = Offset(size.width * 0.18, size.height * 0.62);
    final glowPaint2 = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white.withOpacity(0.12), Colors.transparent],
      ).createShader(Rect.fromCircle(center: glowCenter2, radius: 55));
    canvas.drawCircle(glowCenter2, 55, glowPaint2);
    canvas.drawCircle(
      glowCenter2,
      4,
      Paint()..color = Colors.white.withOpacity(0.55),
    );

    final glowCenter3 = Offset(size.width * 0.82, size.height * 0.78);
    final glowPaint3 = Paint()
      ..shader = RadialGradient(
        colors: [_Colors.accent.withOpacity(0.22), Colors.transparent],
      ).createShader(Rect.fromCircle(center: glowCenter3, radius: 60));
    canvas.drawCircle(glowCenter3, 60, glowPaint3);
    canvas.drawCircle(
      glowCenter3,
      4,
      Paint()..color = _Colors.accent.withOpacity(0.7),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}