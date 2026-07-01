import 'package:flutter/material.dart';
import 'seguimiento_screen.dart';

// ===========================================================
// PALETA DE COLORES CENTRALIZADA
// ===========================================================
class AppColors {
  static const Color background = Color(0xFF021B2C);
  static const Color surface = Color(0xFF0A314A);
  static const Color card = Color(0xFF123A52);
  static const Color field = Color(0xFF06263A);
  static const Color accent = Color(0xFFFFA43A);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
}

// ===========================================================
// Modelo simple de mensaje para el chat con el conductor.
// ===========================================================
class _Mensaje {
  final String texto;
  final bool esMio;

  _Mensaje({required this.texto, required this.esMio});
}

class ConductorAsignadoScreen extends StatelessWidget {
  const ConductorAsignadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "assets/images/map_dark.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withOpacity(0.1),
                    AppColors.background.withOpacity(0.85),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                const Spacer(),
                _buildDriverCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Encabezado ----------------
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 24,
              child: Icon(Icons.person, size: 26, color: Colors.black54),
            ),
          ),
          const Text(
            "Mi Conductor",
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          GestureDetector(
            onTap: () => _mostrarNotificaciones(context),
            child: CircleAvatar(
              backgroundColor: AppColors.surface,
              child: const Icon(
                Icons.notifications_none,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarNotificaciones(BuildContext context) {
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
          children: const [
            Text(
              "Notificaciones",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading:
                  Icon(Icons.directions_car, color: AppColors.accent),
              title: Text("Tu conductor está en camino",
                  style: TextStyle(color: AppColors.textPrimary)),
              subtitle: Text("Llegada estimada en 4 minutos",
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Tarjeta del conductor asignado ----------------
  Widget _buildDriverCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accent,
                    width: 2,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage(
                    "assets/images/driver.jpg",
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Julian Vance",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.directions_car,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Mercedes Benz",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.confirmation_number_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "ABC-123",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildEtaBadge(),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.accent, size: 18),
                SizedBox(width: 8),
                Text(
                  "Tu conductor ha sido asignado.",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 4,
                    shadowColor: AppColors.accent.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => _abrirChat(context),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          color: Colors.black87, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Mensaje",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.accent, width: 1.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SeguimientoScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.navigation_outlined,
                          color: AppColors.accent, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Seguir",
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- Badge de tiempo estimado (ETA) ----------------
  Widget _buildEtaBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        children: [
          Text(
            "ETA",
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "4 min",
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Chat funcional con el conductor ----------------
  void _abrirChat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ChatSheet(conductor: "Julian Vance"),
    );
  }
}

class _ChatSheet extends StatefulWidget {
  final String conductor;

  const _ChatSheet({required this.conductor});

  @override
  State<_ChatSheet> createState() => _ChatSheetState();
}

class _ChatSheetState extends State<_ChatSheet> {
  final List<_Mensaje> _mensajes = [
    _Mensaje(texto: "¡Hola! Voy en camino, llego en 4 minutos.", esMio: false),
  ];
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _enviar() {
    final texto = _inputController.text.trim();
    if (texto.isEmpty) return;
    setState(() {
      _mensajes.add(_Mensaje(texto: texto, esMio: true));
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 14),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage("assets/images/driver.jpg"),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.conductor,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _mensajes.length,
                itemBuilder: (context, index) {
                  final m = _mensajes[index];
                  return Align(
                    alignment: m.esMio
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: m.esMio
                            ? AppColors.accent
                            : AppColors.field,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        m.texto,
                        style: TextStyle(
                          color: m.esMio ? Colors.black87 : Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: "Escribe un mensaje...",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: AppColors.field,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _enviar(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: _enviar,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send,
                          color: Colors.black87, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}