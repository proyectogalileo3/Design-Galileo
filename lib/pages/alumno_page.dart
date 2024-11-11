import 'package:design_galileo/widgets/galileo_character.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:design_galileo/widgets/side_menu_alumno.dart';

class AlumnoPage extends StatefulWidget {
  const AlumnoPage({super.key});

  @override
  AlumnoPageState createState() => AlumnoPageState();
}

class AlumnoPageState extends State<AlumnoPage>
    with TickerProviderStateMixin {
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
  bool showExperimentButtons = false;
  int currentExperiment = 1; // Variable para controlar el experimento actual

  final GlobalKey<GalileoCharacterState> galileoKey =
      GlobalKey<GalileoCharacterState>();

  // Animación para la mano
  late AnimationController _handScaleController;
  late Animation<double> _handScaleAnimation;

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

    // Inicializar la animación de la mano
    _handScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _handScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _handScaleController, curve: Curves.easeInOut),
    );
  }

  void _startHandScaleAnimation() {
    _handScaleController.repeat(reverse: true);
  }

  void _stopHandScaleAnimation() {
    _handScaleController.stop();
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
      showExperimentButtons = false;
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
      if (currentExperiment == 1) {
        _startHandScaleAnimation(); // Iniciar la animación de la mano
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _handScaleController.dispose(); // Dispose del controlador de la mano
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
                        scale: isHovered
                            ? 1.1
                            : 1.0, // Cambia el tamaño cuando el cursor está encima
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
                  // Experimento #1
                  Positioned(
                    top: 350,
                    right: 205,
                    child: GestureDetector(
                      onTap: currentExperiment == 1
                          ? () {
                              _stopHandScaleAnimation();
                              _startWritingText(
                                  'EXPERIMENTO #1\n\nEste es el experimento número 1.');
                              setState(() {
                                currentExperiment = 2;
                              });
                              _startHandScaleAnimation();
                            }
                          : null,
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Área clicable transparente
                            Container(
                              color: Colors.transparent,
                              height: 150,
                              width: 150,
                            ),
                            // Mostrar la mano si es el experimento actual
                            if (currentExperiment == 1)
                              AnimatedBuilder(
                                animation: _handScaleAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _handScaleAnimation.value,
                                    child: child,
                                  );
                                },
                                child: Image.asset(
                                  'assets/images/galileo/mano.png', // Reemplaza con la ruta correcta de tu mano.png
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Experimento #2
                  Positioned(
                    top: 340,
                    left: 280,
                    child: GestureDetector(
                      onTap: currentExperiment == 2
                          ? () {
                              _stopHandScaleAnimation();
                              _startWritingText(
                                  'EXPERIMENTO #2\n\nEste es el experimento número 2.');
                              setState(() {
                                currentExperiment = 3;
                              });
                              _startHandScaleAnimation();
                            }
                          : null,
                      child: SizedBox(
                        height: 140,
                        width: 150,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Área clicable transparente
                            Container(
                              color: Colors.transparent,
                              height: 140,
                              width: 150,
                            ),
                            // Mostrar la mano si es el experimento actual
                            if (currentExperiment == 2)
                              AnimatedBuilder(
                                animation: _handScaleAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _handScaleAnimation.value,
                                    child: child,
                                  );
                                },
                                child: Image.asset(
                                  'assets/images/galileo/mano.png', // Reemplaza con la ruta correcta de tu mano.png
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Experimento #3
                  Positioned(
                    top: 5,
                    right: 240,
                    child: GestureDetector(
                      onTap: currentExperiment == 3
                          ? () {
                              _stopHandScaleAnimation();
                              _startWritingText(
                                  'EXPERIMENTO #3\n\nEste es el experimento número 3.');
                              setState(() {
                                currentExperiment = 4; // No hay más experimentos
                              });
                            }
                          : null,
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Área clicable transparente
                            Container(
                              color: Colors.transparent,
                              height: 200,
                              width: 200,
                            ),
                            // Mostrar la mano si es el experimento actual
                            if (currentExperiment == 3)
                              AnimatedBuilder(
                                animation: _handScaleAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _handScaleAnimation.value,
                                    child: child,
                                  );
                                },
                                child: Image.asset(
                                  'assets/images/galileo/mano.png', // Reemplaza con la ruta correcta de tu mano.png
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                GalileoCharacter(
                  key: galileoKey,
                  posX: 1000.0,
                  posY: 0,
                ),
                Positioned(
                  bottom: screenSize.height * 0.05,
                  left: screenSize.width * 0.05,
                  child: ElevatedButton(
                      onPressed: galileoKey.currentState?.startWalking,
                      child: const Text('Caminar')),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
