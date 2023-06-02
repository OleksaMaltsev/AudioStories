import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddSelectionScreen extends StatefulWidget {
  const AddSelectionScreen({super.key});
  static const String routeName = '/add-selections';

  @override
  State<AddSelectionScreen> createState() => _AddSelectionScreenState();
}

class _AddSelectionScreenState extends State<AddSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: GreenPainter(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 50, 15, 10),
          width: double.infinity,
          child: Column(
            children: [
              const CustomAppBarSelections(),
              const SizedBox(height: 10),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Назва',
                      style: mainTheme.textTheme.labelLarge
                          ?.copyWith(color: ColorsApp.colorWhite),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    width: double.infinity,
                    height: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(190, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: InkWell(
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorsApp.colorLightOpacityDark,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              AppIcons.camera,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Введіть опис...',
                      labelStyle: mainTheme.textTheme.labelSmall,
                      counter: InkWell(
                        onTap: () {},
                        child: Text(
                          'Готово',
                          style: mainTheme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  InkWell(
                    onTap: () {},
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Додати аудіозапис',
                        style: mainTheme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBarSelections extends StatelessWidget {
  const CustomAppBarSelections({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(
              context,
              (route) => false,
            );
          },
          child: SvgPicture.asset(AppIcons.back),
        ),
        Text(
          'Створення',
          style: mainTheme.textTheme.titleMedium,
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.only(top: 25),
            child: Text(
              'Готово',
              style: mainTheme.textTheme.labelMedium?.copyWith(
                color: ColorsApp.colorWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
