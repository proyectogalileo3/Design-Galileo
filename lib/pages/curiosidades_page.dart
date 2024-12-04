import 'package:flutter/material.dart';

class CuriosidadesPage extends StatelessWidget {
  const CuriosidadesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo principal
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/aula/fondo_aula.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenedor para el GIF
          Center(
            child: Container(
              width: currentWidth * 0.9,
              height: currentHeight * 0.9,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/aula/bola.gif'),
                  fit: BoxFit.contain, // Asegura que el GIF se vea completo
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "¿Sabías que Galileo fue uno de los primeros en usar el método experimental para estudiar el movimiento?",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 10.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          // Botón de volver atrás
          Positioned(
            bottom: currentHeight * 0.05,
            left: currentWidth * 0.05,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 56),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
