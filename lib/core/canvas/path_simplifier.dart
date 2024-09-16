import 'dart:math';
import 'package:flutter/material.dart';

class PathSimplifier {
  static List<Offset> simplifyPath(List<Offset> points, double tolerance) {
    if (points.length <= 2) {
      return points;
    }

    double maxDistance = 0;
    int index = 0;
    final end = points.length - 1;

    for (int i = 1; i < end; i++) {
      double distance =
          perpendicularDistance(points[i], points[0], points[end]);
      if (distance > maxDistance) {
        index = i;
        maxDistance = distance;
      }
    }

    if (maxDistance > tolerance) {
      final List<Offset> results1 =
          simplifyPath(points.sublist(0, index + 1), tolerance);
      final List<Offset> results2 =
          simplifyPath(points.sublist(index), tolerance);

      results1.removeLast();
      results1.addAll(results2);
      return results1;
    } else {
      return [points[0], points[end]];
    }
  }

  static double perpendicularDistance(
    Offset point,
    Offset lineStart,
    Offset lineEnd,
  ) {
    double dx = lineEnd.dx - lineStart.dx;
    double dy = lineEnd.dy - lineStart.dy;

    double mag = sqrt(dx * dx + dy * dy);
    if (mag > 0) {
      dx /= mag;
      dy /= mag;
    }

    double pvx = point.dx - lineStart.dx;
    double pvy = point.dy - lineStart.dy;

    double pvdot = dx * pvx + dy * pvy;

    double ax = pvx - pvdot * dx;
    double ay = pvy - pvdot * dy;

    return sqrt(ax * ax + ay * ay);
  }
}
