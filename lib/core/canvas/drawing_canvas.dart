import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import '../../data/models/drawing_path.dart';
import '../extensions/offset_extensions.dart';

class DrawingCanvas {
  void drawPath(Canvas canvas, Size size, DrawingPath drawingPath) {
    if (drawingPath.brush.customPainter != null) {
      drawingPath.brush.customPainter!(canvas, size, drawingPath);
      return;
    }

    final paint = Paint()
      ..color = drawingPath.color.withOpacity(1 - drawingPath.brush.opacityDiff)
      ..strokeCap = drawingPath.brush.strokeCap
      ..strokeJoin = drawingPath.brush.strokeJoin
      ..strokeWidth = drawingPath.width
      ..style = PaintingStyle.stroke
      ..blendMode = drawingPath.brush.blendMode
      ..colorFilter = drawingPath.brush.brush != null
          ? ColorFilter.mode(
              drawingPath.color,
              BlendMode.srcATop,
            )
          : null;

    var path = Path();
    if (drawingPath.points.length < 2) {
      return;
    }
    if (drawingPath.image case var image?) {
      canvas.drawImage(image, Offset.zero, paint);
    } else if (drawingPath.brush.brush != null) {
      drawTexturedPath(canvas, path, paint, drawingPath);
    } else {
      drawSimplePath(canvas, drawingPath, paint);
    }
  }

  void drawSimplePath(Canvas canvas, DrawingPath drawingPath, Paint paint) {
    final path = Path();
    path.moveTo(
      drawingPath.points.first.offset.dx,
      drawingPath.points.first.offset.dy,
    );

    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1];
      final p1 = drawingPath.points[i];

      path.quadraticBezierTo(
        p0.offset.dx,
        p0.offset.dy,
        (p0.offset.dx + p1.offset.dx) / 2,
        (p0.offset.dy + p1.offset.dy) / 2,
      );
    }

    canvas.drawPath(path, paint);
  }

  void drawTexturedPath(
    Canvas canvas,
    Path path,
    Paint paint,
    DrawingPath drawingPath,
  ) {
    final path = Path();
    path.moveTo(
      drawingPath.points.first.offset.dx,
      drawingPath.points.first.offset.dy,
    );

    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1];
      final p1 = drawingPath.points[i];

      path.quadraticBezierTo(
        p0.offset.dx,
        p0.offset.dy,
        (p0.offset.dx + p1.offset.dx) / 2,
        (p0.offset.dy + p1.offset.dy) / 2,
      );
    }

    final pathMetrics = path.computeMetrics();
    final brush = drawingPath.brush.brush!;
    final src = Rect.fromLTWH(
      0,
      0,
      brush.width.toDouble(),
      brush.height.toDouble(),
    );

    for (final metric in pathMetrics) {
      var distance = 0.0;

      while (distance < metric.length) {
        final tangent = metric.getTangentForOffset(distance)!;
        final point = tangent.position;

        final radius = (drawingPath.width - 2);
        final dst = Rect.fromCircle(center: point, radius: radius);

        canvas.save();
        canvas.translate(point.dx, point.dy);
        canvas.rotate(tangent.angle);
        canvas.translate(-point.dx, -point.dy);
        canvas.drawImageRect(brush, src, dst, paint);
        canvas.restore();

        distance += (drawingPath.brush.useBrushWidthDensity
            ? drawingPath.width + drawingPath.brush.densityOffset
            : drawingPath.brush.densityOffset);
      }
    }
  }
}
