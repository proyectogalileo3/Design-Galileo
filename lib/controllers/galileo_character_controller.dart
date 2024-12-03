import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class GalileoCharacterController {
  Artboard? _riveArtboard;
  SMIBool? isWalking;
  SMIBool? isSpeaking;

  Artboard? get artboard => _riveArtboard;

  Future<void> loadRiveFile() async {
  try {
    await RiveFile.initialize();

    final data = await rootBundle.load('assets/images/galileo/galileo.riv');
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;

    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    if (controller != null) {
      artboard.addController(controller);
      isWalking = controller.findInput<bool>('isWalking') as SMIBool?;
      isSpeaking = controller.findInput<bool>('isSpeaking') as SMIBool?;
    } else {
      throw Exception('State Machine Controller not found.');
    }

    _riveArtboard = artboard;
  } catch (e) {
    debugPrint('Error loading Rive file: $e');
  }
}


  void setWalking(bool value) {
    if (isWalking != null) {
      isWalking!.value = value;
    }
  }

  void setSpeaking(bool value) {
    if (isSpeaking != null) {
      isSpeaking!.value = value;
    }
  }

  bool get isWalkingActive => isWalking?.value ?? false;
  bool get isSpeakingActive => isSpeaking?.value ?? false;
}
