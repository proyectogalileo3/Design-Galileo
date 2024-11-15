import 'dart:convert';
import 'dart:js' as js;
import 'dart:js_util' as js_util;
import 'package:design_galileo/widgets/galileo_character.dart';
import 'package:flutter/material.dart';
import 'package:design_galileo/widgets/side_menu_alumno.dart';
import 'package:flutter/services.dart';

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
  String fullText =
      'Hola, soy Galileo. Bienvenido a tu espacio de experimentos.';
  String experimentsText =
      'EXPERIMENTOS:\n\nAquí puedes ver tus experimentos asignados';
  String instructionText =
      'A continuación, haz click en la pizarra para ver los experimentos.';
  String displayedText = '';
  int currentIndex = 0;
  bool showButton = false;
  bool showExperimentText = false;
  bool showHand = true;
  bool darkBackground = false;
  bool isHovered = false;
  bool isStarted = false;
  bool isHoveredIniciar = false;
  bool showingInstructionText = false;

  final GlobalKey<GalileoCharacterState> galileoKey =
      GlobalKey<GalileoCharacterState>();

  late Map<String, Actividad> actividades;

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

    cargarActividades();
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

  void checkResponsiveVoice() {
    if (js.context.hasProperty('responsiveVoice')) {
      print("ResponsiveVoice cargado correctamente.");
    } else {
      print("Error: ResponsiveVoice no se ha cargado.");
    }
  }

  void speakText(String text) {
    Future.delayed(Duration(seconds: 1), () {
      if (js.context.hasProperty('speakWithResponsiveVoice')) {
        js.context.callMethod(
            'speakWithResponsiveVoice', [text, "Spanish Latin American Male"]);
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
    Future.delayed(
        const Duration(milliseconds: 100), () => _writeNextLetter(text));
  }

  void _writeNextLetter(String text) {
    if (currentIndex < text.length) {
      setState(() {
        displayedText += text[currentIndex];
        currentIndex++;
      });
      Future.delayed(
          const Duration(milliseconds: 30), () => _writeNextLetter(text));
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
      showButton = false;
      displayedText = experimentsText;
    });
    Future.delayed(Duration(milliseconds: 3000), () {
      setState(() {
        showExperimentText = true;
      });
    });
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        showHand = false;
      });
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
              top: screenSize.height *
                  0.35, // Ajusta este valor para subir o bajar la pizarra
              left: screenSize.width *
                  0.25, // Ajusta este valor para mover la pizarra a la izquierda o derecha
              width: screenSize.width * 0.50, // Ajusta el ancho de la pizarra
              height:
                  screenSize.height * 0.32, // Ajusta la altura de la pizarra
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
                    left: screenSize.width * 0.30,
                    right: screenSize.width * 0.30,
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
                  Positioned(
                    top: screenSize.height * 0.35,
                    left: screenSize.width * 0.37,
                    width: screenSize.width * 0.25, // Ajusta el tamaño de las listas
                    height: screenSize.height * 0.3,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Expanded(
                        child: ListView.builder(
                          itemCount: actividades.length,
                          itemBuilder: (context, index) {
                            final actividad = actividades.values.elementAt(
                                index); // Accede al valor de la actividad
                            return ExpansionTile(
                              title: Text(
                                actividad
                                    .numeroActividad, // Accede directamente al atributo
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                actividad
                                    .titulo, // Accede directamente al atributo
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    actividad
                                        .descripcion, // Accede directamente al atributo
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16.0, bottom: 8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PantallaExperimentos(
                                              actividadNumero:
                                                  actividad.numeroActividad,
                                              actividadTitulo: actividad.titulo,
                                              actividadIntroduccion:
                                                  actividad.introduccionGalileo,
                                              actividadMateriales:
                                                  actividad.materiales,
                                              actividadImagenes:
                                                  actividad.imagenes,
                                              actividadDesarrollo:
                                                  actividad.desarrollo,
                                              actividadPreguntas:
                                                  actividad.preguntasFinales,
                                              actividadConclusion:
                                                  actividad.conclusionGalileo,
                                            ),
                                          ),
                                        );
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
                if (displayedText == instructionText)
                  Positioned(
                    bottom: 50,
                    left: screenSize.width * 0.30,
                    right: screenSize.width * 0.30,
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
                if (darkBackground && showHand)
                  Positioned(
                    top: screenSize.height * 0.47,
                    left: screenSize.width * 0.20,
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
                  sizeX: 600.0,
                  sizeY: 600.0,
                  posX: 200.0,
                  posY: 30.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Actividad {
  final String numeroActividad;
  final String descripcion;
  final String titulo;
  final String explicacion;
  final List<String> introduccionGalileo;
  final List<String> conclusionGalileo;
  final List<String> preguntasFinales;
  final List<String> desarrolloGalileo;
  final List<String> preguntasIniciales;
  final List<String> imagenes;
  final List<String> materiales;
  final String grupo;
  final String nivelEducativo;
  final int trimestre;
  final List<String> desarrollo;

  Actividad({
    required this.numeroActividad,
    required this.descripcion,
    required this.titulo,
    required this.explicacion,
    required this.introduccionGalileo,
    required this.conclusionGalileo,
    required this.preguntasFinales,
    required this.desarrolloGalileo,
    required this.preguntasIniciales,
    required this.imagenes,
    required this.materiales,
    required this.grupo,
    required this.nivelEducativo,
    required this.trimestre,
    required this.desarrollo,
  });

  factory Actividad.fromJson(Map<String, dynamic> json) {
    return Actividad(
      numeroActividad: json['numero_actividad'],
      descripcion: json['descripcion'],
      titulo: json['titulo'],
      explicacion: json['explicacion'],
      introduccionGalileo: List<String>.from(json['introduccion_galileo']),
      conclusionGalileo: List<String>.from(json['conclusion_galileo']),
      preguntasFinales: List<String>.from(json['preguntas_finales']),
      desarrolloGalileo: List<String>.from(json['desarrollo_galileo']),
      preguntasIniciales: List<String>.from(json['preguntas_iniciales']),
      imagenes: List<String>.from(json['imagenes']),
      materiales: List<String>.from(json['materiales']),
      grupo: json['grupo'],
      nivelEducativo: json['nivel_educativo'],
      trimestre: json['trimestre'],
      desarrollo: List<String>.from(json['desarrollo']),
    );
  }
}

class PantallaExperimentos extends StatefulWidget {
  final String actividadNumero;
  final String actividadTitulo;
  final List<String> actividadIntroduccion;
  final List<String> actividadMateriales;
  final List<String> actividadImagenes;
  final List<String> actividadDesarrollo;
  final List<String> actividadPreguntas;
  final List<String> actividadConclusion;

  const PantallaExperimentos({
    super.key,
    required this.actividadNumero,
    required this.actividadTitulo,
    required this.actividadIntroduccion,
    required this.actividadMateriales,
    required this.actividadImagenes,
    required this.actividadDesarrollo,
    required this.actividadPreguntas,
    required this.actividadConclusion,
  });

  @override
  PantallaExperimentosState createState() => PantallaExperimentosState();
}

class PantallaExperimentosState extends State<PantallaExperimentos> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final GlobalKey<GalileoCharacterState> galileoKey =
        GlobalKey<GalileoCharacterState>();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/galileo/blackboard.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.actividadNumero,
                  style: const TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'ChalkFont',
                  ),
                ),
                const SizedBox(
                  width: 54,
                ),
                Text(
                  widget.actividadTitulo,
                  style: const TextStyle(
                    fontSize: 90,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'ChalkFont',
                  ),
                ),
              ],
            ),
          ),
          GalileoCharacter(
            key: galileoKey,
            sizeX: 750.0,
            sizeY: 750.0,
            posX: screenSize.width * 0.65,
            posY: 80.0,
          ),
          DialogBubble(
            dialogs: widget.actividadDesarrollo,
            imagePaths: widget.actividadImagenes,
          )
        ],
      ),
    );
  }
}

//
// Bocadillos de diálogo
//
class DialogBubble extends StatefulWidget {
  final List<String> dialogs;
  final List<String> imagePaths;

  const DialogBubble({
    required this.dialogs,
    required this.imagePaths,
    Key? key,
  })  : assert(dialogs.length == imagePaths.length,
            'Dialogs and images must have the same length.'),
        super(key: key);

  @override
  _DialogBubbleState createState() => _DialogBubbleState();
}

class _DialogBubbleState extends State<DialogBubble> {
  int _currentIndex = 0;

  void _nextDialog() {
    if (_currentIndex < widget.dialogs.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Imagen en la mitad superior derecha
        Positioned(
          top: screenSize.height * 0.33,
          left: screenSize.width * 0.15,
          child: Container(
            width: screenSize.width * 0.4, // Ocupa el 40% del ancho
            height: screenSize.height * 0.4, // Ocupa el 40% del alto
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(widget.imagePaths[_currentIndex]),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
        // Bocadillo de diálogo en la parte inferior izquierda
        Positioned(
          bottom: 20,
          left: 20,
          child: GestureDetector(
            onTap: _nextDialog,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: screenSize.width * 0.6,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Text(
                widget.dialogs[_currentIndex],
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
