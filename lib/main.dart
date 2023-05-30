import 'package:audio_stories/providers/change_choose_provider.dart';
import 'package:audio_stories/routes/routes.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/screens/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChangeChooseProvider(),
        )
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
