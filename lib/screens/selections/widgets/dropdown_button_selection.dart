import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DropdownButtonSelection extends StatelessWidget {
  const DropdownButtonSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SvgPicture.asset(AppIcons.dots),
        ),
        items: [
          ...MenuItems.firstItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          )
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value as MenuItem);
        },
        dropdownStyleData: DropdownStyleData(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorsApp.colorWhite,
          ),
          elevation: 8,
          offset: const Offset(0, 8),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.filled(MenuItems.firstItems.length, 48),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}

class MenuItem {
  final String text;

  const MenuItem({
    required this.text,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [
    itemOne,
    itemTwo,
    itemThree,
    itemFour
  ];

  static const itemOne = MenuItem(text: '1');
  static const itemTwo = MenuItem(text: '2');
  static const itemThree = MenuItem(text: '3');
  static const itemFour = MenuItem(text: '4');

  static Widget buildItem(MenuItem item) {
    return Text(
      item.text,
      style: mainTheme.textTheme.labelSmall,
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.itemOne:
        //Do something
        break;
      case MenuItems.itemThree:
        //Do something
        break;
      case MenuItems.itemTwo:
        //Do something
        break;
      case MenuItems.itemFour:
        //Do something
        break;
    }
  }
}
