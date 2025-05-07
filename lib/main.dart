import 'package:alspeaker/Variables/settings.dart';
import 'package:flutter/material.dart';
import 'package:alspeaker/Variables/colors.dart';
import 'package:alspeaker/Variables/screen_size.dart';
import 'package:alspeaker/Variables/page.dart';
import 'package:alspeaker/Variables/camera.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';
import 'package:hexcolor/hexcolor.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:alspeaker/generated/locale_keys.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
    supportedLocales: [
      Locale('tr', 'TR'),
      Locale('en', 'US'),
      Locale('es', 'ES'),
      Locale('zh', 'ZH'),
      Locale('de', 'DE'),
      Locale('ru', 'RU')
    ],
    path: 'assets/translations',
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

List<String> tabs = [
  LocaleKeys.tabName0.tr(),
  LocaleKeys.tabName1.tr(),
  LocaleKeys.tabName2.tr(),
  LocaleKeys.tabName3.tr(),
  LocaleKeys.tabName4.tr()
];

class _MyAppState extends State<MyApp> {
  Timer? _timer;

  Future<Map<Object?, Object?>?> _detectEyeDirection(String imagePath) async {
    try {
      final Map<Object?, Object?> detectedDirection = await MethodChannel('opencv')
          .invokeMethod('detectEye', {"imagePath": imagePath});
      return detectedDirection;
    } on MissingPluginException catch (e) {
      print("Error processing image: ${e.message}");
      return null;
    }
  }

  Future<String> _startinitall() async {
    try {
      final String result = await MethodChannel('opencv').invokeMethod('initall', {});
      print('infoW - $result');
      return result;
    } on MissingPluginException catch (e) {
      print("Error processing image: ${e.message}");
      return "";
    }
  }

  void _startEyeDetection() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      if (DetectionSettings.camEnabled && selectedPage != 3 && selectedPage != 4)
      {
        String? path = await DetectorCam.getPicture();

        if(path != null)
        {
          Map<Object?, Object?>? result = await _detectEyeDirection(path);
          if (result != null)
          {
            print('infoW (main.dart1):\n${result.toString()}');
            print('infoW (main.dart2) - ${result['direction']}');
            if (DetectionSettings.eyeDirection != result['direction'])
            {
              print('infoW - activityDetected');
              DetectionSettings.activityDetected(result['direction'].toString());
            }
            setState(() { DetectionSettings.eyeDirection = result['direction'].toString(); DetectionSettings.overalloss = result['overalloss'].toString(); });
          }
          DetectorCam.deletePicture(path);
        }
      }
    });
  }

  // ignore: unused_element
  void _stopEyeDetection() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }
  
  @override
  void initState() {
    super.initState();
    _startEyeDetection();
    _startinitall();
    setStateEverything();
  }

  void setStateEverything()
  {
    setState(() {
      allPages = allPages;
      DetectionSettings.camEnabled = DetectionSettings.camEnabled;
      selectedPage = selectedPage;
      tabNames = tabNames;
      tabs.clear();
      tabs.add(LocaleKeys.tabName0.tr());
      tabs.add(LocaleKeys.tabName1.tr());
      tabs.add(LocaleKeys.tabName2.tr());
      tabs.add(LocaleKeys.tabName3.tr());
      tabs.add(LocaleKeys.tabName4.tr());
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.setSize(context);
    setStateEverything();
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'ALSpeaker',
      theme: ThemeData(scaffoldBackgroundColor: HexColor("#def2f1")),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(  
            toolbarHeight: 50, // Adjust the height as needed
            backgroundColor: dark2, // Customize the background color
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap: () {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: dark1,
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
                        child: Text(
                          tabs[index],
                          style: TextStyle(
                            fontFamily: 'Consolas',
                            fontSize: 18,
                            color: selectedPage == index ? dcblue : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: pageController,
                          children: allPages,
                          onPageChanged: (index)
                          {
                            setState(() {
                              selectedPage = index;
                            });
                          }
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}
