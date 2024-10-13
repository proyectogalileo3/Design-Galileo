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
          SideMenuAlumno(onClose: _toggleDrawer),
          SlideTransition(
            position: _slideAnimation,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/galileo/laboratorio.webp',
                    fit: BoxFit.cover,
                  ),
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
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
                    child: VentanaWidget(
                      titulo: 'EXPERIMENTOS',
                      contenido: 'Aquí puedes ver tus experimentos asignados',
                      icono: Icons.science,
                      colorFondo: Colors.white.withOpacity(0.9),
                      acciones: [
                        TextButton(
                          onPressed: () {
                            // Acción simulada
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
