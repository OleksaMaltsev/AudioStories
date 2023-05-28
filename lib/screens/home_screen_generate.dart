import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/routes/routes.dart';
import 'package:audio_stories/screens/audio/player.dart';
import 'package:audio_stories/screens/audio/record.dart';
import 'package:audio_stories/screens/main_screen.dart';
import 'package:audio_stories/screens/profile/profile.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/menu_bar_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/f';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Navigator(
          key: _navigatorKey,
          initialRoute: HomeScreen.routeName,
          onGenerateRoute: AppRouter.generateRoute,
        ),
        bottomNavigationBar: Container(
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
                // (PlayerScreen.routeName ==
                //             ModalRoute.of(context)?.settings.name ||
                //         RecordScreen.routeName ==
                //             ModalRoute.of(context)?.settings.name)
                //     ? MenuBarItem.activeItem
                //     :
                MenuBarItem.passiveItem,
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
                switch (value) {
                  // main screen
                  case 0:
                    _navigatorKey.currentState
                        ?.pushReplacementNamed(MainScreen.routeName);
                    break;
                  // record item
                  case 2:
                    _navigatorKey.currentState
                        ?.pushReplacementNamed(RecordScreen.routeName);
                    break;
                  case 4:
                    _navigatorKey.currentState
                        ?.pushReplacementNamed(ProfileScreen.routeName);
                    break;
                  default:
                    break;
                }
                setState(() {
                  _selectIndex = value;
                });
              },
              currentIndex: _selectIndex,
            ),
          ),
        ),
      ),
    );
  }
}
