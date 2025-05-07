import 'package:alspeaker/Variables/settings.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

final FlutterTts tts = FlutterTts();

Future<void> speechText(String text) async
{
  String lang = (DetectionSettings.language == "English") ? "en-us"
  : (DetectionSettings.language == "Türkçe") ? "tr-tr"
  : (DetectionSettings.language == "Español") ? "es-es"
  : (DetectionSettings.language == "中国人") ? "zh-cn" : "en-us";
  await tts.setLanguage(lang);
  await tts.setPitch(1);
  await tts.speak(text);
}

void playBeep()
{
  final player=AudioPlayer();
  player.setSource(AssetSource('sounds/beep.mp3'));
  player.play(player.source!);
}