import 'package:flutter/material.dart';
import 'dart:async';

class MaterialsPage extends StatefulWidget {
  const MaterialsPage({super.key});

  @override
  _MaterialsPageState createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  final List<Map<String, String>> materials = [
    {"icon": "assets/images/icons/icon1.png", "text": "Material 1"},
    {"icon": "assets/images/icons/icon2.png", "text": "Material 2"},
    {"icon": "assets/images/icons/icon3.png", "text": "Material 3"},
  ];

  int currentIndex = 0; // Índice del material actual
  String currentText = ""; // Texto que se muestra progresivamente
  int letterIndex = 0; // Índice de la letra actual
  Timer? letterTimer;

  final List<Map<String, String>> displayedMaterials = []; // Materiales ya mostrados

  // Márgenes ajustados para cada fila
  final List<double> rowOffsets = [320, 390, 460]; // Más abajo
  final double horizontalOffset = 0.35; // Más a la derecha

  @override
  void initState() {
    super.initState();
    _startMaterialSequence();
  }

  void _startMaterialSequence() {
    if (currentIndex < materials.length) {
      setState(() {
        currentText = "";
        letterIndex = 0;
      });

      // Mostrar las letras del texto una por una
      letterTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (letterIndex < materials[currentIndex]["text"]!.length) {
          setState(() {
            currentText += materials[currentIndex]["text"]![letterIndex];
            letterIndex++;
          });
        } else {
          timer.cancel();
          // Añadir el material actual a los materiales mostrados
          displayedMaterials.add({
            "icon": materials[currentIndex]["icon"]!,
            "text": materials[currentIndex]["text"]!,
          });
          // Pasar al siguiente material
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              currentIndex++;
            });
            _startMaterialSequence();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    letterTimer?.cancel();
    super.dispose();
  }

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
          // Imagen de materiales en el centro
          Center(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/aula/materiales.png',
                  width: currentWidth * 0.8,
                  height: currentHeight * 0.8,
                  fit: BoxFit.contain,
                ),
                // Dibujar materiales ya mostrados
                ...List.generate(displayedMaterials.length, (index) {
                  return Positioned(
                    top: rowOffsets[index], // Ajuste exacto de cada fila
                    left: currentWidth * horizontalOffset, // Más a la derecha
                    child: Row(
                      children: [
                        Image.asset(
                          displayedMaterials[index]["icon"]!,
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          displayedMaterials[index]["text"]!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                // Dibujar el material actual
                if (currentIndex < materials.length)
                  Positioned(
                    top: rowOffsets[displayedMaterials.length], // Posición de la fila actual
                    left: currentWidth * horizontalOffset, // Más a la derecha
                    child: Row(
                      children: [
                        Image.asset(
                          materials[currentIndex]["icon"]!,
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          currentText,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
