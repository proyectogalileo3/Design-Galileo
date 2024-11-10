import 'package:flutter/material.dart';
import 'dart:async';

import 'package:design_galileo/widgets/side_menu_alumno.dart';

class AlumnoPage extends StatefulWidget {
  const AlumnoPage({super.key});

  @override
  AlumnoPageState createState() => AlumnoPageState();
}

class AlumnoPageState extends State<AlumnoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool isHovered = false;
  bool isDrawerOpen = false;
  String fullText =
      'EXPERIMENTOS:\n\nAquí puedes ver tus experimentos asignados';
  String displayedText = '';
  String currentText = '';
  int currentIndex = 0;
  bool showButton = true;
  bool showExperimentButtons =
      false; // Variable para mostrar los botones de experimentos

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

  // Método para escribir letra por letra
  void _startWritingText(String text) {
    setState(() {
      showButton = false;
      currentText = text;
      displayedText = '';
      currentIndex = 0;
      showExperimentButtons =
          false; // Asegúrate de ocultar los botones de experimentos al iniciar
    });

    Future.delayed(const Duration(milliseconds: 100), _writeNextLetter);
  }

  // Método modificado para escribir el texto pasado por parámetro
  void _writeNextLetter() {
    if (currentIndex < currentText.length) {
      setState(() {
        displayedText += currentText[currentIndex];
        currentIndex++;
      });

      Future.delayed(const Duration(milliseconds: 20), _writeNextLetter);
    } else {
      // Cuando se termina de escribir, mostrar los botones de experimentos
      setState(() {
        showExperimentButtons = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tamaño de la pantalla
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      extendBodyBehindAppBar: true, // Eliminar la franja blanca
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
          // Fondo de pantalla (laboratorio actualizado)
          Positioned.fill(
            child: Image.asset(
              'assets/images/galileo/Aula_infantil.png', // Cambiar por el nuevo fondo
              fit: BoxFit.cover,
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: SideMenuAlumno(onClose: _toggleDrawer),
          ),
          Center(
            child: Stack(
              children: [
                // Contenido superpuesto en la pizarra
                Positioned(
                  top: screenSize.height * 0.1, // Ajuste para subir el texto
                  left: screenSize.width * 0.1,
                  right: screenSize.width * 0.1,
                  child: SizedBox(
                    width: screenSize.width * 0.8,
                    height: screenSize.height * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          displayedText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 18 : 22,
                            fontWeight: FontWeight.bold,
                            fontFamily:
                                'ChalkFont', // Usa la fuente personalizada
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                // Botón para iniciar la escritura letra por letra
                if (showButton)
                Align(
                  alignment: const Alignment(0.0, -0.77),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isHovered = true),
                    onExit: (_) => setState(() => isHovered = false),
                    child: AnimatedScale(
                      scale: isHovered ? 1.1 : 1.0, // Cambia el tamaño cuando el cursor está encima
                      duration: const Duration(milliseconds: 200),
                      child: ElevatedButton(
                        onPressed: () {
                          _startWritingText(fullText);
                        },
                        child: Text(
                          'Mostrar Experimentos',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Botones de experimentos que aparecen después de mostrar el texto
                if (showExperimentButtons) ...[
                  Positioned(
                    top: 350,
                    right: 205,
                    child: Opacity(
                      opacity: 1.0,
                      child: Transform.translate(
                        offset: const Offset(0, -50),
                        child: SizedBox(
                          height: 150,
                          width: 50,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero)),
                              onPressed: () {
                                _startWritingText(
                                    'EXPERIMENTO #1\n\nEste es el experimento número 1.');
                              },
                              child: const Text('')),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 340,
                    left: 330,
                    child: Opacity(
                      opacity: 1.0,
                      child: Transform.translate(
                        offset: const Offset(0, -50),
                        child: SizedBox(
                          height: 140,
                          width: 100,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero)),
                              onPressed: () {
                                _startWritingText(
                                    'EXPERIMENTO #2\n\nEste es el experimento número 2.');
                              },
                              child: const Text('')),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 240,
                    child: Opacity(
                      opacity: 1.0,
                      child: Transform.translate(
                        offset: const Offset(0, -50),
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(200))),
                              onPressed: () {
                                _startWritingText(
                                    'EXPERIMENTO #3\n\nEste es el experimento número 3.');
                              },
                              child: const Text('')),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
