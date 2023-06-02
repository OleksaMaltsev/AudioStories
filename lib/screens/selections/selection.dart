import 'package:audio_stories/screens/selections/choies_selection.dart';
import 'package:audio_stories/screens/selections/widgets/custom_selections_app_bar.dart';
import 'package:audio_stories/screens/selections/widgets/stories_box_selections.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:flutter/material.dart';

class SelectionsScreen extends StatefulWidget {
  const SelectionsScreen({super.key});
  static const String routeName = '/selections';

  @override
  State<SelectionsScreen> createState() => _SelectionsScreenState();
}

class _SelectionsScreenState extends State<SelectionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: GreenPainter(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Column(
            children: [
              CustomSelectionsAppBar(
                leading: null,
                title: 'Добірки',
                subTitle: 'Все в одному місці',
                actions: null,
              ),
              SizedBox(height: 30),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StoriesBoxSelections(
                        imagePath: 'assets/icons/Rectangle382.png',
                        storiesName: 'Казка про малюка Коккі',
                      ),
                      StoriesBoxSelections(
                        imagePath: 'assets/icons/Rectangle3822.png',
                        storiesName: 'Казка про Тараса',
                      ),
                    ],
                  ),
                ],
              ),
              //TODO: delete button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ChoiceSelectionScreen.routeName);
                },
                child: Text('choice_selection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
