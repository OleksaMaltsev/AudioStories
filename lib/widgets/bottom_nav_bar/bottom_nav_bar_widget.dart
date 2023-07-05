import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';

import 'package:audio_stories/screens/audio/record_wave.dart';
import 'package:audio_stories/screens/audio_stories/audio_stories.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/screens/profile/profile.dart';
import 'package:audio_stories/screens/selections/selection.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/menu_bar_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBarWidget extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final int currentTab;
  final void Function(int) onSelect;

  BottomNavBarWidget({
    required this.navigatorKey,
    super.key,
    required this.currentTab,
    required this.onSelect,
  });

  //int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: BottomNavigationBar(
          currentIndex: currentTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: ColorsApp.colorPurple,
          selectedLabelStyle: mainTheme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
          ),
          unselectedLabelStyle: mainTheme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
          ),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.home,
                color: currentTab == 0
                    ? ColorsApp.colorPurple
                    : ColorsApp.colorLightDark,
              ),
              label: 'Головна',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.category,
                color: currentTab == 1
                    ? ColorsApp.colorPurple
                    : ColorsApp.colorLightDark,
              ),
              label: 'Добірки',
            ),
            (RecordWaveScreen.routeName ==
                    ModalRoute.of(context)?.settings.name)
                ? MenuBarItem.activeItem
                : MenuBarItem.passiveItem,
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.paper,
                color: currentTab == 3
                    ? ColorsApp.colorPurple
                    : ColorsApp.colorLightDark,
              ),
              label: 'Аудіоказки',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.profile,
                color: currentTab == 4
                    ? ColorsApp.colorPurple
                    : ColorsApp.colorLightDark,
              ),
              label: 'Профіль',
            ),
          ],
          onTap: (value) {
            //_onItenTapped(value);
            switch (value) {
              // main screen
              case 0:
                onSelect(0);
                // navigatorKey.currentState!.pushNamedAndRemoveUntil(
                //   HomeScreen.routeName,
                //   (route) => false,
                // );
                break;
              case 1:
                onSelect(1);
                // navigatorKey.currentState!.pushNamedAndRemoveUntil(
                //   SelectionsScreen.routeName,
                //   (route) => false,
                // );
                break;
              // record item
              case 2:
                onSelect(2);
                // navigatorKey.currentState!.pushNamedAndRemoveUntil(
                //   RecordWaveScreen.routeName,
                //   (route) => false,
                // );
                break;
              case 3:
                onSelect(3);
                // navigatorKey.currentState!.pushNamedAndRemoveUntil(
                //   AudioStoriesScreen.routeName,
                //   (route) => false,
                // );
                break;
              case 4:
                onSelect(4);
                // navigatorKey.currentState!.pushNamedAndRemoveUntil(
                //   ProfileScreen.routeName,
                //   (route) => false,
                // );

                break;
              default:
                break;
            }
          },
        ),
      ),
    );
  }
}
