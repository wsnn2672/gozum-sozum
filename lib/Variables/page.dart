import 'package:flutter/material.dart';

// import 'package:alspeaker/Pages/splashScreen.dart';
import 'package:alspeaker/Pages/settingsScreen.dart';
import 'package:alspeaker/Pages/quickScreen.dart';
import 'package:alspeaker/Pages/entryScreen.dart';
import 'package:alspeaker/Pages/calibrateScreen.dart';
import 'package:alspeaker/Pages/dataScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:alspeaker/generated/locale_keys.g.dart';

import 'package:alspeaker/Pages/admin.dart';

List<Widget> allPages = [ const AdminScreen()  ]; // const SettingsScreen(), const QuickScreen(), EntryScreen(key: EntryScreen.globalKey), const CalibrateScreen(), const DataScreen()
var pageController = PageController();
int selectedPage = 0;
List<String> tabNames = [
  LocaleKeys.tabName0.tr(),
  LocaleKeys.tabName1.tr(),
  LocaleKeys.tabName2.tr(),
  LocaleKeys.tabName3.tr(),
  LocaleKeys.tabName4.tr()
];