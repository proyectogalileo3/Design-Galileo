import 'package:design_galileo/main.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'dart:convert';

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


Future<Duration> playTextToSpeech(AudioPlayer player, String text) async {
  const voiceID = 'pqHfZKP75CvOlQylNhV4';
  const url = 'https://api.elevenlabs.io/v1/text-to-speech/$voiceID';

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'accept': 'audio/mpeg',
      // 'xi-api-key': elevenlabsAPIKey,
      'Content-Type': 'application/json',
    },
    body: json.encode({
      "text": text,
      "model_id": "eleven_multilingual_v1",
      "voice_settings": {
        "stability": .85,
        "similarity_boost": .15,
      }
    }),
  );

  if (response.statusCode == 200) {
    final bytes = response.bodyBytes;
    final audioDuration =
        await player.setAudioSource(AudioSource(bytes)) ?? Duration.zero;

    // print(audioDuration);

    player.play();

    return audioDuration;
  } else {
    print('Error al generar audio: ${response.body}');
    return Duration.zero;
  }
}