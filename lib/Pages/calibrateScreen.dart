// ignore_for_file: file_names

import 'package:alspeaker/Variables/camera.dart';
import 'package:alspeaker/Variables/colors.dart';
import 'package:alspeaker/Variables/settings.dart';
import 'package:flutter/material.dart';
import 'package:alspeaker/Variables/screen_size.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:alspeaker/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class CalibrateScreen extends StatefulWidget {
  const CalibrateScreen({super.key});

  @override
  State<CalibrateScreen> createState() => _CalibrateScreenState();
}

class _CalibrateScreenState extends State<CalibrateScreen> {
  int _currentStep = 0;

  Future<void> _captureAndCropEye() async {
    print('infoW - CAPTURE AND CROP EYE CALISTI!');
    final imagePath = await DetectorCam.getPicture();

    if (imagePath != null) {
      final croppedPath = await _processImage(imagePath, DetectionSettings.selectedEye, DetectionSettings.directions[_currentStep]);

      if (croppedPath != null) {
        if (_currentStep < DetectionSettings.directions.length - 1) {
          setState(() {
            _currentStep++;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.calibrationDone.tr())),
        );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.calibrationFailed.tr())),
        );
      }
    }
  }

  Future<String?> _processImage(String imagePath, String selectedEye, String direction) async {
    try {
      const platform = MethodChannel('opencv');
      final String? croppedPath = await platform.invokeMethod('processImage', {"path": imagePath, "eye": selectedEye, "direction": direction});
      return croppedPath;
    } on MissingPluginException catch (e) {
      print("Error processing image: ${e.message}");
      return null;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    setState(() {
      DetectionSettings.camEnabled = DetectionSettings.camEnabled;
      DetectionSettings.directions = DetectionSettings.directions;
    });
    return SizedBox(
      width: ScreenSize.W,
      height: ScreenSize.H,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "${LocaleKeys.wantedinfo.tr()}\n${LocaleKeys.wantedDirection.tr()}: ${DetectorCam.directions[_currentStep]}\n(${LocaleKeys.selectedEye.tr()}: ${DetectionSettings.selectedEye == "right" ? LocaleKeys.right.tr() : LocaleKeys.left.tr()})", 
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      DetectionSettings.selectedEye = (DetectionSettings.selectedEye == 'right') ? 'left' : 'right';
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: dcblue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                                  ),
                                  child: Text(
                                    LocaleKeys.changeEye.tr(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                                ElevatedButton(
                                  onPressed: _captureAndCropEye,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: dcblue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                                  ),
                                  child: Text(
                                    LocaleKeys.calibrate.tr(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 20.0)),
                      Container(
                        width: 320,
                        height: 280,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 25.0, right: 25.0),
                          child: DetectorCam.showCamera(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 16.0)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.calibrationDatas.tr(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 8.0)),
            Container(
              color: dark4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) => eyePicture(DetectionSettings.directions[index])),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) => eyePicture(DetectionSettings.directions[index + 4])),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.0))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget eyePicture(String dir)
  {
    Future<String?> getImagePath() async {
      try {
        final directory = await getApplicationDocumentsDirectory();
        if (directory.path.isNotEmpty) {
          String path = '${directory.path}/${dir}_cropped.jpg'.replaceAll('app_flutter', 'files');
          
          if (await File(path).exists())
          {
            return path;
          }
          else {
            return null;
          }
        }
      } catch (e) {
        print("Dosya yolu alınırken hata oluştu: $e");
      }
      return null; // Eğer hata olursa null döndür
    }

    String title = "";

    if (dir == 'straight') { title = LocaleKeys.straight.tr(); }
    if (dir == 'rightup') { title = LocaleKeys.rightup.tr(); }
    if (dir == 'leftup') { title = LocaleKeys.leftup.tr(); }
    if (dir == 'up') { title = LocaleKeys.up.tr(); }
    if (dir == 'down') { title = LocaleKeys.down.tr(); }
    if (dir == 'rightdown') { title = LocaleKeys.rightdown.tr(); }
    if (dir == 'leftdown') { title = LocaleKeys.leftdown.tr(); }

    return FutureBuilder<String?>(
      future: getImagePath(),
      builder: (context, snapshot) {
        return Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5.0)),
            Container(
              width: 100,
              height: 60,
              color: Colors.black,
              child: (snapshot.connectionState == ConnectionState.waiting)
              ? const CircularProgressIndicator()
              : (snapshot.hasError || snapshot.data == null)
              ? Center(
                child: Text(
                    LocaleKeys.noImage.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white
                  ),
                ),
              )
              : Image.file(File(snapshot.data!)),
            )
          ],
        );
      }
    );
  }
}