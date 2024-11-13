import 'package:design_galileo/widgets/galileo_character.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:design_galileo/widgets/side_menu_alumno.dart';

class AlumnoPage extends StatefulWidget {
  const AlumnoPage({super.key});

  @override
  AlumnoPageState createState() => AlumnoPageState();
}

class AlumnoPageState extends State<AlumnoPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool isDrawerOpen = false;
  String fullText = 'Hola, soy Galileo. Bienvenido a tu espacio de experimentos.';
  String experimentsText = 'EXPERIMENTOS:\n\nAquí puedes ver tus experimentos asignados';
  String instructionText = 'A continuación, cliquea en la pizarra para ver los experimentos.';
  String displayedText = '';
  int currentIndex = 0;
  bool showButton = false;
  bool showExperimentText = false;
  bool darkBackground = false;
  bool isHovered = false; // Control del efecto hover

  final GlobalKey<GalileoCharacterState> galileoKey = GlobalKey<GalileoCharacterState>();
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _flutterTts = FlutterTts();
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setPitch(0.8); // Grave
    _flutterTts.setVoice({"name": "es-MX-standard-B", "locale": "es-MX"}); // Masculina y grave

    _startIntroDialogue();
  }

  void _startIntroDialogue() {
    _speakText(fullText); // Hablar el texto antes de mostrarlo letra por letra
    _startWritingText(fullText);
  }

  void _speakText(String text) async {
    await _flutterTts.stop(); // Detener cualquier texto en proceso
    await _flutterTts.speak(text);
  }

  void _startWritingText(String text) {
    setState(() {
      displayedText = '';
      currentIndex = 0;
    });
    Future.delayed(const Duration(milliseconds: 100), () => _writeNextLetter(text));
  }

  void _writeNextLetter(String text) {
    if (currentIndex < text.length) {
      setState(() {
        displayedText += text[currentIndex];
        currentIndex++;
      });
      Future.delayed(const Duration(milliseconds: 50), () => _writeNextLetter(text));
    } else if (text == fullText) {
      setState(() {
        showButton = true;
      });
    } else if (text == instructionText) {
      _highlightBoard();
      _speakText(text); // Hablar el texto de instrucción después de mostrarlo
    }
  }

  void _onShowExperimentsPressed() {
    setState(() {
      showExperimentText = true;
      showButton = false;
      displayedText = experimentsText;
    });
    _startWritingText(instructionText); // Mostrar el cuadro de instrucciones antes de hablar
  }

  void _toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _highlightBoard() {
    setState(() {
      darkBackground = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: darkBackground ? Colors.black.withOpacity(0.6) : Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _controller,
            color: Colors.white,
            size: 40.0,
          ),
          onPressed: _toggleDrawer,
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: darkBackground
                  ? ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.darken)
                  : ColorFilter.mode(Colors.transparent, BlendMode.multiply),
              child: Image.asset(
                'assets/images/galileo/Aula_primaria.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: SideMenuAlumno(onClose: _toggleDrawer),
          ),
          Center(
            child: Stack(
              children: [
                // Cuadro blanco de texto que aparece abajo
                if (!showExperimentText)
                  Positioned(
                    bottom: 50,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.white,
                      child: Text(
                        displayedText,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                // Botón para mostrar los experimentos con efecto de agrandamiento
                if (showButton)
                  Align(
                    alignment: Alignment.center,
                    child: MouseRegion(
                      onEnter: (_) => setState(() => isHovered = true),
                      onExit: (_) => setState(() => isHovered = false),
                      child: AnimatedScale(
                        scale: isHovered ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton(
                          onPressed: _onShowExperimentsPressed,
                          child: Text("Mostrar Experimentos"),
                        ),
                      ),
                    ),
                  ),
                // Texto de los experimentos en la pizarra
                if (showExperimentText)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Text(
                        experimentsText,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                // Cuadro de instrucción que aparece después de mostrar los experimentos
                if (displayedText == instructionText)
                  Positioned(
                    bottom: 50,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.white,
                      child: Text(
                        displayedText,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                // Mostrar el personaje de Galileo
                GalileoCharacter(
                  key: galileoKey,
                  posX: 1000.0,
                  posY: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}