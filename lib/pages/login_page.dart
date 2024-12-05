import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bool isMobile = screenWidth < 600;

    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
            child: Image.asset('assets/images/galileo/image.webp',
                fit: BoxFit.cover)),
        Center(
          child: Container(
            width: isMobile ? screenWidth * 0.9 : 400,
            height: isMobile ? screenHeight * 0.6 : 500,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Image.asset('assets/images/icons/logo_app.png'),
                ),
                Text(
                  'Proyecto Galileo',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Login'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {},
                  child: const Text('Create an Account'),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
