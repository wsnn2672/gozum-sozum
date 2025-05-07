import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:alspeaker/Variables/settings.dart';
import 'dart:io';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:alspeaker/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class DetectorCam
{
  static CameraController? _cameraController;
  static List<CameraDescription>? _cameras;
  static List<String> directions = ["straight", "rightup", "leftup", "up", "down" ,"rightdown", "leftdown"];

  static Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first, // Ön kamera yoksa varsayılan olarak ilk kamerayı kullan
      ),
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    await _cameraController!.initialize();
    DetectionSettings.camEnabled = true;
  }

  static Widget showCamera(BuildContext context) {
    return DetectionSettings.camEnabled
      ? (_cameraController != null) 
        ? Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationZ(3.14159 / 2),  // 90 derece döndürme
          child: CameraPreview(_cameraController!),
        )
        : Center(child: CircularProgressIndicator(color: Colors.red))
      : Center(
        child: Text(
          LocaleKeys.disabledcameraL.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white)
        ),
      );
  }

  static Future<String?> getPicture() async {
    if (!DetectionSettings.camEnabled)
    {
      return null;
    }

    if (!_cameraController!.value.isTakingPicture)
    {
      try {
        final image = await _cameraController!.takePicture();
        return image.path;
      } catch (e) {
        return null;
      }
      
    }
    else {
      return null;
    }
  }

  static Future<void> deletePicture(String imagePath) async {
    final file = File(imagePath);

    if (await file.exists()) {
      await file.delete();
      print("Fotoğraf başarıyla silindi: $imagePath");
    } else {
      print("Dosya bulunamadı: $imagePath");
    }
  }

  static Future<void> disposeCam() async {
    DetectionSettings.camEnabled = false;
    await _cameraController?.dispose();
  }
}