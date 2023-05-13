import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/style.dart';
import 'package:flutter/material.dart';

class OrangeButton extends StatelessWidget {
  final String text;
  final Function() function;
  const OrangeButton({
    super.key,
    required this.text,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        height: 59,
        decoration: BoxDecoration(
          color: ColorsApp.colorButtonOrange,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            text,
            style: buttonTextStyle,
          ),
        ),
      ),
    );
  }
}
