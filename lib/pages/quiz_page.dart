import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<dynamic> questions;
  int currentQuestionIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final String response =
        await rootBundle.loadString('assets/quizzes.json');
    final Map<String, dynamic> data = await json.decode(response);
    setState(() {
      questions = data["quiz001"]["preguntas"];
    });
  }

  void handleAnswer(String selectedOption) {
    final correctAnswer = questions[currentQuestionIndex]["respuestas"]["respuesta_correcta"];
    if (selectedOption == correctAnswer) {
      setState(() {
        score++;
      });
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Mostrar resultado
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("¡Cuestionario completado!"),
            content: Text("Tu puntuación es $score de ${questions.length}."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Volver a la página anterior
                },
                child: const Text("Volver"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];
    final options = currentQuestion["respuestas"]["opciones"] as List<dynamic>;

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
          // Contenido centrado
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 256),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xf0d95200), // Color del fondo
                  borderRadius: BorderRadius.circular(64)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(64),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Título de la pregunta
                      Text(
                        "Pregunta ${currentQuestionIndex + 1} de ${questions.length}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Pregunta
                      Text(
                        currentQuestion["pregunta"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Respuestas en 2 filas x 2 columnas
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Dos columnas
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 5.5, // Más pequeño (ancho/alto)
                        ),
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                            onPressed: () {
                              handleAnswer(options[index]);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xfff79a53),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // Bordes redondeados
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 10.0, // Espacio interno reducido
                              ),
                            ),
                            child: Text(
                              options[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24, // Texto más pequeño
                                color: Colors.white, // Texto blanco
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
