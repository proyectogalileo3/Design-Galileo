import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Map<String, Actividad> actividades;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    // final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    // final screenSize = MediaQuery.of(context).size;

    double lateralButtonsHeight = 360;

    return Scaffold(
        // backgroundColor: Colors.deepPurple.shade300,
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/aula/fondo_aula.png'),
              fit: BoxFit.cover)),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                      child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: lateralButtonsHeight,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/aula/quiz.png'),
                              fit: BoxFit.contain)),
                    ),
                  )),
                  Expanded(
                      child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: lateralButtonsHeight,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/aula/curiosidades.png'),
                              fit: BoxFit.contain)),
                    ),
                  )),
                ],
              )),
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: currentHeight * 0.75,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/aula/pizarra.png'),
                                      fit: BoxFit.contain)),
                              child: Padding(
                                // padding: const EdgeInsets.symmetric(
                                //     vertical: 130.0, horizontal: 96.0),
                                padding: const EdgeInsets.only(
                                    top: 131.0,
                                    bottom: 180.0,
                                    left: 96.0,
                                    right: 96.0),
                                child: Expanded(
                                  child: ListView.builder(
                                    itemCount: actividades.length,
                                    itemBuilder: (context, index) {
                                      final actividad =
                                          actividades.values.elementAt(index);
                                      return ExpansionTile(
                                        title: Text(
                                          actividad.numeroActividad,
                                          style: const TextStyle(
                                              fontSize: 36,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          actividad.titulo,
                                          style: const TextStyle(
                                              fontSize: 32,
                                              color: Colors.white),
                                        ),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            child: Text(
                                              actividad.descripcion,
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16.0, bottom: 8.0),
                                              child: ElevatedButton(
                                                onPressed: () {},
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
                          ))),
                ],
              )),
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                      child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: lateralButtonsHeight * 1.2,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/aula/materiales.png'),
                              fit: BoxFit.contain)),
                    ),
                  )),
                  Expanded(
                      child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: lateralButtonsHeight * 1.2,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/aula/autoevaluacion.png'),
                              fit: BoxFit.contain)),
                    ),
                  )),
                ],
              )),
        ],
      ),
    ));
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
