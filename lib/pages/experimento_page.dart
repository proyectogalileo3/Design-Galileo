import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:design_galileo/widgets/galileo_character.dart';

class ExperimentoPage extends StatefulWidget {
  final int indiceActividad;
  final List<String> introduccionGalileo;
  final List<String> desarrollo;
  final List<String> desarrolloGalileo;
  final List<int> explicacionPasos;
  final List<String> imagenes;
  final List<String> conclusion;

  const ExperimentoPage({
    super.key,
    required this.indiceActividad,
    required this.introduccionGalileo,
    required this.desarrollo,
    required this.desarrolloGalileo,
    required this.explicacionPasos,
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
  int dialogToPlay = 0; // Índice del diálogo actual en la etapa
  int explicacionPaso = 0; 
  int currentStageIndex = 0; // Índice de la etapa actual
  final List<String> dialogStages = ["introduccion_galileo", "desarrollo", "conclusion_galileo"]; // , "desarrollo_galileo"

  void startDialogueSequence() {
    setState(() {
      showDialogues = true;
      dialogToPlay = 0;
      currentStageIndex = 0;
    });
    _playAudio();
  }

  void nextDialogue() {
    setState(() {
      if (dialogStages[currentStageIndex] == "introduccion_galileo") {
        if (dialogToPlay < widget.introduccionGalileo.length - 1) {
          dialogToPlay++;
        } else {
          moveToNextStage();
        }
      } else if (dialogStages[currentStageIndex] == "desarrollo") {
        if (dialogToPlay < widget.desarrollo.length - 1) {
          dialogToPlay++;
        } else {
          moveToNextStage();
        }
      // } else if (dialogStages[currentStageIndex] == "desarrollo_galileo") {
      //   if (dialogToPlay < widget.desarrolloGalileo.length - 1) {
      //     dialogToPlay++;
      //   } else {
      //     moveToNextStage();
      //   }
      } else if (dialogStages[currentStageIndex] == "conclusion_galileo") {
        if (dialogToPlay < widget.conclusion.length - 1) {
          dialogToPlay++;
        } else {
          // Finaliza la secuencia de diálogos
          showDialogues = false;
        }
      }
    });
    _playAudio();
  }

  void moveToNextStage() {
    if (currentStageIndex < dialogStages.length - 1) {
      currentStageIndex++;
      dialogToPlay = 0;
    } else {
      // Finaliza la secuencia si no hay más etapas
      showDialogues = false;
    }
  }

  void _playAudio() async {
    String audioPath = '';

    if (dialogStages[currentStageIndex] == "introduccion_galileo") {
      audioPath = 'audio/actividad00${widget.indiceActividad + 1}/introduccion_galileo/audio_0${dialogToPlay + 1}.mp3';
    } else if (dialogStages[currentStageIndex] == "desarrollo") {
      if (widget.explicacionPasos.isEmpty) {
        return;
      }
      if ((dialogToPlay + 1) == widget.explicacionPasos[explicacionPaso]) {
        audioPath = 'audio/actividad00${widget.indiceActividad + 1}/desarrollo_galileo/audio_0${explicacionPaso + 1}.mp3';
        if ((explicacionPaso + 1) < widget.explicacionPasos.length) {
          explicacionPaso++;
        }
      } else {
        return;
      }
    // } else if (dialogStages[currentStageIndex] == "desarrollo_galileo") {
    //   audioPath = 'audio/actividad00${widget.indiceActividad + 1}/desarrollo_galileo/audio_0${dialogToPlay + 1}.mp3';
    } else if (dialogStages[currentStageIndex] == "conclusion_galileo") {
      audioPath = 'audio/actividad00${widget.indiceActividad + 1}/conclusion_galileo/audio_0${dialogToPlay + 1}.mp3';
    }

    try {
      final audioDuration = await player.setAsset(audioPath) ?? Duration.zero;
      galileoKey.currentState!.startSpeaking(audioDuration);
      await player.play();
    } catch (e) {
      debugPrint("Error al reproducir el audio: $e");
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                galileoKey.currentState?.startWalking(0, onWalkComplete: startDialogueSequence);
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
                      margin: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 196.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        dialogStages[currentStageIndex] == "introduccion_galileo"
                            ? widget.introduccionGalileo[dialogToPlay]
                            : dialogStages[currentStageIndex] == "desarrollo"
                              ? widget.desarrollo[dialogToPlay]
                              // : dialogStages[currentStageIndex] == "desarrollo_galileo"
                              //     ? widget.desarrolloGalileo[dialogToPlay]
                                  : widget.conclusion[dialogToPlay],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (dialogStages[currentStageIndex] == "desarrollo")
                      widget.imagenes.length > dialogToPlay
                          ? Image.asset(
                              widget.imagenes[dialogToPlay],
                              height: currentHeight * 0.75,
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
              ),
            ),
        ],
      ),
    );
  }
}
