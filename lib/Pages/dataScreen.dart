// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:alspeaker/Variables/screen_size.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:alspeaker/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  static final GlobalKey<_DataScreenState> globalKey = GlobalKey<_DataScreenState>();

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<String> data = ['This is history.'];
  
  void changeDataText(String text)
  {
    setState(() {
      data.add(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      data = data;
    });
    return SizedBox(
      width: ScreenSize.W,
      height: ScreenSize.H,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: Text(
              LocaleKeys.datainfo.tr(),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 36.0),
            child: Text(
              data.join('\n'),
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w300
              ),
            ),
          ),
        ],
      ),
    );
  }
}