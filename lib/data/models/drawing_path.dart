import 'dart:ui';

import 'brush_model.dart';

class DrawingPath {
  final BrushData brush;
  final Color color;
  final double width;
  final List<
      ({
        Offset offset,
        List<double>? randomOffset,
        double? randomSize,
      })> points;

  DrawingPath({
    required this.brush,
    required this.color,
    required this.width,
    required this.points,
  });
}
