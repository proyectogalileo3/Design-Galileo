import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:design_galileo/widgets/galileo_character.dart';
import 'package:flutter/services.dart';

class ExperimentoPage extends StatefulWidget {
  final int indiceActividad;
  final List<String> introduccionGalileo;
  final List<String> desarrollo;
  final List<String> imagenes;
  final List<String> conclusion;

  const ExperimentoPage({
    super.key,
    required this.indiceActividad,
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
  bool isIntroduction = true;
  bool isConclusion = false;

  void startDialogueSequence() {
    setState(() {
      showDialogues = true;
      currentDialogueIndex = 0;
      isIntroduction = true;
      isConclusion = false;
    });
    _playAudio();
  }

  void nextDialogue() {
    setState(() {
      if (isIntroduction) {
        if (currentDialogueIndex < widget.introduccionGalileo.length - 1) {
          currentDialogueIndex++;
        } else {
          isIntroduction = false;
          currentDialogueIndex = 0;
        }
      } else if (!isConclusion) {
        if (currentDialogueIndex < widget.desarrollo.length - 1) {
          currentDialogueIndex++;
        } else {
          isConclusion = true;
          currentDialogueIndex = 0;
        }
      } else {
        if (currentDialogueIndex < widget.conclusion.length - 1) {
          currentDialogueIndex++;
        } else {
          showDialogues = false;
        }
      }
    });
    _playAudio();
  }

  void _playAudio() async {
    String audioPath = '';

    if (isIntroduction) {
      audioPath = 'audio/actividad00${widget.indiceActividad + 1}/introduccion_galileo/audio_0${currentDialogueIndex + 1}.mp3';
    } else if (!isConclusion) {
      audioPath = 'audio/actividad00${widget.indiceActividad + 1}/desarrollo_galileo/audio_0${currentDialogueIndex + 1}.mp3';
    } else {
      audioPath = 'audio/actividad00${widget.indiceActividad + 1}/conclusion_galileo/audio_0${currentDialogueIndex + 1}.mp3';
    }

    try {
      // Cargar y reproducir el audio
      await player.setAsset(audioPath);
      player.play();
    } catch (e) {
      print("Error al reproducir el audio: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF303234),
              image: DecorationImage(
                image: AssetImage('assets/images/aula/pizarra.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
          GalileoCharacter(
            key: galileoKey,
            posX: -500,
            sizeX: 600,
            sizeY: 600,
          ),
          if (showDialogues)
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: nextDialogue,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    Column(
                      children: [
                        if (!isIntroduction && !isConclusion)
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
