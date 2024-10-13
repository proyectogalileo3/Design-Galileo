import 'package:flutter/material.dart';

class AvatarAlumno extends StatelessWidget {
  final Function(String) onAvatarAlumno;

  AvatarAlumno({required this.onAvatarAlumno});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Selector Avatar alumno',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: screenHeight * 0.4,
            width: screenWidth * 0.8,
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 15,
              itemBuilder: (context, index) {
                final avatarPath = 'avatar${index + 1}.webp';
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(avatarPath);
                  },
                  child: Image.asset('assets/images/avataralumnos/$avatarPath'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ),
        ],
      ),
    );
  }
}
