// ignore_for_file: file_names

import 'package:alspeaker/Variables/page.dart';
import 'package:alspeaker/Variables/settings.dart';
import 'package:alspeaker/Variables/sounds.dart';
import 'package:flutter/material.dart';
import 'package:alspeaker/Variables/screen_size.dart';
import 'package:hexcolor/hexcolor.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:alspeaker/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class QuickScreen extends StatefulWidget {
  const QuickScreen({super.key});

  static final GlobalKey<_QuickScreenState> globalKey = GlobalKey<_QuickScreenState>();

  @override
  State<QuickScreen> createState() => _QuickScreenState();
}

class _QuickScreenState extends State<QuickScreen> {
  int curquickPage = 0;
  late BuildContext contextA;

  // region: lines
  String baseline0 = "Basic Needs";
  List<String> lines0 = [
    'Basic Needs',
    'I want to eat something.',
    'I am happy.',
    'I feel hot.',
    'I want to go outside.',
    'I feel some pain.'
  ];
  String baseline1 = "Emotions";
  List<String> lines1 = [
    'Emotions',
    'I want to sleep.',
    'I am sad.',
    'I feel cold.',
    'I want to read newspaper.',
    'I feel extreme pain.'
  ];
  String baseline2 = "Environment Control";
  List<String> lines2 = [
    'Environment Control',
    'I want to go to bathroom.',
    'I am angry.',
    'It is too noisy.',
    'I want to listen to music.',
    'I need to eat my pills.'
  ];
  String baseline3 = "Social Activities and Recreation";
  List<String> lines3 = [
    'Social Activities and Recreation',
    'I want to drink water.',
    'I am scared.',
    'It is too bright.',
    'I want to watch television.',
    'I need to go to the hospital.'
  ];
  String baseline4 = "Medical Needs";
  List<String> lines4 = [
    'Medical Needs',
    'I want to rest.',
    'I am confused.',
    'It is too dark.',
    'I want to listen to the radio.',
    'I feel fine.'
  ];
  String baselineBack = "Back to Text Entry";
  //endregion

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      contextA = context;
    });
  }
  
  void changeQuickPage(int num)
  {
    setState(() {
      curquickPage = num;

      /*
      baseline0 = lines0[num];
      baseline1 = lines1[num];
      baseline2 = lines2[num];
      baseline3 = lines3[num];
      baseline4 = lines4[num];
      */
      
      if (num == 0)
      {
        baseline0 = LocaleKeys.lines00.tr();
        baseline1 = LocaleKeys.lines10.tr();
        baseline2 = LocaleKeys.lines20.tr();
        baseline3 = LocaleKeys.lines30.tr();
        baseline4 = LocaleKeys.lines40.tr();
      }
      if (num == 1)
      {
        baseline0 = LocaleKeys.lines01.tr();
        baseline1 = LocaleKeys.lines11.tr();
        baseline2 = LocaleKeys.lines21.tr();
        baseline3 = LocaleKeys.lines31.tr();
        baseline4 = LocaleKeys.lines41.tr();
      }
      if (num == 2)
      {
        baseline0 = LocaleKeys.lines02.tr();
        baseline1 = LocaleKeys.lines12.tr();
        baseline2 = LocaleKeys.lines22.tr();
        baseline3 = LocaleKeys.lines32.tr();
        baseline4 = LocaleKeys.lines42.tr();
      }
      if (num == 3)
      {
        baseline0 = LocaleKeys.lines03.tr();
        baseline1 = LocaleKeys.lines13.tr();
        baseline2 = LocaleKeys.lines23.tr();
        baseline3 = LocaleKeys.lines33.tr();
        baseline4 = LocaleKeys.lines43.tr();
      }
      if (num == 4)
      {
        baseline0 = LocaleKeys.lines04.tr();
        baseline1 = LocaleKeys.lines14.tr();
        baseline2 = LocaleKeys.lines24.tr();
        baseline3 = LocaleKeys.lines34.tr();
        baseline4 = LocaleKeys.lines44.tr();
      }
      if (num == 5)
      {
        baseline0 = LocaleKeys.lines05.tr();
        baseline1 = LocaleKeys.lines15.tr();
        baseline2 = LocaleKeys.lines25.tr();
        baseline3 = LocaleKeys.lines35.tr();
        baseline4 = LocaleKeys.lines45.tr();
      }

      if (curquickPage != 0)
      {
        baselineBack = LocaleKeys.back.tr();
      }
      else
      {
        baselineBack = LocaleKeys.backentry.tr();
      }
    });
  }

  void tapBtn0()
  {
    if (curquickPage == 0)
                  {
                    changeQuickPage(1);
                    playBeep();
                  }
                  else
                  {
                    speechText(baseline0);
                  }
  }

  void tapBtn1()
  {
    playBeep();
                  if (curquickPage != 0)
                  {
                    changeQuickPage(0);
                  }
                  else
                  {
                    pageController.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
  }

  void tapBtn2()
  {
    if (curquickPage == 0)
                  {
                    changeQuickPage(2);
                    playBeep();
                  }
                  else
                  {
                    speechText(baseline1);
                  }
  }

  void tapBtn3()
  {
    if (curquickPage == 0)
                  {
                    changeQuickPage(3);
                    playBeep();
                  }
                  else
                  {
                    speechText(baseline2);
                  }
  }

  void tapBtn4()
  {
    if (curquickPage == 0)
                  {
                    changeQuickPage(4);
                    playBeep();
                  }
                  else
                  {
                    speechText(baseline3);
                  }
  }

  void tapBtn5()
  {
    if (curquickPage == 0)
                  {
                    changeQuickPage(5);
                    playBeep();
                  }
                  else
                  {
                    speechText(baseline4);
                  }
  }

  void tapBtn(int index)
  {
    if (index == 0)
    {
      if (curquickPage == 0)
                  {
                    changeQuickPage(1);
                    playBeep();
                  }
                  else
                  {
                    speechText(lines0[curquickPage]);
                  }
    }

    if (index == 1)
    {
      playBeep();
                  if (curquickPage != 0)
                  {
                    changeQuickPage(0);
                  }
                  else
                  {
                    pageController.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
    }

    if (index == 2)
    {
      if (curquickPage == 0)
                  {
                    changeQuickPage(2);
                    playBeep();
                  }
                  else
                  {
                    speechText(lines1[curquickPage]);
                  }
    }

    if (index == 3)
    {
      if (curquickPage == 0)
                  {
                    changeQuickPage(3);
                    playBeep();
                  }
                  else
                  {
                    speechText(lines2[curquickPage]);
                  }
    }

    if (index == 4)
    {
      if (curquickPage == 0)
                  {
                    changeQuickPage(4);
                    playBeep();
                  }
                  else
                  {
                    speechText(lines3[curquickPage]);
                  }
    }

    if (index == 5)
    {
      if (curquickPage == 0)
                  {
                    changeQuickPage(5);
                    playBeep();
                  }
                  else
                  {
                    speechText(lines4[curquickPage]);
                  }
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      DetectionSettings.camEnabled = DetectionSettings.camEnabled;
    });
    return Container(
      width: ScreenSize.W,
      height: ScreenSize.H,
      color: HexColor("#4f6266"), 
      child: Column(
        children: [
          // Üstteki Satır
          Padding(padding: EdgeInsets.only(top: 2.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: tapBtn0,
                child: Container(
                  width: 272,
                  height: 150,
                  decoration: BoxDecoration(
                    color: HexColor("#364644"),
                    borderRadius: BorderRadius.all(Radius.circular(24))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: HexColor("#dce7c4"),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/leftupgaze.png',
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            baseline0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: HexColor("#13160d"),
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: tapBtn1,
                child: Container(
                  width: 272,
                  height: 150,
                  decoration: BoxDecoration(
                    color: HexColor("#364644"),
                    borderRadius: BorderRadius.all(Radius.circular(24))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: HexColor("#b4b9c7"),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/upgaze.png',
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            baselineBack,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: HexColor("#13160d"),
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: tapBtn2,
                child: Container(
                  width: 272,
                  height: 150,
                  decoration: BoxDecoration(
                    color: HexColor("#364644"),
                    borderRadius: BorderRadius.all(Radius.circular(24))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: HexColor("#dce7c4"),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/rightupgaze.png',
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            baseline1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: HexColor("#13160d"),
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),

          // Alttaki Satır
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: tapBtn3,
                child: Container(
                  width: 272,
                  height: 150,
                  decoration: BoxDecoration(
                    color: HexColor("#364644"),
                    borderRadius: BorderRadius.all(Radius.circular(24))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: HexColor("#dce7c4"),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            baseline2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: HexColor("#13160d"),
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Image.asset(
                            'assets/images/leftgaze.png',
                            width: 50,
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: tapBtn4,
                child: Container(
                  width: 272,
                  height: 150,
                  decoration: BoxDecoration(
                    color: HexColor("#364644"),
                    borderRadius: BorderRadius.all(Radius.circular(24))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: HexColor("#dce7c4"),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            baseline3,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: HexColor("#13160d"),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset(
                            'assets/images/closedgaze.png',
                            width: 50,
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: tapBtn5,
                child: Container(
                  width: 272,
                  height: 150,
                  decoration: BoxDecoration(
                    color: HexColor("#364644"),
                    borderRadius: BorderRadius.all(Radius.circular(24))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: HexColor("#dce7c4"),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            baseline4,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: HexColor("#13160d"),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset(
                            'assets/images/rightgaze.png',
                            width: 50,
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}