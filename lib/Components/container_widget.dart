
import 'package:flutter/material.dart';

import '../Color/color.dart';

class DashedBorder extends StatelessWidget {
  final double strokeWidth;
  final Color color;
  final Widget child;

  const DashedBorder({
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

class SelectableAction extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableAction({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 110,
        width: 120,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: CustomColors.lightGrey,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: isSelected ? CustomColors.lightGreen : CustomColors.secondaryWhite,
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(20),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
