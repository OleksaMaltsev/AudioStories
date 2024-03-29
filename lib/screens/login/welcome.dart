import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/screens/login/sign_up.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
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
                    style:
                        mainTheme.textTheme.titleLarge?.copyWith(fontSize: 48),
                  ),
                  Text(
                    'Твій голос завжди поруч',
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
                      'Вітаю!',
                      style: mainTheme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Ми раді бачити тебе тут. \nЦей додаток допоможе записувати казки та тримати їх у зручному місці, не заповнюючи пам\'ять на телефоні',
                      style: mainTheme.textTheme.labelMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    OrangeButton(
                        text: 'Продовжити',
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
    );
  }
}
