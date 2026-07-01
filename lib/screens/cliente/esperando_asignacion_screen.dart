import 'package:flutter/material.dart';
import 'conductor_asignado_screen.dart';

class EsperandoAsignacionScreen
    extends StatefulWidget {
  const EsperandoAsignacionScreen(
      {super.key});

  @override
  State<EsperandoAsignacionScreen>
      createState() =>
          _EsperandoAsignacionScreenState();
}

class _EsperandoAsignacionScreenState
    extends State<EsperandoAsignacionScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 4),
      () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const ConductorAsignadoScreen(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF021B2C),

      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: const [

            CircularProgressIndicator(
              color: Color(0xFFFFA43A),
            ),

            SizedBox(height: 30),

            Text(
              "Asignando conductor...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 15),

            Padding(
              padding:
                  EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Text(
                "Tu solicitud fue enviada correctamente.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}