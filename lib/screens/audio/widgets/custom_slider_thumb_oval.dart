import 'package:audio_stories/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomSliderThumbOval extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;

  const CustomSliderThumbOval({
    required this.thumbRadius,
    this.min = 0,
    this.max = 10,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = ColorsApp.colorLightDark //Thumb Background Color
      ..style = PaintingStyle.fill;

    canvas.drawOval(
        Rect.fromCenter(center: center, width: 30, height: 15), paint);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}
