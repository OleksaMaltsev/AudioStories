import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:flutter/material.dart';

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
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Column(
                children: [
                  Text('Назва', style: mainTheme.textTheme.labelLarge),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
