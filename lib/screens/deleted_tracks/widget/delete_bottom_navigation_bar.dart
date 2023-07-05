import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeleteBottomNavigationBar extends StatelessWidget {
  const DeleteBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102.h,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: ColorsApp.colorWhite,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            spreadRadius: 5,
            blurRadius: 15,
            offset: Offset(7, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.swap,
                ),
                Text(
                  'Відновити все',
                  style: mainTheme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.delete,
                ),
                Text(
                  'Видалити все',
                  style: mainTheme.textTheme.labelSmall,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
