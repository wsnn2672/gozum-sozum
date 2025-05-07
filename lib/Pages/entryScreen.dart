// ignore_for_file: file_names

import 'package:alspeaker/Variables/settings.dart';
import 'package:flutter/material.dart';
import 'package:alspeaker/Variables/screen_size.dart';
import 'package:alspeaker/Variables/sounds.dart';
import 'package:alspeaker/Variables/geminiengine.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:alspeaker/Pages/dataScreen.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:alspeaker/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

bool sentenceMode = false;
List<String> matches = [];
List<String> words = [];
List<String> letters = [];
String LLMtext = "";
List<String> curKeyboards = ["ABCÇDEFG", "ĞHİIJKL", "MNOÖPRS", "ŞTUÜVYZ"];
List<String> langWords = [];
String usedLang = "";
int wordpage = 0;
int curpage = 0;
TextEditingController _tcontroller = TextEditingController();

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  static final GlobalKey<_EntryScreenState> globalKey = GlobalKey<_EntryScreenState>();

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  void addLetter(String keyboard)
  {
    if (keyboard.length <= 1) { return; }
    
    setState(() {
      letters.add('${keyboard[0]}-${keyboard[keyboard.length - 1]}');
    });
  }

  void addWord(String word)
  {
    setState(() {
      letters.clear();
      words.add(word);
    });

    DataScreen.globalKey.currentState?.changeDataText(word);

    if (words.isNotEmpty)
    {
      genSentence();
    }
  }

  void genSentence() async
  {
    if (DetectionSettings.entryMode != "Letter by Letter")
    {
      final result = await geminiEngine.sendMessage(words.join(' '), _tcontroller.text, DetectionSettings.language);

      if (result.isNotEmpty && result != "GEMINI_API_ERROR")
      {
        setState(() {
          LLMtext = result;
        });
        DataScreen.globalKey.currentState?.changeDataText(LLMtext);
      }
    }
    else
    {
      setState(() {
        LLMtext = "---";
      });
    }
  }

  void findMatches() async
  {
    List<Set<String>> parseRanges() {
      List<Set<String>> letterGroups = [];
      
      for (String range in letters) {
        List<String> bounds = range.split("-");
        if (bounds.length == 2) {
          String start = bounds[0];
          String end = bounds[1];
          
          for (String group in curKeyboards) {
            if (group.contains(start) && group.contains(end)) {
              letterGroups.add(group.split('').toSet()); // .split(" ").toSet()
              break;
            }
          }
        }
      }
      return letterGroups;
    }

    Future<List<String>> loadWords() async {
      String language = 'Turkish';

      if (DetectionSettings.language == 'Türkçe')
      { language = "Turkish"; }
      else if (DetectionSettings.language == 'English')
      { language = "English"; }
      else if (DetectionSettings.language == 'Español')
      { language = "Spanish"; }
      else if (DetectionSettings.language == '中国人')
      { language = "Chinese"; }
      else if (DetectionSettings.language == 'Русский')
      { language = "Russian"; }
      else if (DetectionSettings.language == 'Deutsch')
      { language = "German"; }

      String fileContent = await rootBundle.loadString('assets/words/${language}Words.txt');
      return fileContent.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }

    if (letters.isEmpty)
    {
      return;
    }

    List<Set<String>> letterGroups = parseRanges();

    List<String> matchingWords = [];

    if (langWords.isEmpty || usedLang != DetectionSettings.language)
    {
      langWords.clear();
      langWords = await loadWords();
      usedLang = DetectionSettings.language;
    }

    for (String word in langWords) {
      word = word.toUpperCase();
      bool isMatch = true;

      if (word.length == letterGroups.length)
      {
        for (int i = 0; i < letterGroups.length; i++) {
          if (!letterGroups[i].contains(word[i])) {
            isMatch = false;
            break;
          }
        }
      }
      else
      {
        isMatch = false;
      }
      
      if (isMatch) {
        matchingWords.add(word);
      }
    }

    setState(() {
      matches.clear();
      matches = matchingWords.toList();
      wordpage = (matches.length / 3) == (matches.length / 3).toInt() ? (matches.length / 3).toInt() : (matches.length / 3).toInt() + 1;
    });
  }

  void keyboardTap(int keynum)
  {
    playBeep();
    if (sentenceMode)
    {
      if (matches.isNotEmpty)
      {
        addWord(matches[keynum + 3*curpage]);
      }
    }
    else
    {
      addLetter(curKeyboards[keynum]);
      findMatches();
    }
  }

  void switchTap()
  {
    playBeep();
    setState(() {
      sentenceMode = !sentenceMode;
    });
  }

  void finishTap()
  {
    playBeep();
    if (sentenceMode)
    {
      speechText(LLMtext == "" ? words.join(' ') : LLMtext);
    }
    else
    {
      if (letters.isEmpty)
      { 
        if (words.isNotEmpty)
        {
          setState(() {
            words.removeLast();
          });
          if (words.length > 1)
          {
            genSentence();
          }
        }
        return;
      }
      else
      {
        if (letters.isNotEmpty)
        {
          setState(() {
            letters.removeLast();
          });
          findMatches();
        }
        return;
      }
    }
  }

  void nextTap()
  {
    playBeep();
    if (sentenceMode)
    {
      if (curpage == wordpage)
      {
        setState(() {
          curpage = 0;
        });
      }
      else
      {
        setState(() {
          curpage = curpage+1;
        });
      }
    }
    else
    {
      addLetter(curKeyboards[3]);
      findMatches();
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      DetectionSettings.camEnabled = DetectionSettings.camEnabled;
      DetectionSettings.language = DetectionSettings.language;
      DetectionSettings.entryMode = DetectionSettings.entryMode;
      sentenceMode = sentenceMode;
      matches = matches;
      words = words;
      letters = letters;
      LLMtext = LLMtext;
      curKeyboards = [LocaleKeys.keyboardlu.tr(), LocaleKeys.keyboardru.tr(), LocaleKeys.keyboardld.tr(), LocaleKeys.keyboardrd.tr()];
      langWords = langWords;
      usedLang = usedLang;
      wordpage = wordpage;
    });
    
    return Container(
      width: ScreenSize.W,
      height: ScreenSize.H,
      color: HexColor("#4f6266"), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // İlk Sutün
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    width: 220,
                    height: 115,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 15),
                      child: GestureDetector(
                        onTap: () => keyboardTap(0),
                        child: Container(
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    !sentenceMode
                                    ? curKeyboards[0]
                                    : matches.length >= 0 + 3*curpage - (2 * ((curpage==0)?0:0)) && matches.isNotEmpty ? matches[0 + 3*curpage] : LocaleKeys.nomatch.tr(),
                                    style: TextStyle(
                                      color: HexColor("#13160d"),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    !sentenceMode
                                    ? matches.length >= 0 + 3*curpage - (2 * ((curpage==0)?0:0)) && matches.isNotEmpty ? matches[0 + 3*curpage] : LocaleKeys.nomatch.tr()
                                    : curKeyboards[0],
                                    style: TextStyle(
                                      color: HexColor("#7a9f9a"),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      'assets/images/leftupgaze.png', // Burada kendi resminizin yolunu kullanın
                      width: 50, // Resmin genişliği
                      height: 50, // Resmin yüksekliği
                    ),
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  Container(
                    width: 220,
                    height: 115,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 15),
                      child: GestureDetector(
                        onTap: () => keyboardTap(2),
                        child: Container(
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    !sentenceMode
                                    ? curKeyboards[2]
                                    : matches.length >= 2 + 3*curpage - (2 * ((curpage==0)?0:0)) && matches.length > 2 ? matches[2 + 3*curpage] : LocaleKeys.nomatch.tr(),
                                    style: TextStyle(
                                      color: HexColor("#13160d"),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    !sentenceMode
                                    ? matches.length >= 2 + 3*curpage - (2 * ((curpage==0)?0:0)) && matches.length > 2 ? matches[2 + 3*curpage] : LocaleKeys.nomatch.tr()
                                    : curKeyboards[2],
                                    style: TextStyle(
                                      color: HexColor("#7a9f9a"),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Image.asset(
                      'assets/images/leftgaze.png', // Burada kendi resminizin yolunu kullanın
                      width: 50, // Resmin genişliği
                      height: 50, // Resmin yüksekliği
                    ),
                  ),
                ],
              ),
            ],
          ),

          // İkinci Sutün
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(top: 8.0)),

              // Buttonlar
              Row(
                children: [
                  // İlk Button
                  GestureDetector(
                    onTap: switchTap,
                    child: Container(
                      width: 180,
                      height: 40,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                LocaleKeys.switchText.tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Image.asset(
                                'assets/images/closedgaze.png', // Burada kendi resminizin yolunu kullanın
                                width: 50, // Resmin genişliği
                                height: 50, // Resmin yüksekliği
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // İkinci Button
                  GestureDetector(
                    onTap: finishTap,
                    child: Container(
                      width: 180,
                      height: 40,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                sentenceMode ? LocaleKeys.speak.tr() : LocaleKeys.delete.tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Image.asset(
                                'assets/images/upgaze.png', // Burada kendi resminizin yolunu kullanın
                                width: 50, // Resmin genişliği
                                height: 50, // Resmin yüksekliği
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),

              Padding(padding: EdgeInsets.only(top: 5.0)),

              // Text Part
              Container(
                width: 360,
                height: 70,
                decoration: BoxDecoration(
                  color: HexColor("#33403e"),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 8.0, bottom: 5.0, right: 5.0),
                  child: Text(
                    "${LocaleKeys.text.tr()}: ${words.join(' ')} ${letters.join(' ')}",
                    style: TextStyle(
                      color: HexColor("#b2cbcb"),
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.only(top: 8.0)),

              // LLM Part
              Container(
                width: 360,
                height: 90,
                decoration: BoxDecoration(
                  color: HexColor("#008787"),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 8.0, bottom: 5.0, right: 5.0),
                  child: Text(
                    "LLM: $LLMtext",
                    style: TextStyle(
                      color: HexColor("#b2cbcb"),
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.only(top: 8.0)),

              // Context Part
              Container(
                width: 360,
                height: 70,
                decoration: BoxDecoration(
                  color: HexColor("#33403e"),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 1, left: 1, bottom: 1, right: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            controller: _tcontroller,
                            cursorColor: HexColor("#b2cbcb"),
                            style: TextStyle(
                              color: HexColor("#b2cbcb"),
                            ),
                            decoration: InputDecoration(
                              labelText: LocaleKeys.entercontext.tr(),
                              labelStyle: TextStyle(
                                color: HexColor("#b2cbcb"),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 12.0),
                        child: GestureDetector(
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: HexColor("#e9f4a0"),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/microphone.png', // Burada kendi resminizin yolunu kullanın
                                width: 20, // Resmin genişliği
                                height: 20, // Resmin yüksekliği
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ),
              ),
            ],
          ),

          // Üçüncü Sutün
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    width: 220,
                    height: 115,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, top: 15),
                      child: GestureDetector(
                        onTap: () => keyboardTap(1),
                        child: Container(
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    !sentenceMode
                                    ? curKeyboards[1]
                                    : matches.length >= 1 + 3*curpage - (2 * ((curpage==0)?0:0)) && matches.length > 1 ? matches[1 + 3*curpage] : LocaleKeys.nomatch.tr(),
                                    style: TextStyle(
                                      color: HexColor("#13160d"),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    !sentenceMode
                                    ? matches.length >= 1 + 3*curpage - (2 * ((curpage==0)?0:0)) && matches.length > 1 ? matches[1 + 3*curpage] : LocaleKeys.nomatch.tr()
                                    : curKeyboards[1],
                                    style: TextStyle(
                                      color: HexColor("#7a9f9a"),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/rightupgaze.png', // Burada kendi resminizin yolunu kullanın
                      width: 50, // Resmin genişliği
                      height: 50, // Resmin yüksekliği
                    ),
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  Container(
                    width: 220,
                    height: 115,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 15),
                      child: GestureDetector(
                        onTap: () {
                          if (sentenceMode)
                          {
                            if (curpage == wordpage)
                            {
                              setState(() {
                                curpage = 0;
                              });
                            }
                            else
                            {
                              setState(() {
                                curpage = curpage+1;
                              });
                            }
                          }
                          else
                          {
                            addLetter(curKeyboards[3]);
                            findMatches();
                          }
                        },
                        onLongPress: () {
                          if (sentenceMode)
                          {
                            if (curpage == 0)
                            {
                              curpage = wordpage;
                            }
                            else
                            {
                              setState(() {
                                curpage = curpage-1;
                              });
                            }
                          }
                        },
                        child: Container(
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    !sentenceMode
                                    ? curKeyboards[3]
                                    : LocaleKeys.nextPage.tr(),
                                    style: TextStyle(
                                      color: HexColor("#13160d"),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    sentenceMode
                                    ? curKeyboards[3]
                                    : matches.length > 3 ? matches[3] : LocaleKeys.nomatch.tr(),
                                    style: TextStyle(
                                      color: HexColor("#7a9f9a"),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/rightgaze.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

