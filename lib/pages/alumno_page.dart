import 'package:flutter/material.dart';
import 'dart:async';

import 'package:design_galileo/widgets/side_menu_alumno.dart';
import 'package:design_galileo/widgets/galileo_character.dart';

class AlumnoPage extends StatefulWidget {
  const AlumnoPage({super.key});

  @override
  AlumnoPageState createState() => AlumnoPageState();
}

class AlumnoPageState extends State<AlumnoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool isDrawerOpen = false;
  String fullText =
      'EXPERIMENTOS:\n\nAquí puedes ver tus experimentos asignados';
  String displayedText = '';
  int currentIndex = 0;
  bool showButton = true;
  bool showActionButton = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0.7, 0),
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
  void _startWritingText() {
    setState(() {
      showButton = false; // Oculta el botón al iniciar la animación
    });

    Future.delayed(const Duration(milliseconds: 100), _writeNextLetter);
  }

  void _writeNextLetter() {
    if (currentIndex < fullText.length) {
      setState(() {
        displayedText += fullText[currentIndex];
        currentIndex++;
      });

      Future.delayed(const Duration(milliseconds: 50), _writeNextLetter);
    } else {
      setState(() {
        showActionButton =
            true; // Muestra el botón "Ver Experimentos" al finalizar la escritura
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
    return Scaffold(
      body: Stack(
        children: [
          // Menú lateral
          SideMenuAlumno(onClose: _toggleDrawer),
          // Contenido principal con animación deslizante
          SlideTransition(
            position: _slideAnimation,
            child: Stack(
              children: [
                // Fondo de pantalla (laboratorio actualizado)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/galileo/Aula_infantil.png', // Cambiar por el nuevo fondo
                    fit: BoxFit.cover,
                  ),
                ),
                Scaffold(
                  backgroundColor: Colors.transparent, // Fondo transparente
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: isDrawerOpen
                        ? null
                        : IconButton(
                            icon: AnimatedIcon(
                              icon: AnimatedIcons.menu_close,
                              progress: _controller,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            onPressed: _toggleDrawer,
                          ),
                  ),
                  body: Center(
                    child: Stack(
                      children: [
                        // Contenido superpuesto en la pizarra
                        Positioned(
                          top: 200,
                          left: 0,
                          child: SizedBox(
                            width: 400,
                            height: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  displayedText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        'ChalkFont', // Usa la fuente personalizada
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 30),
                                // Botón "Ver Experimentos" que aparece al final de la animación
                                if (showActionButton)
                                  OutlinedButton(
                                    onPressed: () {
                                      // Acción para ver experimentos
                                    },
                                    child: const Text(
                                      'Ver Experimentos',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            'ChalkFont', // Usa la fuente personalizada
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // Botón para iniciar la escritura letra por letra
                        if (showButton)
                          Align(
                            alignment: const Alignment(0.0, -0.77),
                            child: ElevatedButton(
                              onPressed: _startWritingText,
                              child: const Text(
                                'Mostrar Experimentos',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        const GalileoCharacter(
                          posX: 0,
                          posY: 0,
                        ),
                      ],
                    ),
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
