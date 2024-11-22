import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class GalileoCharacterController {
  Artboard? _riveArtboard;
  SMIBool? isWalking;
  SMIBool? isSpeaking;

  Artboard? get artboard => _riveArtboard;

  Future<void> loadRiveFile() async {
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
    }

    _riveArtboard = artboard;
  }

  void toggleWalking() {
    if (isWalking != null) {
      isWalking!.value = !isWalking!.value;
    }
  }

  void toggleSpeaking() {
    if (isSpeaking != null) {
      isSpeaking!.value = !isSpeaking!.value;
    }
  }
}
