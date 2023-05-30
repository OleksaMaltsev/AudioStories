import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/screens/selections/widgets/custom_selections_app_bar.dart';
import 'package:audio_stories/screens/selections/widgets/stories_box_selections.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import 'package:audio_stories/widgets/custom_drawer.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
          child: Column(
            children: [
              const CustomSelectionsAppBar(
                leading: null,
                title: 'Добірки',
                subTitle: 'Все в одному місці',
                actions: null,
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
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
            ],
          ),
        ),
      ),
      //bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}
