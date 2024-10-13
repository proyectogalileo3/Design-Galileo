import 'package:flutter/material.dart';
import 'package:design_galileo/widgets/side_menu_alumno.dart';
import 'package:design_galileo/widgets/ventana_widget.dart';

class AlumnoPage extends StatefulWidget {
  const AlumnoPage({super.key});

  @override
  _AlumnoPageState createState() => _AlumnoPageState();
}

class _AlumnoPageState extends State<AlumnoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds:
              300), // Controla la duración de la animación del menú lateral
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0), // Posición inicial del contenido
      end: const Offset(0.7, 0), // Desplazamiento cuando el menú está abierto
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Tipo de curva para una animación suave
    ));
  }

  // Método para abrir y cerrar el menú lateral
  void _toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        _controller.forward(); // Abre el menú
      } else {
        _controller.reverse(); // Cierra el menú
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Libera recursos del controlador de animación
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
                // Fondo de pantalla
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/galileo/laboratorio.webp', // Esta es la imagen estática la cuál debéis cambiar
                    fit: BoxFit
                        .cover, // Ajusta el fondo para que cubra toda la pantalla
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
                              icon: AnimatedIcons
                                  .menu_close, // Icono animado del menú
                              progress: _controller,
                              color: Colors.white,
                              size:
                                  40.0, // Tamaño del icono, pueden cambiarlo si quieren más pequeño o grande
                            ),
                            onPressed:
                                _toggleDrawer, // Acción para abrir/cerrar el menú
                          ),
                  ),
                  body: Center(
                    // Widget personalizado que muestra el contenido principal, se puede cambiar por la pizarra interactiva como dijimos
                    child: VentanaWidget(
                      titulo:
                          'EXPERIMENTOS', // Cambien el título si es necesario
                      contenido: 'Aquí puedes ver tus experimentos asignados',
                      icono: Icons.science,
                      colorFondo: Colors.white.withOpacity(0.9),
                      acciones: [
                        TextButton(
                          onPressed: () {
                            // Esto da igual, no importa que no vaya a la siguiente pantalla, centraos en el diseño de la pantalla en sí
                          },
                          child: const Text(
                            'Ver Experimentos',
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
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
