import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpThanksScreen extends StatefulWidget {
  const SignUpThanksScreen({super.key});

  static const String routeName = '/sign_up_thanks';

  @override
  State<SignUpThanksScreen> createState() => _SignUpThanksScreenState();
}

class _SignUpThanksScreenState extends State<SignUpThanksScreen> {
  @override
  void initState() {
    super.initState();
    _navigationToMain();
  }

  Future _navigationToMain() async {
    await Future.delayed(
      const Duration(milliseconds: 2000),
    );
    Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: CustomPaint(
          painter: PurplePainter(),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(height: 60),
                Text(
                  ' Ти супер!',
                  style: mainTheme.textTheme.titleLarge?.copyWith(fontSize: 48),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 150, 50, 0),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: ColorsApp.colorWhite,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(25, 0, 0, 0),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'Ми раді тебе бачити',
                          style: mainTheme.textTheme.labelLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 60),
                      SvgPicture.asset(
                        'assets/svg/Heart.svg',
                        height: 46,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
