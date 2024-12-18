import 'package:flutter/material.dart';

class SideMenuAlumno extends StatelessWidget {
  final VoidCallback onClose;

  const SideMenuAlumno({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          // Fondo de pantalla (cielo estrellado)
          Positioned.fill(
            child: Image.asset(
              'assets/images/galileo/fondosidemenu.jpg', // Imagen del cielo estrellado
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 50,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nombre del Alumno',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Curso del Alumno',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const Divider(color: Colors.white),
                _buildMenuOption(
                  icon: Icons.logout,
                  label: 'Cerrar Sesión',
                  onTap: () {
                    // Acción simulada
                  },
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Versión 1.0.0',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
