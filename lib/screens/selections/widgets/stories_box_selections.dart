import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class StoriesBoxSelections extends StatelessWidget {
  final String imagePath;
  final String storiesName;
  const StoriesBoxSelections({
    required this.imagePath,
    required this.storiesName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 222,
      width: MediaQuery.of(context).size.width * 0.45,
      child: Stack(
        children: [
          Image.asset(imagePath),
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
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 60,
                  child: AutoSizeText(
                    storiesName,
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
          ),
        ],
      ),
    );
  }
}
