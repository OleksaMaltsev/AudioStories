import 'package:audio_stories/firebase_options.dart';
import 'package:audio_stories/providers/allow_to_delete_provider.dart';
import 'package:audio_stories/providers/change_choose_provider.dart';
import 'package:audio_stories/providers/change_name_track.dart';
import 'package:audio_stories/providers/choise_tracks_provider.dart';
import 'package:audio_stories/providers/delete_list_provider.dart';
import 'package:audio_stories/providers/sellection_create_provider.dart';
import 'package:audio_stories/providers/sellection_value_provider.dart';
import 'package:audio_stories/providers/sms_code_provider.dart';
import 'package:audio_stories/providers/track_menu_provider.dart';
import 'package:audio_stories/providers/track_path_provider.dart';
import 'package:audio_stories/providers/user_sign_up_provider.dart';
import 'package:audio_stories/routes/routes.dart';
import 'package:audio_stories/screens/splash/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ScreenUtilInit(
    builder: (context, child) {
      return MyApp();
    },
    minTextAdapt: true,
    designSize: const Size(414, 896),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  //final UserSignUpProvider userT = UserSignUpProvider(userPhone: '0');
  String user1 = '9';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChangeChooseProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserSignUpProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SmsCodeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TrackPathProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChangeNamePovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TrackMenuProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SellesticonCreateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChoiseTrackProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChangeNameGreenPovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AllowToDeleteProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SellectionValueProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DeleteListProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: SplashScreen.routeName,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
