import 'package:flutter/material.dart';

class PodiumPainter extends CustomPainter {
  final Color firstPlaceColor;
  final Color secondPlaceColor;
  final Color thirdPlaceColor;

  PodiumPainter({
    required this.firstPlaceColor,
    required this.secondPlaceColor,
    required this.thirdPlaceColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // The width is divided into three equal columns.
    final stepWidth = size.width / 3;

    // Heights for the steps
    final firstHeight = size.height;
    final secondHeight = size.height * 0.7;
    final thirdHeight = size.height * 0.5;

    // Top face depth for the 3D effect
    final topDepth = size.height * 0.15;
    
    // Draw 2nd place (left)
    _drawStep(
      canvas,
      xOffset: 0,
      yOffset: size.height - secondHeight,
      width: stepWidth,
      height: secondHeight,
      topDepth: topDepth,
      baseColor: secondPlaceColor,
    );

    // Draw 3rd place (right)
    _drawStep(
      canvas,
      xOffset: stepWidth * 2,
      yOffset: size.height - thirdHeight,
      width: stepWidth,
      height: thirdHeight,
      topDepth: topDepth,
      baseColor: thirdPlaceColor,
    );

    // Draw 1st place (center) - drawn last so it overlaps the others slightly if needed
    _drawStep(
      canvas,
      xOffset: stepWidth,
      yOffset: size.height - firstHeight,
      width: stepWidth,
      height: firstHeight,
      topDepth: topDepth,
      baseColor: firstPlaceColor,
    );
  }

  void _drawStep(
    Canvas canvas, {
    required double xOffset,
    required double yOffset,
    required double width,
    required double height,
    required double topDepth,
    required Color baseColor,
  }) {
    // Colors for shading
    final frontColor = baseColor;
    final topColor = _lighten(baseColor, 0.15);
    final sideColor = _darken(baseColor, 0.15);

    // Front face
    final frontPaint = Paint()..color = frontColor;
    canvas.drawRect(
      Rect.fromLTWH(xOffset, yOffset + topDepth, width, height - topDepth),
      frontPaint,
    );

    // Top face (parallelogram)
    final topPaint = Paint()..color = topColor;
    final topPath = Path()
      ..moveTo(xOffset, yOffset + topDepth)
      ..lineTo(xOffset + topDepth, yOffset)
      ..lineTo(xOffset + width + topDepth, yOffset)
      ..lineTo(xOffset + width, yOffset + topDepth)
      ..close();
    canvas.drawPath(topPath, topPaint);

    // Right side face
    final sidePaint = Paint()..color = sideColor;
    final sidePath = Path()
      ..moveTo(xOffset + width, yOffset + topDepth)
      ..lineTo(xOffset + width + topDepth, yOffset)
      ..lineTo(xOffset + width + topDepth, yOffset + height - topDepth)
      ..lineTo(xOffset + width, yOffset + height)
      ..close();
    canvas.drawPath(sidePath, sidePaint);
  }

  Color _lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  Color _darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
