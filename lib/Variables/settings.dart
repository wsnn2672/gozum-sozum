import 'package:alspeaker/Pages/quickScreen.dart';
import 'package:alspeaker/Variables/page.dart';
import 'package:alspeaker/Pages/entryScreen.dart';
import 'package:alspeaker/Pages/settingsScreen.dart';

class DetectionSettings
{
  static bool camEnabled = false;
  static String language = "Türkçe";
  static String entryMode = "Ambiguous Keyboard + LLM";
  static String genModel = "Gemini 1.5";
  static double sensitivity = 20.00;
  static String eyeDirection = "straight";
  static String overalloss = "0.00";
  static String selectedEye = "right";
  static List<String> directions = ["straight", "rightup", "leftup", "up", "down" ,"rightdown", "leftdown"];

  static void activityDetected(String direction)
  {
    print('infoW - (settings.dart) $eyeDirection - $overalloss');
    if (selectedPage == 0)
    {
      print('infoW - (settings.dart): $direction tetiklendi.');
      SettingsScreen.globalKey.currentState?.updateStatus();
    }
    if (selectedPage == 1)
    {
      print('infoW - (settings.dart): $direction tetiklendi.');
      if (direction == 'leftup') { QuickScreen.globalKey.currentState?.tapBtn0(); }
      if (direction == 'rightup') { QuickScreen.globalKey.currentState?.tapBtn2(); }
      if (direction == 'leftdown') { QuickScreen.globalKey.currentState?.tapBtn3(); }
      if (direction == 'rightdown') { QuickScreen.globalKey.currentState?.tapBtn5(); }
      if (direction == 'up') { QuickScreen.globalKey.currentState?.tapBtn1(); }
      if (direction == 'closed') { QuickScreen.globalKey.currentState?.tapBtn4(); }
    }
    else if (selectedPage == 2)
    {
      print('infoW - (settings.dart): $direction tetiklendi.');
      if (direction == 'leftup') { EntryScreen.globalKey.currentState?.keyboardTap(0); }
      if (direction == 'rightup') { EntryScreen.globalKey.currentState?.keyboardTap(1); }
      if (direction == 'leftdown') { EntryScreen.globalKey.currentState?.keyboardTap(2); }
      if (direction == 'rightdown') { EntryScreen.globalKey.currentState?.nextTap(); }
      if (direction == 'up') { EntryScreen.globalKey.currentState?.finishTap(); }
      if (direction == 'closed') { EntryScreen.globalKey.currentState?.switchTap(); }
    }
  }
}