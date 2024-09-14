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
}

class DrawingPoint {
  final Offset offset;
  final double? randomSize;

  DrawingPoint({
    required this.offset,
    this.randomSize,
  });
}
