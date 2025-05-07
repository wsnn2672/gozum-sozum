// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:alspeaker/Variables/screen_size.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

CameraController? _cameraController;
List<CameraDescription>? _cameras;
List<String> directions = ["straight", "rightup", "leftup", "up", "down" ,"rightdown", "leftdown"];
bool camEnabled = false;
Uint8List? _processedImage;

class _AdminScreenState extends State<AdminScreen> {
  
  static const platform = MethodChannel("opencv");

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    setState(() {
      _cameraController = CameraController(
      _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first, // Ön kamera yoksa varsayılan olarak ilk kamerayı kullan
      ),
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    });
    await _cameraController!.initialize();
    setState(() {
      camEnabled = true;
    });
    _startDetection();
  }

  void _startDetection() async {
    while (true) {
      camEnabled = camEnabled;
      if (!_cameraController!.value.isStreamingImages) continue;

      final image = await _cameraController!.takePicture();
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final processedImage = await platform.invokeMethod("detectFaces", {"image": base64Image});
      _processedImage = base64Decode(processedImage);
    }
  }

  void initCam() async
  {
    setState(() {
      camEnabled = camEnabled;
      _cameraController=_cameraController;
    });
    if ( camEnabled != true) 
    {
      await initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    initCam();
    return SizedBox(
      width: ScreenSize.W,
      height: ScreenSize.H,
      child: Column(
        children: [
          Stack(
            children: [
              camEnabled ? CameraPreview(_cameraController!) : Text('CAM DISABLED'),
              if (_processedImage != null) Image.memory(_processedImage!),
            ],
          ),
        ],
      ),
    );
  }
}