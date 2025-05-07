import 'package:flutter/material.dart';

class ScreenSize
{
  static double W = 1080;
  static double H = 1920;

  static void setSize(context)
  {
    W = MediaQuery.of(context).size.width;
    H = MediaQuery.of(context).size.height;
  }
}