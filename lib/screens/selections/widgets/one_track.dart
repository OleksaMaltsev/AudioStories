import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/screens/selections/widgets/dropdown_button_track_selection.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OneTrackWidget extends StatefulWidget {
  const OneTrackWidget({super.key});

  @override
  State<OneTrackWidget> createState() => _OneTrackWidgetState();
}

class _OneTrackWidgetState extends State<OneTrackWidget> {
  bool playTrack = true;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                        style: mainTheme.textTheme.labelSmall?.copyWith(
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
                const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(''),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
