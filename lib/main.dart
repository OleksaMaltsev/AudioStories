import 'package:audio_stories/firebase_options.dart';
import 'package:audio_stories/providers/change_choose_provider.dart';
import 'package:audio_stories/providers/sms_code_provider.dart';
import 'package:audio_stories/providers/track_path_provider.dart';
import 'package:audio_stories/providers/user_sign_up_provider.dart';
import 'package:audio_stories/routes/routes.dart';
import 'package:audio_stories/screens/splash/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
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
