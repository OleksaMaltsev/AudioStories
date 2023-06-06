import 'package:audio_stories/screens/login/sign_up.dart';
import 'package:audio_stories/screens/main_page.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigationToLogin();
  }

  Future _navigationToLogin() async {
    await Future.delayed(
      const Duration(milliseconds: 2000),
    );

    if (FirebaseAuth.instance.currentUser != null) {
      print(FirebaseAuth.instance.currentUser?.uid);
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainPage.routeName,
        (route) => false,
      );
    } else {
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        SignUpScreen.routeName,
        (_) => false,
      );
    }
    // Navigator.pushNamedAndRemoveUntil(
    //     context, HomeScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.4,
              0.6,
              0.7,
            ],
            colors: [
              Color(0xFF8077E4),
              Color(0xFFC384C8),
              Color(0xFFFF90AF),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MemoryBox',
              style: mainTheme.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SvgPicture.asset(
              'assets/svg/Component 1.svg',
              height: 46,
            ),
          ],
        ),
      ),
    );
  }
}
