import 'package:flutter/material.dart';

class SideMenuAlumno extends StatelessWidget {
  final VoidCallback onClose;

  const SideMenuAlumno({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: screenWidth * 0.7,
      color: Colors.yellow[200],
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, size: 30, color: Colors.black),
                onPressed: onClose,
              ),
            ),
            const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 60,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nombre del Alumno',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Curso del Alumno',
              style: TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const Divider(color: Colors.black54),
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
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        label,
        style: const TextStyle(fontSize: 18, color: Colors.black),
      ),
      onTap: onTap,
    );
  }
}
