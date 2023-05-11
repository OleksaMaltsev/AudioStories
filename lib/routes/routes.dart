import 'package:audio_stories/screens/login/welcome.dart';
import 'package:audio_stories/screens/splash/splash.dart';
import 'package:flutter/material.dart';

// final routes = {
//   '/': (context) => SplashScreen(),
//   '/welcome': (context) => WelcomeScreen(),
// };

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? arguments = settings.arguments;

    WidgetBuilder builder;

    switch (settings.name) {
      case SplashScreen.routeName:
        builder = (_) => const SplashScreen();
        break;
      case WelcomeScreen.routeName:
        builder = (_) => const WelcomeScreen();
        break;

      default:
        throw Exception('Invalid route: ${settings.name}');
    }

    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}
