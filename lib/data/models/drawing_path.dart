import 'dart:math' show Random;
import 'dart:ui';

import 'brush_model.dart';

class DrawingPath {
  final BrushData brush;
  final Color color;
  final double width;
  final List<DrawingPoint> points;
  Image? image;
  Map<String, double> randoms = {};

  DrawingPath({
    required this.brush,
    required this.color,
    required this.width,
    required this.points,
  });

  double getRandom(List<num> vals) {
    final key = vals.join('');
    if (randoms.containsKey(key)) {
      return randoms[key]!;
    } else {
      final random = Random().nextDouble();
      randoms[key] = random;
      return random;
    }
  }

  Rect? getBoundingBox() {
    if (points.isEmpty) return null;

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (var point in points) {
      minX = minX < point.offset.dx ? minX : point.offset.dx;
      minY = minY < point.offset.dy ? minY : point.offset.dy;
      maxX = maxX > point.offset.dx ? maxX : point.offset.dx;
      maxY = maxY > point.offset.dy ? maxY : point.offset.dy;
    }

    // Add padding for stroke width
    final padding = width / 2;
    return Rect.fromLTRB(
      minX - padding,
      minY - padding,
      maxX + padding,
      maxY + padding,
    );
  }
}

class DrawingPoint {
  final Offset offset;
  final double? randomSize;

  DrawingPoint({
    required this.offset,
    this.randomSize,
  });
}
