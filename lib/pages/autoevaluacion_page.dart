import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AutoevaluacionPage extends StatefulWidget {
  const AutoevaluacionPage({super.key});

  @override
  _AutoevaluacionPageState createState() => _AutoevaluacionPageState();
}

class _AutoevaluacionPageState extends State<AutoevaluacionPage> {
  late List<dynamic> preguntas;
  Map<String, dynamic>? currentAutoevaluacion;

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

  @override
  Widget build(BuildContext context) {
    if (currentAutoevaluacion == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
          // Contenido de la autoevaluación
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
                  // Preguntas
                  Expanded(
                    child: ListView.builder(
                      itemCount: preguntas.length,
                      itemBuilder: (context, index) {
                        final pregunta = preguntas[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            color: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pregunta["pregunta"],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: (pregunta["escala"] as List<dynamic>)
                                        .map((e) => GestureDetector(
                                              onTap: () {
                                                // Lógica de respuesta (opcional)
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.blue,
                                                child: Text(
                                                  e.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
