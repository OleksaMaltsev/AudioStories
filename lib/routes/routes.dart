import 'package:audio_stories/screens/audio/player.dart';
import 'package:audio_stories/screens/audio/record_wave.dart';
import 'package:audio_stories/screens/audio/save_track_in_selection.dart';
import 'package:audio_stories/screens/audio_stories/audio_stories.dart';
import 'package:audio_stories/screens/deleted_tracks/deleted_tracks.dart';
import 'package:audio_stories/screens/deleted_tracks/deleted_tracks_choice.dart';
import 'package:audio_stories/screens/login/sign_up_thanks_auth_user.dart';
import 'package:audio_stories/screens/main_page.dart';
import 'package:audio_stories/screens/login/sign_up.dart';
import 'package:audio_stories/screens/login/sign_up_sms.dart';
import 'package:audio_stories/screens/login/sign_up_thanks.dart';
import 'package:audio_stories/screens/login/welcome.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/screens/profile/profile.dart';
import 'package:audio_stories/screens/profile/profile_edit.dart';
import 'package:audio_stories/screens/profile/subscription.dart';
import 'package:audio_stories/screens/search/search.dart';
import 'package:audio_stories/screens/selections/add_selection.dart';
import 'package:audio_stories/screens/selections/choice_some_selection.dart';
import 'package:audio_stories/screens/selections/choies_selection.dart';
import 'package:audio_stories/screens/selections/edit_selection.dart';
import 'package:audio_stories/screens/selections/one_selection.dart';
import 'package:audio_stories/screens/selections/selection.dart';
import 'package:audio_stories/screens/splash/splash.dart';
import 'package:flutter/material.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final Object? arguments = settings.arguments;

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
        builder = (_) => SignUpSmsScreen();
        break;
      case SignUpThanksScreen.routeName:
        builder = (_) => const SignUpThanksScreen();
        break;
      case AuthUserThanksScreen.routeName:
        builder = (_) => const AuthUserThanksScreen();
        break;
      case HomeScreen.routeName:
        builder = (_) => const HomeScreen();
        break;
      case RecordWaveScreen.routeName:
        builder = (_) => const RecordWaveScreen();
        break;
      case PlayerScreen.routeName:
        builder = (_) => const PlayerScreen();
        break;
      case SaveTrackScreen.routeName:
        builder = (_) => const SaveTrackScreen();
        break;
      case ProfileScreen.routeName:
        builder = (_) => const ProfileScreen();
        break;
      case ProfileEditScreen.routeName:
        builder = (_) => const ProfileEditScreen();
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
      case ChoiceSelectionScreen.routeName:
        builder = (_) => const ChoiceSelectionScreen();
        break;
      case EditSelectionScreen.routeName:
        builder = (_) => const EditSelectionScreen();
        break;
      case OneSelectionScreen.routeName:
        builder = (_) => const OneSelectionScreen();
        break;
      case DeletedTracksScreen.routeName:
        builder = (_) => const DeletedTracksScreen();
        break;
      case DeletedTracksChoiceScreen.routeName:
        builder = (_) => const DeletedTracksChoiceScreen();
        break;
      case SearchTrackScreen.routeName:
        builder = (_) => const SearchTrackScreen();
        break;
      case ChoiceSomeSelectionsScreen.routeName:
        builder = (_) => const ChoiceSomeSelectionsScreen();
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
