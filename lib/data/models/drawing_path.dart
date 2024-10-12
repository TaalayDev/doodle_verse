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
  final Path path;
  final Offset startPoint;
  final Offset endPoint;
  final Map<String, double> randoms = {};

  DrawingPath(
    this.path, {
    required this.brush,
    required this.color,
    required this.width,
    required this.points,
    this.startPoint = Offset.zero,
    this.endPoint = Offset.zero,
  });

  Path createPath() {
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
    Path? path,
    BrushData? brush,
    Color? color,
    double? width,
    List<Offset>? points,
    Offset? startPoint,
    Offset? endPoint,
  }) {
    return DrawingPath(
      path ?? this.path,
      brush: brush ?? this.brush,
      color: color ?? this.color,
      width: width ?? this.width,
      points: points ?? this.points,
      startPoint: startPoint ?? this.startPoint,
      endPoint: endPoint ?? this.endPoint,
    )..randoms.addAll(randoms);
  }

  @override
  List<Object?> get props => [brush, color, width, points, id, path];
}
