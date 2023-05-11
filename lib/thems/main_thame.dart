import 'package:audio_stories/constants/colors.dart';
import 'package:flutter/material.dart';

final mainTheme = ThemeData(
  buttonTheme: const ButtonThemeData(
    height: 59,
    minWidth: 309,
    buttonColor: ColorsApp.colorButtonOrange,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontFamily: 'TT Norms',
      fontSize: 50,
      fontWeight: FontWeight.w700,
      color: ColorsApp.colorWhite,
    ),
    labelLarge: TextStyle(
      fontFamily: 'TT Norms',
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: ColorsApp.colorLightDark,
    ),
    labelMedium: TextStyle(
      fontFamily: 'TT Norms',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: ColorsApp.colorLightDark,
    ),
    labelSmall: TextStyle(
      fontFamily: 'TT Norms',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: ColorsApp.colorWhite,
    ),
  ),
);
