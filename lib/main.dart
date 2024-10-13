import 'package:flutter/material.dart';
import 'package:design_galileo/pages/alumno_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Diseño',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AlumnoPage(),
    );
  }
}
