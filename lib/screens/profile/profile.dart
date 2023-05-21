import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: CustomPaint(
        painter: PurplePainter(),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
