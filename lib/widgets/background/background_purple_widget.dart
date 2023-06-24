import 'package:audio_stories/constants/colors.dart';
import 'package:flutter/material.dart';

class PurplePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = ColorsApp.colorWhite;
    canvas.drawPath(mainBackground, paint);

    Path ovalPath = Path();
    ovalPath.moveTo(width * 2, height * 0.01);

    ovalPath.quadraticBezierTo(
        width * 0.99, height * 0.40, width * 0, height * 0.20);

    ovalPath.lineTo(0, -height);

    ovalPath.close();

    paint.color = ColorsApp.colorPurple;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
