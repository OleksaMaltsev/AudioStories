import 'package:audio_stories/screens/audio/player.dart';
import 'package:audio_stories/screens/audio/record.dart';
import 'package:audio_stories/screens/audio_stories/audio_stories.dart';
import 'package:audio_stories/screens/main_page.dart';
import 'package:audio_stories/screens/login/sign_up.dart';
import 'package:audio_stories/screens/login/sign_up_sms.dart';
import 'package:audio_stories/screens/login/sign_up_thanks.dart';
import 'package:audio_stories/screens/login/welcome.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/screens/profile/profile.dart';
import 'package:audio_stories/screens/profile/subscription.dart';
import 'package:audio_stories/screens/selections/add_selection.dart';
import 'package:audio_stories/screens/selections/selection.dart';
import 'package:audio_stories/screens/selections/widgets/stories_box_selections.dart';
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
      case SignUpScreen.routeName:
        builder = (_) => const SignUpScreen();
        break;
      case SignUpSmsScreen.routeName:
        builder = (_) => const SignUpSmsScreen();
        break;
      case SignUpThanksScreen.routeName:
        builder = (_) => const SignUpThanksScreen();
        break;
      case HomeScreen.routeName:
        builder = (_) => const HomeScreen();
        break;
      case RecordScreen.routeName:
        builder = (_) => const RecordScreen();
        break;
      case PlayerScreen.routeName:
        builder = (_) => const PlayerScreen();
        break;
      case ProfileScreen.routeName:
        builder = (_) => const ProfileScreen();
        break;
      case SubscriptionScreen.routeName:
        builder = (_) => const SubscriptionScreen();
        break;
      case AudioStoriesScreen.routeName:
        builder = (_) => const AudioStoriesScreen();
        break;
      case MainPage.routeName:
        builder = (_) => const MainPage();
        break;
      case SelectionsScreen.routeName:
        builder = (_) => const SelectionsScreen();
        break;
      case AddSelectionScreen.routeName:
        builder = (_) => const AddSelectionScreen();
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
