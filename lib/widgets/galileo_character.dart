import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:design_galileo/controllers/galileo_character_controller.dart';
import 'dart:async';

class GalileoCharacter extends StatefulWidget {
  final double sizeX;
  final double sizeY;
  final double posX;
  final double posY;

  const GalileoCharacter(
      {super.key,
      this.sizeX = 500.0,
      this.sizeY = 500.0,
      this.posX = 0.0,
      this.posY = 0.0});

  @override
  GalileoCharacterState createState() => GalileoCharacterState();
}

class GalileoCharacterState extends State<GalileoCharacter> {
  final GalileoCharacterController _galileoCharacterController =
      GalileoCharacterController();

  late double sizeX;
  late double sizeY;
  late double posX;
  late double posY;

  @override
  void initState() {
    super.initState();

    sizeX = widget.sizeX;
    sizeY = widget.sizeY;
    posX = widget.posX;
    posY = widget.posY;

    _loadRive();
  }

  Future<void> _loadRive() async {
    await _galileoCharacterController.loadRiveFile();
    setState(() {});
  }

  void startWalking() {
    if (posX <= 0.0) {
      return;
    }
    _galileoCharacterController.toggleWalking();

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        if (posX <= 0.0) {
          timer.cancel();
          _galileoCharacterController.toggleWalking();
        }
        posX -= 2.0;
      });

      if (_galileoCharacterController.isWalking != null &&
          !_galileoCharacterController.isWalking!.value) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: posY,
      left: posX,
      child: _galileoCharacterController.artboard == null
          ? const SizedBox()
          : SizedBox(
              height: sizeY,
              width: sizeX,
              child: Rive(
                artboard: _galileoCharacterController.artboard!,
              ),
            ),
    );
  }
}
