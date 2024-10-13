import 'package:flutter/material.dart';

class VentanaWidget extends StatelessWidget {
  final String titulo;
  final String contenido;
  final IconData icono;
  final Color colorFondo;
  final List<Widget> acciones;

  const VentanaWidget({
    super.key,
    required this.titulo,
    required this.contenido,
    required this.icono,
    required this.colorFondo,
    required this.acciones,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 50),
          const SizedBox(height: 20),
          Text(
            titulo,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(contenido, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: acciones,
          ),
        ],
      ),
    );
  }
}
