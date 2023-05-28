import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/screens/audio/player.dart';
import 'package:audio_stories/screens/audio/record.dart';
import 'package:audio_stories/screens/main_screen.dart';
import 'package:audio_stories/screens/profile/profile.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/menu_bar_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBarWidget extends StatefulWidget {
  const BottomNavBarWidget({
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
          //selectedItemColor: ColorsApp.colorPurple,
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
              ),
              label: 'Головна',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.category,
              ),
              label: 'Добірки',
            ),
            (PlayerScreen.routeName == ModalRoute.of(context)?.settings.name ||
                    RecordScreen.routeName ==
                        ModalRoute.of(context)?.settings.name)
                ? MenuBarItem.activeItem
                : MenuBarItem.passiveItem,
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.paper,
              ),
              label: 'Аудіоказки',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.profile,
              ),
              label: 'Профіль',
            ),
          ],
          onTap: (value) {
            _onItenTapped(value);
            switch (value) {
              // main screen
              case 0:
                Navigator.pushNamed(
                  context,
                  MainScreen.routeName,
                );
                break;
              // record item
              case 2:
                Navigator.pushNamed(
                  context,
                  RecordScreen.routeName,
                );
                break;
              case 4:
                Navigator.pushNamed(
                  context,
                  ProfileScreen.routeName,
                );
                setState(() {});
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
