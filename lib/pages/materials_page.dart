import 'package:flutter/material.dart';

class MaterialsPage extends StatefulWidget {
  final List<String> materiales;
  const MaterialsPage({super.key, required this.materiales});

  @override
  _MaterialsPageState createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  late List<String> materiales;

  @override
  void initState() {
    super.initState();

    materiales = widget.materiales;
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/aula/fondo_aula.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: NotebookPainter(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                      child: ListView.builder(
                        itemCount: materiales.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: SizedBox(
                              height: currentHeight * 0.1,
                              child: Transform.translate(
                                offset: Offset(160, (currentHeight * 0.1)),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      materiales[index],
                                      style: TextStyle(
                                        fontSize: currentHeight * 0.05,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotebookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final linePaint = Paint()
      ..color = Colors.blue.shade400
      ..strokeWidth = 4;

    for (double i = size.height * 0.1;
        i < size.height;
        i += size.height * 0.1) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), linePaint);
    }

    final marginPaint = Paint()
      ..color = Colors.red.shade300
      ..strokeWidth = 8;

    canvas.drawLine(Offset(size.width * 0.1, 0),
        Offset(size.width * 0.1, size.height), marginPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
