import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/screens/selections/widgets/big_stories_box_selections.dart';
import 'package:audio_stories/screens/selections/widgets/custom_app_bar_selections.dart';
import 'package:audio_stories/screens/selections/widgets/dropdown_button_one_selection.dart';
import 'package:audio_stories/screens/selections/widgets/one_track.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:flutter/material.dart';

class EditSelectionScreen extends StatefulWidget {
  const EditSelectionScreen({super.key});
  static const String routeName = '/edit-selections';

  @override
  State<EditSelectionScreen> createState() => _EditSelectionScreenState();
}

class _EditSelectionScreenState extends State<EditSelectionScreen> {
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
              const CustomAppBarSelections(
                name: '',
                actions: DropdownButtonOneSellection(
                  fileDocId: '',
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Назва',
                      style: mainTheme.textTheme.labelLarge?.copyWith(
                        color: ColorsApp.colorWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //todo: refresh
                  // BigStoriesBoxSelections(
                  //   imagePath: 'assets/images/Rectangle382big.png',
                  //   storiesName: '20.01.22',
                  //   dateTime: ,
                  // ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Сказка о маленьком принце. Он родился в старой деревне и задавался всего-лишь одним вопросом - “Кто я такой?”.Он познакомился со старенькой бабушкой, которая рассказала ему легенду о малыше Кокки...',
                      style: mainTheme.textTheme.labelSmall,
                      maxLines: 3,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Детальніше',
                      style: mainTheme.textTheme.labelSmall?.copyWith(
                        color: ColorsApp.colorLightOpacityDark,
                      ),
                    ),
                  ),
                  const OneTrackWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
