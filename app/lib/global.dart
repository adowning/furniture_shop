library timerack.globals;

import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

const String baseServerUrl = "http://192.168.0.4:1337";

class MyColors {
  static const darkBlue = Color(0xff11224d),
      lightBlue = Color(0xff2e406e),
      accentBlue = Color(0xff37e3d5);
}

List<CameraDescription> cameras;
SharedPreferences prefs;
