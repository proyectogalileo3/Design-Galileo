import 'package:flutter/material.dart';
import 'package:design_galileo/pages/login_page.dart';
// import 'package:design_galileo/pages/homepage.dart';
// import 'package:design_galileo/pages/alumno_page.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

String elevenlabsAPIKey = dotenv.env['ELEVENLABS_API_KEY'] as String;

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campo de juego',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      // home: const HomePage(),
      home: const LoginPage(),
    );
  }
}
