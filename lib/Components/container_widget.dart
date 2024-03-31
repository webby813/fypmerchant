import 'package:flutter/material.dart';

class DashedBorder extends StatelessWidget {
  final double strokeWidth;
  final Color color;
  final Widget child;

  DashedBorder({
    super.key,
    required this.child,
    this.strokeWidth = 1.0,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        strokeWidth: strokeWidth,
        color: color,
      ),
      child: child,
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;

  DashedBorderPainter({
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 5;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
          Offset(0, startY), Offset(0 + dashWidth, startY), paint);
      startY += dashSpace + dashWidth;
    }

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
          Offset(startX, 0), Offset(startX, 0 + dashWidth), paint);
      startX += dashSpace + dashWidth;
    }

    double endY = size.height;
    while (endY > 0) {
      canvas.drawLine(Offset(size.width, endY),
          Offset(size.width - dashWidth, endY), paint);
      endY -= dashSpace + dashWidth;
    }

    double endX = size.width;
    while (endX > 0) {
      canvas.drawLine(Offset(endX, size.height),
          Offset(endX, size.height - dashWidth), paint);
      endX -= dashSpace + dashWidth;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
