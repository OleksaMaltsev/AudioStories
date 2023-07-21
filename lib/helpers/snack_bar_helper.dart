import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:flutter/material.dart';

class SnackBarHelper {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> getSnackBar(
      BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: mainTheme.textTheme.labelLarge?.copyWith(
          color: ColorsApp.colorWhite,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: (ColorsApp.colorLightOpacityDark),
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
