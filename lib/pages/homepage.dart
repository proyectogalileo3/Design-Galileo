import 'dart:convert';

import 'package:design_galileo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import 'package:design_galileo/widgets/galileo_character.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Map<String, Actividad> actividades;

  final player = AudioPlayer();

  final GlobalKey<GalileoCharacterState> galileoKey =
      GlobalKey<GalileoCharacterState>();

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

  Future<void> playTextToSpeech(String text) async {
    String voiceBill = 'pqHfZKP75CvOlQylNhV4';

    String url = 'https://api.elevenlabs.io/v1/text-to-speech/$voiceBill';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'accept': 'audio/mpeg',
        'xi-api-key': elevenlabsAPIKey,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "text": text,
        "model_id": "eleven_multilingual_v1",
        "voice_settings": {
          "stability": .95,
          "similarity_boost": .15,
        }
      }),
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes; //get the bytes ElevenLabs sent back
      await player.setAudioSource(AudioSource(
          bytes)); //send the bytes to be read from the JustAudio library
      player.play(); //play the audio
    } else {
      // throw Exception('Failed to load audio');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    // final screenSize = MediaQuery.of(context).size;

    double lateralButtonsHeight = 360;

    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/aula/fondo_aula.png'),
              fit: BoxFit.cover)),
      child: Stack(
        children: [
          Row(
            children: [
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
                          height: lateralButtonsHeight,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/aula/quiz.png'),
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
                                          final actividad = actividades.values
                                              .elementAt(index);
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
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0,
                                                          bottom: 8.0),
                                                  child: ElevatedButton(
                                                    onPressed: () {},
                                                    child:
                                                        const Text('Empezar'),
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
                          height: lateralButtonsHeight * 1.1,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/aula/autoevaluacion.png'),
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
            ],
          ),
          const GalileoCharacter(
            sizeX: 1000,
            sizeY: 1000,
            posX: 800,
          ),
          Positioned(
              bottom: currentHeight * 0.1,
              left: currentWidth * 0.5,
              child: ElevatedButton(
                  onPressed: () {
                    // galileoKey.currentState?.startSpeaking();
                    // playTextToSpeech(
                    //     'Hola, me llamo Galileo. ¡Bienvenido al laboratorio!');
                  },
                  child: const Text('Hablar')))
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

class AudioSource extends StreamAudioSource {
  final List<int> bytes;
  AudioSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}

// class SideButton extends StatefulWidget {
//   final String imageBackground;
//   final double scale;
//   const SideButton({super.key, required this.imageBackground, this.scale});

//   @override
//   SideButtonState createState() => SideButtonState();
// }

// class SideButtonState extends State<SideButton> {}
