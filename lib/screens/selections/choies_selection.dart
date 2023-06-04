import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChoiceSelectionScreen extends StatefulWidget {
  const ChoiceSelectionScreen({super.key});
  static const String routeName = '/choice-selections';

  @override
  State<ChoiceSelectionScreen> createState() => _ChoiceSelectionScreenState();
}

class _ChoiceSelectionScreenState extends State<ChoiceSelectionScreen> {
  bool choose = false;
  bool playTrack = true;
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
              const SizedBox(height: 30),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 25, 0),
                    decoration: BoxDecoration(
                      color: ColorsApp.colorOriginalWhite,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Пошук',
                        hintStyle: mainTheme.textTheme.labelMedium?.copyWith(
                          fontSize: 20,
                          color: ColorsApp.colorLightOpacityDark,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: SvgPicture.asset(
                          AppIcons.search,
                          width: 30,
                        ),
                        suffixIconConstraints: BoxConstraints.tight(
                          const Size(30, 30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: ColorsApp.colorSlimOpacityDark,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              left: 5,
                              right: 20,
                            ),
                            child: InkWell(
                              onTap: () {
                                playTrack = !playTrack;
                                setState(() {});
                              },
                              child: SvgPicture.asset(
                                playTrack ? AppIcons.play50 : AppIcons.pause50,
                                color: ColorsApp.colorLightGreen,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Track 1',
                                  style:
                                      mainTheme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '30 хвилин',
                                  style: mainTheme.textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: InkWell(
                              onTap: () => setState(() {
                                choose = !choose;
                              }),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    width: 2,
                                    color: ColorsApp.colorLightDark,
                                  ),
                                ),
                                child: choose
                                    ? SvgPicture.asset(AppIcons.tickSquare)
                                    : const SizedBox(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
          'Вибрати',
          style: mainTheme.textTheme.titleMedium,
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.only(top: 25),
            child: Text(
              'Додати',
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
