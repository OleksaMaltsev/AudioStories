import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/routes/routes.dart';
import 'package:audio_stories/screens/audio/player.dart';
import 'package:audio_stories/screens/audio/record.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/screens/profile/profile.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/menu_bar_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const String routeName = '/main_page';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
        bottomNavigationBar: BottomNavBarWidget(navigatorKey: _navigatorKey),
      ),
    );
  }
}
