import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/screens/selections/edit_selection.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BigStoriesBoxSelections extends StatefulWidget {
  final String imagePath;
  final String storiesName;
  const BigStoriesBoxSelections({
    required this.imagePath,
    required this.storiesName,
    super.key,
  });

  @override
  State<BigStoriesBoxSelections> createState() =>
      _BigStoriesBoxSelectionsState();
}

class _BigStoriesBoxSelectionsState extends State<BigStoriesBoxSelections> {
  bool play = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          EditSelectionScreen.routeName,
        );
      },
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    widget.imagePath,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.1,
                    0.6,
                  ],
                  colors: [
                    Color.fromARGB(50, 0, 0, 0),
                    Color.fromARGB(140, 45, 45, 45),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 60,
                        child: AutoSizeText(
                          widget.storiesName,
                          style: mainTheme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorsApp.colorWhite,
                          ),
                          maxLines: 5,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '7 аудіо',
                            style: mainTheme.textTheme.labelMedium?.copyWith(
                              color: ColorsApp.colorWhite,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '2:30 годин',
                            style: mainTheme.textTheme.labelMedium?.copyWith(
                              color: ColorsApp.colorWhite,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            play = !play;
                          });
                        },
                        child: Container(
                          width: 158,
                          height: 46,
                          padding: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(60, 255, 255, 255),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              !play
                                  ? SvgPicture.asset(
                                      AppIcons.play,
                                      color: ColorsApp.colorWhite,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: SvgPicture.asset(
                                        AppIcons.pause,
                                        width: 38,
                                        color: ColorsApp.colorWhite,
                                      ),
                                    ),
                              Text(
                                'Запустити все',
                                style: mainTheme.textTheme.labelSmall?.copyWith(
                                  color: ColorsApp.colorWhite,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
