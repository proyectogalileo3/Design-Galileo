import 'package:flutter/material.dart';

class MaterialsPage extends StatefulWidget {
  final List<String> materiales;
  final List<String> imagenesMateriales;

  const MaterialsPage(
      {super.key, required this.materiales, required this.imagenesMateriales});

  @override
  MaterialsPageState createState() => MaterialsPageState();
}

class MaterialsPageState extends State<MaterialsPage> {
  late List<String> materiales;
  late List<String> imagenesMateriales;
  int currentPage = 0;
  static const int itemsPerPage = 1;

  @override
  void initState() {
    super.initState();
    materiales = widget.materiales;
    imagenesMateriales = widget.imagenesMateriales;
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;

    // Calcular los elementos de la página actual
    final startIndex = currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, materiales.length);

    // if (imagenesMateriales.isEmpty) {
      
    // }

    final currentMaterials = materiales.sublist(startIndex, endIndex);
    final currentImagenesMateriales = imagenesMateriales.isEmpty? null : imagenesMateriales.sublist(startIndex, endIndex);

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
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: currentMaterials.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: SizedBox(
                                  // height: currentHeight * 0.1,
                                  child: Transform.translate(
                                    offset: Offset(0, (currentHeight * 0.1)),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          imagenesMateriales.isEmpty
                                          ? Container(
                                            height: currentHeight * 0.6,
                                            width: currentHeight * 0.6,
                                            color: const Color(0xFFF4F4F4),
                                            child: Text(currentMaterials[index]),
                                          )
                                          :Container(
                                            height: currentHeight * 0.6,
                                            width: currentHeight * 0.6,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        currentImagenesMateriales![index])),
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 4)),
                                          ),
                                          Transform.translate(
                                            offset:
                                                Offset(currentHeight * 0.2, 0),
                                            child: SizedBox(
                                              height: currentHeight * 0.1,
                                              child: Row(
                                                children: [
                                                  // Container(
                                                  //   width: 20,
                                                  //   height: 20,
                                                  //   decoration:
                                                  //       const BoxDecoration(
                                                  //     shape: BoxShape.circle,
                                                  //     color: Colors.black,
                                                  //   ),
                                                  // ),
                                                  // const SizedBox(width: 20),
                                                  SizedBox(
                                                    width: currentHeight * .6, // Margen nombre materiales
                                                    child: Text(
                                                      currentMaterials[index],
                                                      style: TextStyle(
                                                          fontSize:
                                                              currentHeight *
                                                                  0.05,
                                                          height: 2),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Botones de navegación
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Flecha hacia la derecha
                            IconButton(
                              icon: Transform.flip(
                                flipX: true,
                                child: Image.asset(
                                  'assets/images/galileo/wooden_arrow.png',
                                  width: 96,
                                  height: 96,
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                              onPressed: currentPage > 0
                                  ? () {
                                      setState(() {
                                        currentPage--;
                                      });
                                    }
                                  : null,
                            ),
                            // Flecha hacia la izquierda
                            IconButton(
                              icon: Image.asset(
                                'assets/images/galileo/wooden_arrow.png',
                                width: 96,
                                height: 96,
                                alignment: Alignment.centerLeft,
                              ),
                              onPressed: endIndex < materiales.length
                                  ? () {
                                      setState(() {
                                        currentPage++;
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        ),

                      ],
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
