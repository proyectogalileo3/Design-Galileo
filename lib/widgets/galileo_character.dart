import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:design_galileo/controllers/galileo_character_controller.dart';
import 'dart:async';

class GalileoCharacter extends StatefulWidget {
  final double sizeX;
  final double sizeY;
  final double posX;
  final double posY;

  final VoidCallback? onWalkComplete;

  const GalileoCharacter(
      {super.key,
      this.sizeX = 500.0,
      this.sizeY = 500.0,
      this.posX = 0.0,
      this.posY = 0.0,
      this.onWalkComplete});

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

  void startWalking(double newPosX, {VoidCallback? onWalkComplete}) {
    if (posX == newPosX) {
      return; // No hay movimiento si ya está en la posición deseada
    }

    // Activa la animación de caminar
    _galileoCharacterController.setWalking(true);

    void stopWalking(Timer timer) {
      timer.cancel();

      // Cambia el estado a idle
      _galileoCharacterController.setWalking(false);

      if (onWalkComplete != null) {
        onWalkComplete();
      }
    }

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        if (posX < newPosX) {
          posX += 2.0;
          if (posX >= newPosX) {
            posX = newPosX; // Asegúrate de que no exceda la posición final
            stopWalking(timer);
          }
        } else {
          posX -= 2.0;
          if (posX <= newPosX) {
            posX = newPosX; // Asegúrate de que no exceda la posición final
            stopWalking(timer);
          }
        }
      });

      // Si el estado de caminar se desactiva externamente
      if (!_galileoCharacterController.isWalkingActive) {
        stopWalking(timer);
      }
    });
  }



  void startSpeaking(Duration audioDuration) {
    _galileoCharacterController.setSpeaking(true);
    Future.delayed(audioDuration, () {
      if (mounted) {
        setState(() {
          _galileoCharacterController.setSpeaking(false);
        });
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
