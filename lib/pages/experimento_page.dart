import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:design_galileo/widgets/galileo_character.dart';

class ExperimentoPage extends StatefulWidget {
  final List<String> introduccionGalileo;
  final List<String> desarrollo;
  final List<String> imagenes;
  final List<String> conclusion;

  const ExperimentoPage({
    super.key,
    required this.introduccionGalileo,
    required this.desarrollo,
    required this.imagenes,
    required this.conclusion,
  });

  @override
  ExperimentoPageState createState() => ExperimentoPageState();
}

class ExperimentoPageState extends State<ExperimentoPage> {
  final GlobalKey<GalileoCharacterState> galileoKey = GlobalKey<GalileoCharacterState>();
  final player = AudioPlayer();

  bool showDialogues = false;
  int currentDialogueIndex = 0;
  bool isIntroduction = true; // Indicador para saber qué diálogo se está mostrando.
  bool isConclusion = false; // Indicador para los diálogos de conclusión.

  void startDialogueSequence() {
    setState(() {
      showDialogues = true;
      currentDialogueIndex = 0;
      isIntroduction = true; // Empezamos con la introducción.
      isConclusion = false;  // Aseguramos que no estamos en conclusión al inicio.
    });
  }

  void nextDialogue() {
    setState(() {
      if (isIntroduction) {
        // Si estamos en la introducción, avanzar dentro de introduccionGalileo.
        if (currentDialogueIndex < widget.introduccionGalileo.length - 1) {
          currentDialogueIndex++;
        } else {
          // Cambiar a los diálogos de desarrollo.
          isIntroduction = false;
          currentDialogueIndex = 0;
        }
      } else if (!isConclusion) {
        // Si estamos en el desarrollo, avanzar dentro de desarrollo.
        if (currentDialogueIndex < widget.desarrollo.length - 1) {
          currentDialogueIndex++;
        } else {
          // Al finalizar los diálogos de desarrollo, pasar a los de conclusión.
          isConclusion = true;
          currentDialogueIndex = 0;
        }
      } else {
        // Si estamos en la conclusión, avanzar dentro de conclusion.
        if (currentDialogueIndex < widget.conclusion.length - 1) {
          currentDialogueIndex++;
        } else {
          // Finalizar los diálogos.
          showDialogues = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF303234),
              image: DecorationImage(
                image: AssetImage('assets/images/aula/pizarra.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Botón Empezar
          Positioned(
            top: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                galileoKey.currentState!.startWalking(0, onWalkComplete: startDialogueSequence);
              },
              child: const Text('Empezar'),
            ),
          ),
          // Personaje Galileo
          GalileoCharacter(
            key: galileoKey,
            posX: -500,
            sizeX: 600,
            sizeY: 600,
          ),
          // Diálogos superpuestos
          if (showDialogues)
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: nextDialogue,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Texto del diálogo
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.all(64.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        isIntroduction
                            ? widget.introduccionGalileo[currentDialogueIndex]
                            : isConclusion
                                ? widget.conclusion[currentDialogueIndex]
                                : widget.desarrollo[currentDialogueIndex],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    // Mostrar imagen solo en desarrollo
                    Column(
                      children: [
                        if (!isIntroduction && !isConclusion) // Solo en desarrollo
                          widget.imagenes.length > currentDialogueIndex
                              ? Image.asset(
                                  widget.imagenes[currentDialogueIndex],
                                  height: currentHeight * 0.75,
                                  width: currentHeight * 0.75,
                                  fit: BoxFit.contain,
                                )
                              : Container(
                                  color: Colors.deepPurple.shade300,
                                  height: currentHeight * 0.75,
                                  width: currentHeight * 0.75,
                                  child: const Center(
                                    child: Text(
                                      'Imagen no disponible',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
