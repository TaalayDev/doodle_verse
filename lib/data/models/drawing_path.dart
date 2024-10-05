import 'dart:math' show Random;
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:uid/uid.dart';

import 'brush_model.dart';

class DrawingPath extends Equatable {
  final String id = UId.getId();
  final BrushData brush;
  final Color color;
  final double width;
  final List<Offset> points;
  final Map<String, double> randoms = {};

  DrawingPath({
    required this.brush,
    required this.color,
    required this.width,
    required this.points,
  });

  Path createPath() {
    final path = Path();
    if (points.isEmpty || points.length < 2) {
      return path;
    }

    path.moveTo(
      points.first.dx,
      points.first.dy,
    );

    for (int i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];

      path.quadraticBezierTo(
        p0.dx,
        p0.dy,
        (p0.dx + p1.dx) / 2,
        (p0.dy + p1.dy) / 2,
      );
    }

    return path;
  }

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

  Rect getBoundingBox() {
    if (points.isEmpty) return Rect.zero;
    double minX = points.first.dx;
    double minY = points.first.dy;
    double maxX = points.first.dx;
    double maxY = points.first.dy;

    for (var point in points) {
      if (point.dx < minX) minX = point.dx;
      if (point.dy < minY) minY = point.dy;
      if (point.dx > maxX) maxX = point.dx;
      if (point.dy > maxY) maxY = point.dy;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  bool intersects(Rect rect) {
    return getBoundingBox().overlaps(rect);
  }

  DrawingPath copyWith({
    BrushData? brush,
    Color? color,
    double? width,
    List<Offset>? points,
  }) {
    return DrawingPath(
      brush: brush ?? this.brush,
      color: color ?? this.color,
      width: width ?? this.width,
      points: points ?? this.points,
    )..randoms.addAll(randoms);
  }

  @override
  List<Object?> get props => [brush, color, width, points];
}
