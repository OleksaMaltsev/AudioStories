import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/screens/audio/record.dart';
import 'package:audio_stories/screens/main_screen.dart';
import 'package:audio_stories/screens/profile/profile.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/menu_bar_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBarWidget extends StatelessWidget {
  final bool recordItem;
  const BottomNavBarWidget({
    required this.recordItem,
    super.key,
  });

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
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: ColorsApp.colorPurple,
          selectedLabelStyle: mainTheme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
          ),
          unselectedLabelStyle: mainTheme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
          ),
          onTap: (value) {
            switch (value) {
              // main screen
              case 0:
                if (!recordItem)
                  Navigator.pushNamed(
                    context,
                    MainScreen.routeName,
                  );
                break;
              // record item
              case 2:
                if (!recordItem)
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
                break;
              default:
                break;
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Головна',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              label: 'Добірки',
            ),
            recordItem ? MenuBarItem.activeItem : MenuBarItem.passiveItem,
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_rounded),
              label: 'Аудіоказки',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Профіль',
            ),
          ],
        ),
      ),
    );
  }
}
