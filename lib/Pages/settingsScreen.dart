// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:alspeaker/Variables/screen_size.dart';
import 'package:alspeaker/Variables/settings.dart';
import 'package:alspeaker/Variables/camera.dart';
import 'package:alspeaker/Variables/colors.dart';
import 'package:hexcolor/hexcolor.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:alspeaker/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static final GlobalKey<_SettingsScreenState> globalKey = GlobalKey<_SettingsScreenState>();

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String ab = "";
  String ba = "";
  List<String> log = [];

  void updateStatus()
  {
    setState(() {
      ab = DetectionSettings.eyeDirection;
      ba = DetectionSettings.overalloss;

      if (ab == 'straight') { ab = LocaleKeys.straight.tr(); }
      if (ab == 'rightup') { ab = LocaleKeys.rightup.tr(); }
      if (ab == 'leftup') { ab = LocaleKeys.leftup.tr(); }
      if (ab == 'up') { ab = LocaleKeys.up.tr(); }
      if (ab == 'down') { ab = LocaleKeys.down.tr(); }
      if (ab == 'rightdown') { ab = LocaleKeys.rightdown.tr(); }
      if (ab == 'leftdown') { ab = LocaleKeys.leftdown.tr(); }

      log.add("$ab - $ba");
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      ab = DetectionSettings.eyeDirection;
      ba = DetectionSettings.overalloss;

      if (ab == 'straight') { ab = LocaleKeys.straight.tr(); }
      if (ab == 'rightup') { ab = LocaleKeys.rightup.tr(); }
      if (ab == 'leftup') { ab = LocaleKeys.leftup.tr(); }
      if (ab == 'up') { ab = LocaleKeys.up.tr(); }
      if (ab == 'down') { ab = LocaleKeys.down.tr(); }
      if (ab == 'rightdown') { ab = LocaleKeys.rightdown.tr(); }
      if (ab == 'leftdown') { ab = LocaleKeys.leftdown.tr(); }
    });
    print('infoW - (Entry) $ab - $ba');
    return SizedBox(
      width: ScreenSize.W,
      height: ScreenSize.H,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Container(
                  color: Colors.transparent,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${LocaleKeys.overallgazetype.tr()}: $ab",
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                            Text(
                              "${LocaleKeys.overallloss.tr()}: ${ba.length > 12 ? ba.substring(0, 12) : ba}",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.only(top: 50.0)),
                              Container(
                                width: 200,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: dark1,
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(padding: EdgeInsets.only(top: 8.0)),
                                    Text(
                                      DetectionSettings.camEnabled ? LocaleKeys.cameraon.tr() : LocaleKeys.cameraoff.tr(),
                                      style: TextStyle(fontSize: 21, color: Colors.white),
                                    ),
                                    Switch(
                                      value: DetectionSettings.camEnabled,
                                      onChanged: (value) async {
                                        print('infoW (settingsScreen)1 - value1:${DetectionSettings.camEnabled} / value2: $value');
                                        if (value)
                                        {
                                          await DetectorCam.initializeCamera();
                                          setState(() {
                                            DetectionSettings.camEnabled = value;
                                          });
                                        }
                                        else
                                        {
                                          setState(() {
                                            DetectionSettings.camEnabled = value;
                                          });
                                          await DetectorCam.disposeCam();
                                        }
                                      },
                                      activeColor: Colors.green,
                                      inactiveThumbColor: Colors.grey,
                                      inactiveTrackColor: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Row(
                      children: [
                        Container(
                          width: 200,
                          height: 280,
                          decoration: BoxDecoration(
                            color: dark4,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),  // Sol üst köşe // Sağ üst köşe
                              bottomLeft: Radius.circular(30), // Sol alt köşe // Sağ alt köşe
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                            child: SizedBox(
                              child: SingleChildScrollView(
                                child: Text(
                                  log.join('\n'),
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 320,
                          height: 280,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),  // Sol üst köşe // Sağ üst köşe
                              bottomRight: Radius.circular(30), // Sol alt köşe // Sağ alt köşe
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 25.0, right: 25.0),
                            child: DetectorCam.showCamera(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
            Column( // Ayarlar Kısmı
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 301,
                      child: Center(
                        child: Text(
                          "${LocaleKeys.sensitivity.tr()} ${DetectionSettings.sensitivity.toString().replaceAll('.0', '')}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 400,
                      child: Slider(
                        value: DetectionSettings.sensitivity, // Slider'ın mevcut değeri
                        min: 1.0, // Minimum değer
                        max: 100.0, // Maksimum değer
                        divisions: 99, // Bölme sayısı
                        thumbColor: HexColor("#038786"),
                        activeColor: HexColor("#038786"),
                        onChanged: (double newValue) {
                          setState(() {
                            DetectionSettings.sensitivity = newValue; // Yeni değeri set et
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 301,
                      child: Center(
                        child: Text(
                          LocaleKeys.language.tr(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: HexColor("#b8d9d7"),
                        borderRadius: BorderRadius.all(Radius.circular(14.0))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 4.0, right: 4.0, bottom: 4.0),
                        child: DropdownButton<String>(
                          value: DetectionSettings.language, // Şu anda seçili olan değer
                          onChanged: (String? newValue) {
                            setState(() {
                              DetectionSettings.language = newValue!;
                              if (newValue == "Türkçe")
                              {
                                print('TRTRTRTRTTRTRT');
                                context.setLocale(Locale('tr', 'TR'));
                              }
                              if (newValue == "English")
                              {
                                context.setLocale(Locale('en', 'US'));
                              }
                              if (newValue == "Español")
                              {
                                context.setLocale(Locale('es', 'ES'));
                              }
                              if (newValue == "中国人")
                              {
                                print('ZHZHZHZHZHZHZHZH');
                                context.setLocale(Locale('zh', 'ZH'));
                              }
                              if (newValue == "Русский")
                              {
                                print('RURURURURURURURURUR');
                                context.setLocale(Locale('ru', 'RU'));
                              }
                              if (newValue == "Deutsch")
                              {
                                context.setLocale(Locale('de', 'DE'));
                              }
                            });
                          },
                          items: ['Türkçe', 'English', 'Español', '中国人', 'Русский', 'Deutsch'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 301,
                      child: Center(
                        child: Text(
                          LocaleKeys.textentrymode.tr(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: HexColor("#b8d9d7"),
                        borderRadius: BorderRadius.all(Radius.circular(14.0))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 4.0, right: 4.0, bottom: 4.0),
                        child: DropdownButton<String>(
                          value: DetectionSettings.entryMode, // Şu anda seçili olan değer
                          onChanged: (String? newValue) {
                            setState(() {
                              DetectionSettings.entryMode = newValue!;
                            });
                          },
                          items: ['Letter by Letter', 'Ambiguous Keyboard Only', 'Ambiguous Keyboard + LLM'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 301,
                      child: Text(
                        LocaleKeys.sentencegenmodel.tr(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24
                        ),
                      ),
                    ),
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: HexColor("#b8d9d7"),
                        borderRadius: BorderRadius.all(Radius.circular(14.0))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 4.0, right: 4.0, bottom: 4.0),
                        child: DropdownButton<String>(
                          value: DetectionSettings.genModel, // Şu anda seçili olan değer
                          onChanged: (String? newValue) {
                            setState(() {
                              DetectionSettings.genModel = newValue!;
                            });
                          },
                          items: ['Gemini 1.5', 'ChatGPT 3.5'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 30)),
          ],
        ),
      ),
    );
  }
}