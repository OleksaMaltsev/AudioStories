import 'package:audio_stories/routes/routes.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import 'package:audio_stories/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const String routeName = '/main_page';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        initialRoute: HomeScreen.routeName,
        onGenerateRoute: AppRouter.generateRoute,
      ),
      drawerEnableOpenDragGesture: false,
      drawer: const CustomDrawer(),
      bottomNavigationBar: BottomNavBarWidget(navigatorKey: _navigatorKey),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: ElevatedButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        child: Container(width: 10, color: Colors.amber),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
