import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/screens/login/sign_up.dart';
import 'package:audio_stories/screens/login/widgets/background_purple_widget.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/buttons/orange_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: PurplePainter(),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'MemoryBox',
                      style: mainTheme.textTheme.titleLarge
                          ?.copyWith(fontSize: 48),
                    ),
                    Text(
                      'Твой голос всегда рядом',
                      style: mainTheme.textTheme.labelSmall?.copyWith(
                        color: ColorsApp.colorWhite,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 150, 50, 0),
                  child: Column(
                    children: [
                      Text(
                        'Привет!',
                        style: mainTheme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Мы рады видеть тебя здесь. \nЭто приложение поможет записывать сказки и держать их в удобном месте не заполняя память на телефоне',
                        style: mainTheme.textTheme.labelMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      OrangeButton(
                          text: 'Продолжить',
                          function: () {
                            Navigator.pushNamed(
                              context,
                              SignUpScreen.routeName,
                            );
                          }),
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
