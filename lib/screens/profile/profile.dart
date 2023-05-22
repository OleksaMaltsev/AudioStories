import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: PurplePainter(),
        child: Column(
          children: [
            // Builder(
            //     builder: (context) => IconButton(
            //         onPressed: () => Scaffold.of(context).openDrawer(),
            //         icon: Icon(Icons.face)))
          ],
        ),
      ),
    );
  }
}
