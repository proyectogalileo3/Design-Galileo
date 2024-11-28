import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AutoevaluacionPage extends StatefulWidget {
  const AutoevaluacionPage({super.key});

  @override
  _AutoevaluacionPageState createState() => _AutoevaluacionPageState();
}

class _AutoevaluacionPageState extends State<AutoevaluacionPage> {
  late List<dynamic> preguntas;
  Map<String, dynamic>? currentAutoevaluacion;
  int currentQuestionIndex = 0; // Índice de la pregunta actual
  Map<int, double> ratings = {}; // Ratings seleccionados por el usuario

  @override
  void initState() {
    super.initState();
    loadAutoevaluacion();
  }

  Future<void> loadAutoevaluacion() async {
    final String response =
        await rootBundle.loadString('assets/autoevaluaciones.json');
    final Map<String, dynamic> data = json.decode(response);
    setState(() {
      currentAutoevaluacion = data["autoeva001"]; // Selección por defecto
      preguntas = currentAutoevaluacion!["preguntas_autoevaluacion"];
    });
  }

  void handleRating(double rating) {
    setState(() {
      ratings[currentQuestionIndex] = rating; // Guardar el rating
      if (currentQuestionIndex < preguntas.length - 1) {
        currentQuestionIndex++; // Pasar a la siguiente pregunta
      } else {
        // Mostrar resumen
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Autoevaluación completada"),
              content: Text("¡Gracias por completar la autoevaluación!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Volver a la página anterior
                  },
                  child: const Text("Finalizar"),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentAutoevaluacion == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentPregunta = preguntas[currentQuestionIndex];

    return Scaffold(
      body: Stack(
        children: [
          // Fondo principal
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/aula/fondo_aula.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Botón de volver atrás
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.05,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 56),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Contenido de la pregunta
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Título
                  Text(
                    currentAutoevaluacion!["titulo"],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Pregunta actual
                  Text(
                    currentPregunta["pregunta"],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  // Rating con estrellas
                  RatingBar.builder(
                    initialRating: ratings[currentQuestionIndex] ?? 0,
                    minRating: 1,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      handleRating(rating);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
