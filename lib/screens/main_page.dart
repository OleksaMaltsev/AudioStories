import 'package:audio_stories/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:audio_stories/routes/routes.dart';
import 'package:audio_stories/screens/audio/record_wave.dart';
import 'package:audio_stories/screens/audio_stories/audio_stories.dart';
import 'package:audio_stories/screens/deleted_tracks/widget/delete_bottom_navigation_bar.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/screens/profile/profile.dart';
import 'package:audio_stories/screens/selections/selection.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import 'package:audio_stories/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const String routeName = '/main_page';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  static const List<String> _pages = [
    HomeScreen.routeName,
    SelectionsScreen.routeName,
    RecordWaveScreen.routeName,
    AudioStoriesScreen.routeName,
    ProfileScreen.routeName,
  ];

  void _onSelectMenu(String route) {
    if (_navigatorKey.currentState != null) {
      _navigatorKey.currentState!.pushNamedAndRemoveUntil(
        route,
        (_) => false,
      );
    }
  }

  void _onSelectTab(String route) {
    if (_navigatorKey.currentState != null) {
      _navigatorKey.currentState!.pushNamedAndRemoveUntil(
        route,
        (route) => false,
      );
    }
  }

  Future<bool> _onWillPop() async {
    final bool maybePop = await _navigatorKey.currentState!.maybePop();

    return !maybePop;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: BlocConsumer<NavigationBloc, NavigationState>(
        listener: (context, state) {
          if (state.status == NavigationStateStatus.menu) {
            _onSelectMenu(state.route);
          }

          if (state.status == NavigationStateStatus.tab) {
            _onSelectTab(state.route);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Navigator(
              key: _navigatorKey,
              initialRoute: HomeScreen.routeName,
              onGenerateRoute: AppRouter.generateRoute,
            ),
            drawerEnableOpenDragGesture: false,
            drawer: CustomDrawer(
              navigatorKey: _navigatorKey,
            ),
            bottomNavigationBar: state.currentIndex == 5
                ? const DeleteBottomNavigationBar()
                : BottomNavBarWidget(
                    navigatorKey: _navigatorKey,
                    currentTab: state.currentIndex,
                    onSelect: (int index) {
                      if (state.currentIndex != index ||
                          state.currentIndex == 0) {
                        context.read<NavigationBloc>().add(
                              NavigateTab(
                                tabIndex: index,
                                route: _pages[index],
                              ),
                            );
                      }
                    },
                  ),
          );
        },
      ),
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
