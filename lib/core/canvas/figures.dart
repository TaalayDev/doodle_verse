import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../data.dart';

final rectangleTool = BrushData(
  id: 29,
  name: 'rectangle',
  stroke: 'rectangle_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    final rect = Rect.fromPoints(startPoint, endPoint);

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width;

    canvas.drawRect(rect, paint);
  },
);

final circleTool = BrushData(
  id: 30,
  name: 'circle',
  stroke: 'circle_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    final radius = (startPoint - endPoint).distance;

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width;

    canvas.drawCircle(startPoint, radius, paint);
  },
);

final lineTool = BrushData(
  id: 31,
  name: 'line',
  stroke: 'line_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width;

    canvas.drawLine(startPoint, endPoint, paint);
  },
);

final triangleTool = BrushData(
  id: 32,
  name: 'triangle',
  stroke: 'triangle_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width;

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    final path = Path()
      ..moveTo(startPoint.dx, endPoint.dy)
      ..lineTo((startPoint.dx + endPoint.dx) / 2, startPoint.dy)
      ..lineTo(endPoint.dx, endPoint.dy)
      ..close();

    canvas.drawPath(path, paint);
  },
);

final arrowTool = BrushData(
  id: 33,
  name: 'arrow',
  stroke: 'arrow_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width
      ..strokeCap = StrokeCap.round;

    // Draw the main line
    canvas.drawLine(startPoint, endPoint, paint);

    // Calculate arrow head
    final angle = atan2(
      endPoint.dy - startPoint.dy,
      endPoint.dx - startPoint.dx,
    );
    const arrowLength = 20.0;
    const arrowAngle = pi / 6; // 30 degrees

    final x1 = endPoint.dx - arrowLength * cos(angle - arrowAngle);
    final y1 = endPoint.dy - arrowLength * sin(angle - arrowAngle);
    final x2 = endPoint.dx - arrowLength * cos(angle + arrowAngle);
    final y2 = endPoint.dy - arrowLength * sin(angle + arrowAngle);

    // Draw arrow head
    final arrowPath = Path()
      ..moveTo(endPoint.dx, endPoint.dy)
      ..lineTo(x1, y1)
      ..moveTo(endPoint.dx, endPoint.dy)
      ..lineTo(x2, y2);

    canvas.drawPath(arrowPath, paint);
  },
);

final ellipseTool = BrushData(
  id: 34,
  name: 'ellipse',
  stroke: 'ellipse_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    final rect = Rect.fromPoints(startPoint, endPoint);

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width;

    canvas.drawOval(rect, paint);
  },
);

final polygonTool = BrushData(
  id: 35,
  name: 'polygon',
  stroke: 'polygon_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width;

    final path = Path();

    for (int i = 0; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i].offset;

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();

    canvas.drawPath(path, paint);
  },
);

final starTool = BrushData(
  id: 36,
  name: 'star',
  stroke: 'star_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.fill
      ..strokeWidth = drawingPath.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..blendMode = BlendMode.srcOver;

    final path = Path();

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    final radius = (startPoint - endPoint).distance;

    const angle = 4 * pi / 5;

    final x = startPoint.dx;
    final y = startPoint.dy;

    const angleOffset = -pi / 2;

    for (int i = 0; i < 10; i++) {
      final x1 = x + radius * cos(angle * i + angleOffset);
      final y1 = y + radius * sin(angle * i + angleOffset);

      if (i == 0) {
        path.moveTo(x1, y1);
      } else {
        path.lineTo(x1, y1);
      }
    }

    path.close();

    canvas.drawPath(path, paint);
  },
);

final heartTool = BrushData(
  id: 37,
  name: 'heart',
  stroke: 'heart_tool',
  strokeCap: StrokeCap.round,
  strokeJoin: StrokeJoin.round,
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    final width = (endPoint.dx - startPoint.dx).abs();
    final height = (endPoint.dy - startPoint.dy).abs();

    final path = Path();
    path.moveTo(startPoint.dx + width / 2, startPoint.dy + height * 0.3);
    path.cubicTo(
        startPoint.dx + width * 0.1,
        startPoint.dy,
        startPoint.dx,
        startPoint.dy + height * 0.5,
        startPoint.dx + width / 2,
        startPoint.dy + height);
    path.cubicTo(
        startPoint.dx + width,
        startPoint.dy + height * 0.5,
        startPoint.dx + width * 0.9,
        startPoint.dy,
        startPoint.dx + width / 2,
        startPoint.dy + height * 0.3);

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.fill
      ..strokeWidth = drawingPath.width
      ..strokeCap = drawingPath.brush.strokeCap
      ..strokeJoin = drawingPath.brush.strokeJoin;

    canvas.drawPath(path, paint);
  },
);

final spiralTool = BrushData(
  id: 39,
  name: 'spiral',
  stroke: 'spiral_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width
      ..strokeCap = StrokeCap.round;

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    final center = Offset(
      (startPoint.dx + endPoint.dx) / 2,
      (startPoint.dy + endPoint.dy) / 2,
    );

    final maxRadius = (startPoint - endPoint).distance / 2;

    final path = Path();
    const numTurns = 5;
    const numPoints = 100;

    for (int i = 0; i <= numPoints; i++) {
      final ratio = i / numPoints;
      final angle = ratio * numTurns * 2 * pi;
      final radius = ratio * maxRadius;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  },
);

final cloudTool = BrushData(
  id: 39,
  name: 'cloud',
  stroke: 'cloud_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    // Calculate the bounding rectangle
    final left = min(startPoint.dx, endPoint.dx);
    final top = min(startPoint.dy, endPoint.dy);
    final right = max(startPoint.dx, endPoint.dx);
    final bottom = max(startPoint.dy, endPoint.dy);

    final width = right - left;
    final height = bottom - top;

    final rect = Rect.fromLTWH(left, top, width, height);

    final path = Path();
    final random = Random();

    // Increase the number of circles for a fluffier cloud
    final numCircles = 10;

    for (int i = 0; i < numCircles; i++) {
      // Random positions within the cloud's bounding rectangle
      final dx = rect.left + random.nextDouble() * rect.width;
      final dy = rect.top + random.nextDouble() * rect.height * 0.6;

      // Random sizes for variation
      final radius = rect.width * (0.15 + random.nextDouble() * 0.15);

      final circleRect = Rect.fromCircle(
        center: Offset(dx, dy),
        radius: radius,
      );
      path.addOval(circleRect);
    }

    final paint = Paint()
      ..color = drawingPath.color.withOpacity(0.8)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5.0); // Soft edges

    canvas.drawPath(path, paint);
  },
);

final lightningTool = BrushData(
  id: 40,
  name: 'lightning',
  stroke: 'lightning_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);

    final numSegments = 20; // Number of segments in the lightning bolt

    for (int i = 1; i <= numSegments; i++) {
      final t = i / numSegments;

      // Linear interpolation between startPoint and endPoint
      final dx = startPoint.dx + (endPoint.dx - startPoint.dx) * t;
      final dy = startPoint.dy + (endPoint.dy - startPoint.dy) * t;

      // Apply random offset perpendicular to the line
      final offsetMagnitude =
          (drawingPath.getRandom([i, t, dx, dy]) - 0.5) * drawingPath.width * 4;

      // Calculate the direction perpendicular to the main line
      final angle =
          atan2(endPoint.dy - startPoint.dy, endPoint.dx - startPoint.dx);
      final perpendicularAngle = angle + pi / 2;

      final offsetX = offsetMagnitude * cos(perpendicularAngle);
      final offsetY = offsetMagnitude * sin(perpendicularAngle);

      final nextX = dx + offsetX;
      final nextY = dy + offsetY;

      path.lineTo(nextX, nextY);
    }

    // Optionally, you can add a glow effect using a blur mask
    final glowPaint = Paint()
      ..color = drawingPath.color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width * 2
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, drawingPath.width);

    // Draw the glow behind the lightning bolt
    canvas.drawPath(path, glowPaint);

    // Draw the lightning bolt
    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  },
);

final pentagonTool = BrushData(
  id: 40,
  name: 'pentagon',
  stroke: 'pentagon_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width;

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    final center = Offset(
      (startPoint.dx + endPoint.dx) / 2,
      (startPoint.dy + endPoint.dy) / 2,
    );

    final radius = (startPoint - endPoint).distance / 2;

    final path = Path();
    const numSides = 5;
    for (int i = 0; i < numSides; i++) {
      final angle = (2 * pi / numSides) * i - pi / 2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  },
);

// Hexagon Tool
final hexagonTool = BrushData(
  id: 41,
  name: 'hexagon',
  stroke: 'hexagon_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width;

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    final center = Offset(
      (startPoint.dx + endPoint.dx) / 2,
      (startPoint.dy + endPoint.dy) / 2,
    );

    final radius = (startPoint - endPoint).distance / 2;

    final path = Path();
    const numSides = 6;
    for (int i = 0; i < numSides; i++) {
      final angle = (2 * pi / numSides) * i - pi / 2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  },
);

// Parallelogram Tool
final parallelogramTool = BrushData(
  id: 42,
  name: 'parallelogram',
  stroke: 'parallelogram_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width;

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    final width = (endPoint.dx - startPoint.dx).abs();
    final height = (endPoint.dy - startPoint.dy).abs();
    final skew = width / 4;

    final path = Path()
      ..moveTo(startPoint.dx + skew, startPoint.dy)
      ..lineTo(endPoint.dx + skew, startPoint.dy)
      ..lineTo(endPoint.dx - skew, endPoint.dy)
      ..lineTo(startPoint.dx - skew, endPoint.dy)
      ..close();

    canvas.drawPath(path, paint);
  },
);

// Trapezoid Tool
final trapezoidTool = BrushData(
  id: 43,
  name: 'trapezoid',
  stroke: 'trapezoid_tool',
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width;

    final startPoint = drawingPath.points.first.offset;
    final endPoint = drawingPath.points.last.offset;

    final width = (endPoint.dx - startPoint.dx).abs();
    final height = (endPoint.dy - startPoint.dy).abs();
    final topWidth = width * 0.6;
    final offsetX = (width - topWidth) / 2;

    final path = Path()
      ..moveTo(startPoint.dx + offsetX, startPoint.dy)
      ..lineTo(endPoint.dx - offsetX, startPoint.dy)
      ..lineTo(endPoint.dx, endPoint.dy)
      ..lineTo(startPoint.dx, endPoint.dy)
      ..close();

    canvas.drawPath(path, paint);
  },
);
