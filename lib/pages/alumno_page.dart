import 'package:flutter/material.dart';
import 'package:design_galileo/widgets/side_menu_alumno.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:rive/rive.dart' hide Image;

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

  SMIBool? isWalking;
  Artboard? _riveArtboard;
  double characterX = 500.0;

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/images/galileo/galileo.riv').then((data) async {
      await RiveFile.initialize();
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;

      final controller =
          StateMachineController.fromArtboard(artboard, 'State Machine 1');

      if (controller != null) {
        artboard.addController(controller);
        isWalking = controller.findInput<bool>('isWalking') as SMIBool?;
      }

      setState(() => _riveArtboard = artboard);
    });

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

  void _toggleWalking() {
    if (isWalking != null) {
      setState(() {
        isWalking!.value = !isWalking!.value;
      });
    }
  }

  void _startWalking() {
    _toggleWalking();

    if (isWalking != null && isWalking!.value) {
      Timer.periodic(const Duration(milliseconds: 16), (timer) {
        setState(() {
          if (characterX <= 40.0) {
            timer.cancel();
            _toggleWalking();
          }
          characterX -= 2;
        });

        if (isWalking != null && !isWalking!.value) {
          timer.cancel();
        }
      });
    }
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
                    'assets/images/galileo/nuevolaboratorio.png', // Cambiar por el nuevo fondo
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
                                      _startWalking();
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
                        // Añadir imagen en la esquina inferior derecha
                        Positioned(
                          bottom: 0,
                          left: characterX,
                          child: _riveArtboard == null
                              ? const SizedBox()
                              : SizedBox(
                                  height: 500,
                                  width: 500,
                                  child: Rive(
                                    artboard: _riveArtboard!,
                                  ),
                                ),
                        ),
                        // Positioned(
                        //   bottom: 20,
                        //   left: 20,
                        //   child: ElevatedButton(
                        //     // onPressed: () {},
                        //     onPressed: _startWalking,
                        //     child: const Text('Caminar'),
                        //   ),
                        // ),
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
