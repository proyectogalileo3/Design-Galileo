import 'dart:convert';

import 'package:design_galileo/pages/experimento_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:just_audio/just_audio.dart';
import 'quiz_page.dart';
import 'materials_page.dart';
import 'autoevaluacion_page.dart';
import 'package:design_galileo/widgets/galileo_character.dart';
// import 'package:design_galileo/utils/playTextToSpeech.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Map<String, Actividad> actividades;
  int indiceActividad = 0;

  final GlobalKey<GalileoCharacterState> galileoKey =
      GlobalKey<GalileoCharacterState>();

  bool isDarkBackground = false; // Oscurecer fondo al inicio
  bool showGalileo = false; // Mostrar a Galileo
  bool showInteractivePizarra = false; // Mostrar la pizarra interactiva
  bool showButtons = false; // Mostrar los 4 botones al presionar "Empezar"
  bool showSpeakButton = true; // Mostrar el botón de hablar antes de hablar
  bool showList = true;
  int buttonStage = 0; // Estado de habilitación de botones (uno por uno)
  bool quizCompleted = false;
  bool quizActivated = false; // Estado del botón de quiz activado
  bool autoevaluationActivated =
      true; // Estado del botón de autoevaluación activado
  bool isHoveringQuiz = false; // Cursor sobre el botón de quiz
  bool isHoveringMateriales = false; // Cursor sobre el botón de materiales
  bool isHoveringAutoevaluacion = false;
  bool isHoveringComenzar = false;

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

    final player = AudioPlayer();
    final audioDuration = await player.setAsset('assets/audio/presentacion_galileo.mp3') ?? Duration.zero;

    // TextToSpeech
    // final audioDuration = await playTextToSpeech(player, "Hola, soy Galileo. Bienvenido al laboratorio de experimentos.");

    // galileoKey.currentState!.startSpeaking(audioDuration);
    // await player.play();

    // Mostrar pizarra interactiva después de hablar
    if (mounted) {
      setState(() {
        isDarkBackground = false;
        showGalileo = false;
        showInteractivePizarra = true;
      });
    }
  }

  void onEmpezarPressed(int nuevoIndice) {
    setState(() {
      showList = false;
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
                  GalileoCharacter(
                    key: galileoKey,
                    sizeX: currentHeight * .33,
                    sizeY: currentWidth * .33,
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
                      top: 80.0, bottom: 120.0, left: 380.0, right: 380.0),
                  child: showList
                  ? ListView.builder(
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
                  )
                  : Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_circle_left,
                              size: 42,
                              color: Color(0x66000000),
                            ),
                            onPressed: () {
                              showList = true;
                            },
                          ),
                        ),
                      ),
                      Center(
                          child: MouseRegion(
                            onEnter: (_) => setState(() => isHoveringComenzar = true),
                            onExit: (_) => setState(() => isHoveringComenzar = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              width: isHoveringComenzar ? 120 * 1.1 : 120,
                              height: isHoveringComenzar ? 120 * 1.1 : 120,
                              decoration: BoxDecoration(
                                color: isHoveringComenzar? const Color(0xAA000000) : const Color(0x33000000),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.play_arrow,
                                  size: isHoveringComenzar? 64 * 1.1 : 64,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ExperimentoPage(
                                          introduccionGalileo: actividades
                                                                .values
                                                                .elementAt(indiceActividad)
                                                                .introduccionGalileo,
                                          desarrollo: actividades
                                                        .values
                                                        .elementAt(indiceActividad)
                                                        .desarrollo,
                                          imagenes: actividades
                                                        .values
                                                        .elementAt(indiceActividad)
                                                        .imagenes,
                                          conclusion: actividades
                                                        .values
                                                        .elementAt(indiceActividad)
                                                        .conclusion,
                                        )),
                                  );
                                },
                              ),
                            ),
                          ),
                      ),
                    ],
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
  // Para pantalla de inicio
  final String numeroActividad;
  final String descripcion;
  final String titulo;

  // Para pantalla de materiales
  final List<String> materiales;
  final List<String> imagenesMateriales;

  // Para pantalla de experimentos
  final List<String> introduccionGalileo;
  final List<String> desarrollo;
  final List<String> imagenes;
  final List<String> conclusion;

  Actividad({
    required this.numeroActividad,
    required this.descripcion,
    required this.titulo,
    required this.materiales,
    required this.imagenesMateriales,
    required this.introduccionGalileo,
    required this.desarrollo,
    required this.imagenes,
    required this.conclusion,
  });

  factory Actividad.fromJson(Map<String, dynamic> json) {
    return Actividad(
        numeroActividad: json['numero_actividad'],
        descripcion: json['descripcion'],
        titulo: json['titulo'],
        materiales: List<String>.from(json['materiales']),
        imagenesMateriales: List<String>.from(json['imagenes_materiales']),
        introduccionGalileo: List<String>.from(json['introduccion_galileo']),
        desarrollo: List<String>.from(json['desarrollo']),
        imagenes: List<String>.from(json['imagenes']),
        conclusion: List<String>.from(json['conclusion_galileo']));
  }
}
