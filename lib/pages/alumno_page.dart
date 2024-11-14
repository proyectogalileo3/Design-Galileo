import 'dart:js' as js;
import 'dart:js_util' as js_util;
import 'package:design_galileo/widgets/galileo_character.dart';
import 'package:flutter/material.dart';
import 'package:design_galileo/widgets/side_menu_alumno.dart';

class AlumnoPage extends StatefulWidget {
  const AlumnoPage({super.key});

  @override
  AlumnoPageState createState() => AlumnoPageState();
}

class AlumnoPageState extends State<AlumnoPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late AnimationController _handAnimationController;
  late Animation<Offset> _handSlideAnimation;

  bool isDrawerOpen = false;
  String fullText = 'Hola, soy Galileo. Bienvenido a tu espacio de experimentos.';
  String experimentsText = 'EXPERIMENTOS:\n\nAquí puedes ver tus experimentos asignados';
  String instructionText = 'A continuación, cliquea en la pizarra para ver los experimentos.';
  String displayedText = '';
  int currentIndex = 0;
  bool showButton = false;
  bool showExperimentText = false;
  bool darkBackground = false;
  bool isHovered = false;
  bool isStarted = false;
  bool isHoveredIniciar = false;
  bool showingInstructionText = false;

  final GlobalKey<GalileoCharacterState> galileoKey = GlobalKey<GalileoCharacterState>();

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

    _handAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _handSlideAnimation = Tween<Offset>(
      begin: Offset(-0.25, 0),
      end: Offset(-0.20, 0),
    ).animate(CurvedAnimation(
      parent: _handAnimationController,
      curve: Curves.easeInOut,
    ));

    checkResponsiveVoice();
  }

  void checkResponsiveVoice() {
    if (js.context.hasProperty('responsiveVoice')) {
      print("ResponsiveVoice cargado correctamente.");
    } else {
      print("Error: ResponsiveVoice no se ha cargado.");
    }
  }

  void speakText(String text) {
    Future.delayed(Duration(seconds: 2), () {
      if (js.context.hasProperty('speakWithResponsiveVoice')) {
        js.context.callMethod('speakWithResponsiveVoice', [text, "Spanish Latin American Male"]);
      } else {
        print("Error: speakWithResponsiveVoice no está disponible.");
      }
    });
  }

  void _startApplication() {
    setState(() {
      isStarted = true;
    });
    _startIntroDialogue();
  }

  void _startIntroDialogue() {
    speakText(fullText);
    _startWritingText(fullText);
  }

  void _startWritingText(String text) {
    setState(() {
      displayedText = '';
      currentIndex = 0;
      showingInstructionText = text == instructionText;
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
      speakText(text);
    }
  }

  void _onShowExperimentsPressed() {
    setState(() {
      showExperimentText = true;
      showButton = false;
      displayedText = experimentsText;
    });
    _startWritingText(instructionText);
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
    _handAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
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
            child: Image.asset(
              'assets/images/galileo/Aula_primaria.png',
              fit: BoxFit.cover,
            ),
          ),
          if (darkBackground)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          // Añadimos la pizarra con color original
          if (darkBackground)
            Positioned(
              top: screenSize.height * 0.35, // Ajusta este valor para subir o bajar la pizarra
              left: screenSize.width * 0.25, // Ajusta este valor para mover la pizarra a la izquierda o derecha
              width: screenSize.width * 0.50, // Ajusta el ancho de la pizarra
              height: screenSize.height * 0.32, // Ajusta la altura de la pizarra
              child: Image.asset(
                'assets/images/galileo/Pizarra.png', // Imagen de la pizarra
                fit: BoxFit.contain,
              ),
            ),
          SlideTransition(
            position: _slideAnimation,
            child: SideMenuAlumno(onClose: _toggleDrawer),
          ),
          Center(
            child: Stack(
              children: [
                if (!isStarted)
                  Center(
                    child: MouseRegion(
                      onEnter: (_) => setState(() => isHoveredIniciar = true),
                      onExit: (_) => setState(() => isHoveredIniciar = false),
                      child: AnimatedScale(
                        scale: isHoveredIniciar ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton(
                          onPressed: _startApplication,
                          child: Text("Iniciar"),
                        ),
                      ),
                    ),
                  ),
                if (isStarted && !showExperimentText)
                  Positioned(
                    bottom: 50,
                    left: screenSize.width * 0.25,
                    right: screenSize.width * 0.25,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        displayedText,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
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
                if (displayedText == instructionText)
                  Positioned(
                    bottom: 50,
                    left: screenSize.width * 0.25,
                    right: screenSize.width * 0.25,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        displayedText,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (darkBackground)
                  Positioned(
                    top: screenSize.height * 0.4,
                    left: screenSize.width * 0.25,
                    right: screenSize.width * 0.25,
                    child: SlideTransition(
                      position: _handSlideAnimation,
                      child: Image.asset(
                        'assets/images/galileo/mano.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
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
