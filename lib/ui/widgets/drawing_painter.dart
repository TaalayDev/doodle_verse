import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../data/models/drawing_path.dart';
import '../../core/extensions/offset_extensions.dart';

class DrawingPainter extends CustomPainter {
  DrawingPainter(this.paths, this.currentPath);

  final List<ui.Image> paths;
  final DrawingPath? currentPath;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    for (var path in paths) {
      canvas.drawImage(path, Offset.zero, Paint());
    }
    if (currentPath != null) {
      _drawPath(canvas, currentPath!);
    }
    canvas.restore();
  }

  void _drawPath(Canvas canvas, DrawingPath drawingPath) {
    if (drawingPath.brush.customPainter != null) {
      drawingPath.brush.customPainter!(canvas, drawingPath);
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
    if (drawingPath.brush.pathEffect != null) {
      _drawPathEffect(canvas, drawingPath, paint);
    } else if (drawingPath.brush.brush != null) {
      _drawTexturedPath(canvas, path, paint, drawingPath);
    } else {
      _drawSimplePath(canvas, drawingPath, paint);
    }
  }

  void _drawPathEffect(Canvas canvas, DrawingPath drawingPath, Paint paint) {
    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1];
      final p1 = drawingPath.points[i];

      p0.offset.calculateDensityOffset(
        p1.offset,
        drawingPath.brush.densityOffset,
        (offset) {
          final effect = drawingPath.brush.pathEffect!(
            p1.randomSize ?? drawingPath.width,
            offset,
            p1.randomOffset ?? [],
          );

          paint.strokeWidth = p1.randomSize ?? drawingPath.width;

          canvas.drawPath(effect, paint);
        },
      );
    }
  }

  void _drawSimplePath(Canvas canvas, DrawingPath drawingPath, Paint paint) {
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

  void _drawTexturedPath(
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

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
