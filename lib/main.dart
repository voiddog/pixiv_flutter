import 'package:flutter/material.dart';
import 'home/home.dart';
import 'splash/splash.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
    fontFamily: "Roboto",
  ),
  routes: {
    "home": (context) => Home()
  },
  home: Splash(),
));
