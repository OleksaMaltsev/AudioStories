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

class BottomNavBarWidget extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const BottomNavBarWidget({
    required this.navigatorKey,
    super.key,
  });

  @override
  State<BottomNavBarWidget> createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  int _selectIndex = 0;
  void _onItenTapped(int index) {
    _selectIndex = index;
    setState(() {});
  }

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
          currentIndex: _selectIndex,
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
                color: _selectIndex == 0
                    ? ColorsApp.colorPurple
                    : ColorsApp.colorLightDark,
              ),
              label: 'Головна',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.category,
                color: _selectIndex == 1
                    ? ColorsApp.colorPurple
                    : ColorsApp.colorLightDark,
              ),
              label: 'Добірки',
            ),
            // (PlayerScreen.routeName == ModalRoute.of(context)?.settings.name ||
            //         RecordScreen.routeName ==
            //             ModalRoute.of(context)?.settings.name)
            //     ? MenuBarItem.activeItem
            //     : MenuBarItem.passiveItem,
            // BottomNavigationBarItem(
            //   icon: SvgPicture.asset(
            //     AppIcons.paper,
            //     color: _selectIndex == 3
            //         ? ColorsApp.colorPurple
            //         : ColorsApp.colorLightDark,
            //   ),
            //   label: 'Аудіоказки',
            // ),
            (RecordWaveScreen.routeName ==
                    ModalRoute.of(context)?.settings.name)
                ? MenuBarItem.activeItem
                : MenuBarItem.passiveItem,
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.paper,
                color: _selectIndex == 3
                    ? ColorsApp.colorPurple
                    : ColorsApp.colorLightDark,
              ),
              label: 'Аудіоказки',
            ),

            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.profile,
                color: _selectIndex == 4
                    ? ColorsApp.colorPurple
                    : ColorsApp.colorLightDark,
              ),
              label: 'Профіль',
            ),
          ],
          onTap: (value) {
            _onItenTapped(value);
            switch (value) {
              // main screen
              case 0:
                widget.navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  HomeScreen.routeName,
                  (route) => false,
                );
                break;
              case 1:
                widget.navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  SelectionsScreen.routeName,
                  (route) => false,
                );
                break;
              // record item
              case 2:
                widget.navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  RecordWaveScreen.routeName,
                  (route) => false,
                );
                break;
              case 3:
                widget.navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  AudioStoriesScreen.routeName,
                  (route) => false,
                );
                break;
              case 4:
                widget.navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  ProfileScreen.routeName,
                  (route) => false,
                );

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
