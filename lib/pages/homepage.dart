import 'dart:convert';
import 'package:design_galileo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'quiz_page.dart';
import 'materials_page.dart';
import 'autoevaluacion_page.dart';
import 'package:design_galileo/widgets/galileo_character.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Map<String, Actividad> actividades;
  int indiceActividad = 0;

  final player = AudioPlayer();

  bool isDarkBackground = false; // Oscurecer fondo al inicio
  bool showGalileo = false; // Mostrar a Galileo
  bool showInteractivePizarra = false; // Mostrar la pizarra interactiva
  bool showButtons = false; // Mostrar los 4 botones al presionar "Empezar"
  bool showSpeakButton = true; // Mostrar el botón de hablar antes de hablar
  int buttonStage = 0; // Estado de habilitación de botones (uno por uno)
  bool quizCompleted = false;
  bool quizActivated = false; // Estado del botón de quiz activado
  bool autoevaluationActivated =
      true; // Estado del botón de autoevaluación activado
  bool isHoveringQuiz = false; // Cursor sobre el botón de quiz
  bool isHoveringMateriales = false; // Cursor sobre el botón de materiales
  bool isHoveringAutoevaluacion = false;

  @override
  void initState() {
    super.initState();
    cargarActividades();
    _startSequence(); // Iniciar la secuencia inicial
  }

  Future<void> cargarActividades() async {
    final String response =
        await rootBundle.loadString('assets/actividades.json');
    final Map<String, dynamic> data = json.decode(response);

    setState(() {
      actividades = data.map((key, value) {
        return MapEntry(key, Actividad.fromJson(value));
      });
    });
  }

  Future<void> playTextToSpeech(String text) async {
    const voiceBill = 'Nh2zY9kknu6z4pZy6FhD'; // ID de la voz
    const url = 'https://api.elevenlabs.io/v1/text-to-speech/$voiceBill';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'accept': 'audio/mpeg',
        'xi-api-key': elevenlabsAPIKey,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "text": text,
        "model_id": "eleven_multilingual_v1",
        "voice_settings": {
          "stability": .1,
          "similarity_boost": .95,
        }
      }),
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      await player.setAudioSource(AudioSource(bytes));
      player.play();
    } else {
      print('Error al generar audio: ${response.body}');
    }
  }

  Future<void> _startSequence() async {
    // Mostrar Galileo después de 2 segundos con fondo oscuro
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isDarkBackground = true;
      showGalileo = true;
      showSpeakButton = true;
    });
  }

  Future<void> onSpeakButtonPressed() async {
    setState(() {
      showSpeakButton = false; // Ocultar el botón de hablar
    });
    // Galileo habla
    // await playTextToSpeech(
    //     "Hola, soy Galileo. Bienvenido al laboratorio de experimentos.");
    await Future.delayed(const Duration(seconds: 1)); // Simular tiempo de habla

    // Mostrar pizarra interactiva después de hablar
    setState(() {
      isDarkBackground = false;
      showGalileo = false;
      showInteractivePizarra = true;
    });
  }

  void onEmpezarPressed(int nuevoIndice) {
    setState(() {
      indiceActividad = nuevoIndice;
      showButtons = true;
    });
    _animateButtons(); // Animar la aparición de los botones
  }

  Future<void> _animateButtons() async {
    for (int i = 0; i < 2; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        buttonStage = i + 1; // Habilitar botones en secuencia
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    double lateralButtonsHeight = 360;

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
          // Fondo oscuro
          if (isDarkBackground)
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
          // Galileo animado
          if (showGalileo)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const GalileoCharacter(
                    sizeX: 800,
                    sizeY: 800,
                    posX: 800,
                  ),
                  if (showSpeakButton) // Botón de hablar
                    ElevatedButton(
                      onPressed: onSpeakButtonPressed,
                      child: const Text("Empezar"),
                    ),
                  if (!showSpeakButton) // Cuadro de texto con el mensaje de Galileo
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: const Text(
                        "Hola, soy Galileo. Bienvenido al laboratorio de experimentos.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                ],
              ),
            ),
          // Pizarra interactiva
          if (showInteractivePizarra)
            Positioned(
              top: currentHeight * 0.1,
              left: currentWidth * 0.1,
              child: Container(
                height: currentHeight * 0.75,
                width: currentWidth * 0.8,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/aula/pizarra.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 131.0, bottom: 180.0, left: 350.0, right: 350.0),
                  child: ListView.builder(
                    itemCount: actividades.length,
                    itemBuilder: (context, index) {
                      final actividad = actividades.values.elementAt(index);
                      return ExpansionTile(
                        title: Text(
                          actividad.numeroActividad,
                          style: const TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          actividad.titulo,
                          style: const TextStyle(
                              fontSize: 32, color: Colors.white),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              actividad.descripcion,
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 16.0, bottom: 8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  onEmpezarPressed(index);
                                },
                                child: const Text('Empezar'),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          // Botones laterales
          if (showButtons)
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildSideButton(
                        'assets/images/aula/materiales.png',
                        lateralButtonsHeight * 1.2,
                        buttonStage > 0,
                        'materiales',
                      ),
                      _buildSideButton(
                        'assets/images/aula/autoevaluacion.png',
                        lateralButtonsHeight,
                        autoevaluationActivated,
                        'autoevaluacion',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: lateralButtonsHeight * 1.5,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildSideButton(
                        'assets/images/aula/quiz.png',
                        lateralButtonsHeight,
                        quizActivated || buttonStage > 1,
                        'quiz',
                      ),
                      _buildSideButton(
                        'assets/images/aula/curiosidades.png',
                        lateralButtonsHeight,
                        true, // Siempre gris por ahora
                        'curiosidades',
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Información"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSideButton(
      String asset, double height, bool enabled, String buttonType) {
    bool isHovering = false;

    if (buttonType == 'quiz') {
      isHovering = isHoveringQuiz;
    } else if (buttonType == 'materiales') {
      isHovering = isHoveringMateriales;
    } else if (buttonType == 'autoevaluacion') {
      isHovering = isHoveringAutoevaluacion;
    }

    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: MouseRegion(
          onEnter: (event) {
            setState(() {
              if (buttonType == 'quiz') isHoveringQuiz = true;
              if (buttonType == 'materiales') isHoveringMateriales = true;
              if (buttonType == 'autoevaluacion')
                isHoveringAutoevaluacion = true;
            });
          },
          onExit: (event) {
            setState(() {
              if (buttonType == 'quiz') isHoveringQuiz = false;
              if (buttonType == 'materiales') isHoveringMateriales = false;
              if (buttonType == 'autoevaluacion')
                isHoveringAutoevaluacion = false;
            });
          },
          child: GestureDetector(
            onTap: enabled
                ? () {
                    if (buttonType == 'quiz') {
                      setState(() {
                        quizActivated = false;
                        autoevaluationActivated = true;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuizPage()),
                      ).then((_) {
                        // Al volver del quiz, marcarlo como completado
                        setState(() {
                          quizCompleted = true;
                        });
                      });
                    } else if (buttonType == 'materiales') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MaterialsPage(
                                materiales: actividades.values
                                    .elementAt(indiceActividad)
                                    .materiales,
                                imagenesMateriales: actividades.values
                                    .elementAt(indiceActividad)
                                    .imagenesMateriales)),
                      );
                    } else if (buttonType == 'autoevaluacion') {
                      if (quizCompleted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AutoevaluacionPage()),
                        );
                      } else {
                        showPopup(context,
                            "La autoevaluación no está disponible por ahora.");
                      }
                    } else if (buttonType == 'curiosidades') {
                      showPopup(context,
                          "Las curiosidades no están disponibles por ahora.");
                    }
                  }
                : null,
            child: AnimatedScale(
              scale: (enabled && isHovering) ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Opacity(
                opacity: enabled ? 1.0 : 0.5,
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(asset),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Actividad {
  final String numeroActividad;
  final String descripcion;
  final String titulo;
  final List<String> materiales;
  final List<String> imagenesMateriales;

  Actividad(
      {required this.numeroActividad,
      required this.descripcion,
      required this.titulo,
      required this.materiales,
      required this.imagenesMateriales});

  factory Actividad.fromJson(Map<String, dynamic> json) {
    return Actividad(
        numeroActividad: json['numero_actividad'],
        descripcion: json['descripcion'],
        titulo: json['titulo'],
        materiales: List<String>.from(json['materiales']),
        imagenesMateriales: List<String>.from(json['imagenes']));
  }
}

class AudioSource extends StreamAudioSource {
  final List<int> bytes;
  AudioSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
