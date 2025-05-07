// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:alspeaker/Variables/screen_size.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSize.W,
      height: ScreenSize.H,
      child: const Column(
        children: [
          Center(
            child: Text('Welcome To The App!'),
          )
        ],
      ),
    );
  }
}