import 'package:audio_stories/thems/main_thame.dart';
import 'package:flutter/material.dart';

class DescriptionISingUpWidget extends StatelessWidget {
  const DescriptionISingUpWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Реєстрація прив\'яже твої казки до хмари, після чого вони завжди будуть із тобою',
      style: mainTheme.textTheme.labelSmall,
      textAlign: TextAlign.center,
    );
  }
}
