import 'package:audio_stories/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

abstract class MenuBarItem {
  static final BottomNavigationBarItem activeItem = BottomNavigationBarItem(
    icon: Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: ColorsApp.colorButtonOrange,
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    label: '',
  );
  static final BottomNavigationBarItem passiveItem = BottomNavigationBarItem(
    icon: SvgPicture.asset(
      'assets/svg/record.svg',
      width: 40,
    ),
    label: 'Запис',
  );
}
