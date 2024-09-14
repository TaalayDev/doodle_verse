import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/const.dart';
import '../../config/assets.dart';
import '../../data.dart';
import '../extensions/offset_extensions.dart';
import 'shader_manager.dart';

Future<ui.Image?> _loadUIImage(String asset) async {
  final data = await rootBundle.load(asset);
  final bytes = data.buffer.asUint8List();
  final codec = await ui.instantiateImageCodec(bytes);
  final fi = await codec.getNextFrame();

  return fi.image;
}

Future<BrushData> get pencil async => BrushData(
      id: 1,
      name: 'pencil',
      stroke: 'pencil_stroke',
      opacityDiff: 0.2,
      isNew: true,
      isLocked: true,
      densityOffset: 5.0,
      strokeJoin: ui.StrokeJoin.bevel,
      random: [-1, 1],
      sizeRandom: [-3, 3],
      useBrushWidthDensity: false,
      brush: await _loadUIImage(Assets.images.pencil),
    );

final softPencilBrush = BrushData(
  id: 42,
  name: 'soft pencil',
  stroke: 'soft_pencil_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color.withOpacity(0.3)
      ..strokeWidth = drawingPath.width * 0.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < drawingPath.points.length - 1; i++) {
      final p1 = drawingPath.points[i].offset;
      final p2 = drawingPath.points[i + 1].offset;

      for (int j = 0; j < 3; j++) {
        final x = drawingPath.getRandom([i, p1.dx, p1.dy, j, 1]);
        final y = drawingPath.getRandom([i, p1.dx, p1.dy, j, 2]);

        final offset = Offset(
          (x - 0.5) * drawingPath.width * 0.5,
          (y - 0.5) * drawingPath.width * 0.5,
        );
        canvas.drawLine(p1 + offset, p2 + offset, paint);
      }
    }
  },
);

final hardPencilBrush = BrushData(
  id: 43,
  name: 'hard pencil',
  stroke: 'hard_pencil_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color
      ..strokeWidth = drawingPath.width * 0.3
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < drawingPath.points.length - 1; i++) {
      final p1 = drawingPath.points[i].offset;
      final p2 = drawingPath.points[i + 1].offset;
      canvas.drawLine(p1, p2, paint);
    }
  },
);

final sketchyPencilBrush = BrushData(
  id: 44,
  name: 'sketchy pencil',
  stroke: 'sketchy_pencil_stroke',
  densityOffset: 2.0,
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color.withOpacity(0.4)
      ..strokeWidth = drawingPath.width * 0.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < drawingPath.points.length - 1; i++) {
      final p1 = drawingPath.points[i].offset;
      final p2 = drawingPath.points[i + 1].offset;

      for (int j = 0; j < 4; j++) {
        final random1 = drawingPath.getRandom([i, p1.dx, p1.dy, j, 1]);
        final random2 = drawingPath.getRandom([i, p1.dx, p1.dy, j, 2]);
        final random3 = drawingPath.getRandom([i, p2.dx, p2.dy, j, 1]);
        final random4 = drawingPath.getRandom([i, p2.dx, p2.dy, j, 2]);

        final offset1 = Offset(
          (random1 - 0.5) * drawingPath.width,
          (random2 - 0.5) * drawingPath.width,
        );
        final offset2 = Offset(
          (random3 - 0.5) * drawingPath.width,
          (random4 - 0.5) * drawingPath.width,
        );
        canvas.drawLine(p1 + offset1, p2 + offset2, paint);
      }
    }
  },
);

final coloredPencilBrush = BrushData(
  id: 45,
  name: 'colored pencil',
  stroke: 'colored_pencil_stroke',
  densityOffset: 1.5,
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color
      ..strokeWidth = drawingPath.width * 0.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < drawingPath.points.length - 1; i++) {
      final p1 = drawingPath.points[i].offset;
      final p2 = drawingPath.points[i + 1].offset;

      // Main stroke
      canvas.drawLine(p1, p2, paint);

      // Texture lines
      final perpendicular = (p2 - p1).dx != 0 || (p2 - p1).dy != 0
          ? Offset((p2 - p1).dy, -(p2 - p1).dx).normalized()
          : Offset.zero;

      for (int j = 0; j < 3; j++) {
        final offset = perpendicular * (j - 1) * drawingPath.width * 0.2;
        canvas.drawLine(
          p1 + offset,
          p2 + offset,
          paint..color = drawingPath.color.withOpacity(0.3),
        );
      }
    }
  },
);

const defaultBrush = BrushData(
  id: 0,
  name: 'Default',
  stroke: 'brush_stroke',
  densityOffset: 1.0,
  strokeCap: ui.StrokeCap.round,
);

Future<BrushData> get marker async => BrushData(
      id: 2,
      name: 'marker',
      stroke: 'marker_stroke',
      isNew: true,
      opacityDiff: 0.1,
      strokeCap: ui.StrokeCap.square,
      strokeJoin: ui.StrokeJoin.bevel,
      isLocked: true,
      densityOffset: 1.0,
      useBrushWidthDensity: false,
      brush: await _loadUIImage(Assets.images.marker2),
    );

final watercolor = BrushData(
  id: 3,
  name: 'watercolor',
  stroke: 'watercolor_stroke',
  densityOffset: 2.0,
  opacityDiff: 0.5,
  sizeRandom: [-20, 20],
  useBrushWidthDensity: false,
  customPainter: (canvas, size, drawingPath) async {
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

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..color = drawingPath.color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawPath(path, paint2);
  },
);

const eraser = BrushData(
  id: 5,
  name: 'eraser',
  stroke: 'eraser_stroke',
  densityOffset: 1.0,
  strokeCap: ui.StrokeCap.round,
  strokeJoin: ui.StrokeJoin.round,
  random: [-1, 1],
  sizeRandom: [-3, 3],
  useBrushWidthDensity: false,
  blendMode: ui.BlendMode.clear,
);

final crayon = BrushData(
  id: 6,
  name: 'crayon',
  stroke: 'crayon_stroke',
  opacityDiff: 0.1,
  strokeCap: ui.StrokeCap.round,
  strokeJoin: ui.StrokeJoin.round,
  random: [-2, 2],
  sizeRandom: [-1, 1],
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color.withOpacity(0.9)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = drawingPath.width
      ..style = PaintingStyle.stroke;

    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1].offset;
      final p1 = drawingPath.points[i].offset;

      // Draw multiple lines with slight random offsets to mimic crayon texture
      for (int j = 0; j < 3; j++) {
        final x = drawingPath.getRandom([i, p1.dx, p1.dy, j, 1]);
        final y = drawingPath.getRandom([i, p1.dx, p1.dy, j, 2]);
        final w = drawingPath.getRandom([i, p1.dx, p1.dy, j, 3]);

        final offset = Offset(
          (x - 0.5) * drawingPath.width * 0.3,
          (y - 0.5) * drawingPath.width * 0.3,
        );

        canvas.drawLine(
          p0 + offset,
          p1 + offset,
          paint..strokeWidth = drawingPath.width * (0.8 + w * 0.4),
        );
      }
    }
  },
);

final sprayPaint = BrushData(
  id: 7,
  name: 'sprayPaint',
  stroke: 'spray_paint_stroke',
  opacityDiff: 0.2,
  densityOffset: 5.0,
  random: [-5, 5],
  sizeRandom: [-5, 5],
  customPainter: (canvas, size, drawingPath) {
    final random = Random();
    final paint = Paint()
      ..color = drawingPath.color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (final point in drawingPath.points) {
      for (int i = 0; i < 20; i++) {
        final dx = point.offset.dx +
            (random.nextDouble() - 0.5) * drawingPath.width * 4;
        final dy = point.offset.dy +
            (random.nextDouble() - 0.5) * drawingPath.width * 4;
        final radius = random.nextDouble() * 1.5;
        canvas.drawCircle(Offset(dx, dy), radius, paint);
      }
    }
  },
);

const neon = BrushData(
  id: 8,
  name: 'neon',
  stroke: 'neon_stroke',
  opacityDiff: 0.1,
  densityOffset: 1,
  strokeCap: ui.StrokeCap.round,
  strokeJoin: ui.StrokeJoin.round,
  blendMode: ui.BlendMode.screen,
);

final charcoal = BrushData(
  id: 9,
  name: 'charcoal',
  stroke: 'charcoal_stroke',
  opacityDiff: 0.15,
  densityOffset: 5,
  strokeCap: ui.StrokeCap.square,
  strokeJoin: ui.StrokeJoin.bevel,
  random: [-3, 3],
  sizeRandom: [-2, 2],
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color.withOpacity(0.5)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = drawingPath.width * 1.5
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final path = Path();
    path.moveTo(
      drawingPath.points.first.offset.dx,
      drawingPath.points.first.offset.dy,
    );

    for (int i = 1; i < drawingPath.points.length; i++) {
      final random1 = drawingPath.getRandom([i, 1]);
      final random2 = drawingPath.getRandom([i, 2]);

      final p0 = drawingPath.points[i - 1];
      final p1 = drawingPath.points[i];

      // Add random offsets to create a rough, smudged effect
      final controlPoint = Offset(
        p0.offset.dx + (random1 - 0.5) * drawingPath.width * 0.5,
        p0.offset.dy + (random2 - 0.5) * drawingPath.width * 0.5,
      );

      path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        (p0.offset.dx + p1.offset.dx) / 2,
        (p0.offset.dy + p1.offset.dy) / 2,
      );
    }

    canvas.drawPath(path, paint);
  },
);

final sketchy = BrushData(
  id: 11,
  name: 'sketchy',
  stroke: 'sketchy_stroke',
  densityOffset: 30,
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (int j = 0; j < 3; j++) {
      final firstOffset = drawingPath.points.first.offset;
      final random1 =
          drawingPath.getRandom([j, firstOffset.dx, firstOffset.dy, 1]);
      final random2 =
          drawingPath.getRandom([j, firstOffset.dy, firstOffset.dx, 2]);
      final random3 =
          drawingPath.getRandom([j, firstOffset.dx, firstOffset.dy, 3]);

      paint.strokeWidth = drawingPath.width * (0.5 + random1 * 0.5);

      final path = Path();
      path.moveTo(
        firstOffset.dx + (random2 - 0.5) * drawingPath.width * 0.5,
        firstOffset.dy + (random3 - 0.5) * drawingPath.width * 0.5,
      );

      for (int i = 1; i < drawingPath.points.length; i++) {
        final p0 = drawingPath.points[i - 1];
        final p1 = drawingPath.points[i];

        final random4 =
            drawingPath.getRandom([i, p1.offset.dx, p1.offset.dy, j, 4]);
        final random5 =
            drawingPath.getRandom([i, p1.offset.dy, p1.offset.dx, j, 5]);
        final random6 =
            drawingPath.getRandom([i, p1.offset.dx, p1.offset.dy, j, 6]);
        final random7 =
            drawingPath.getRandom([i, p1.offset.dy, p1.offset.dx, j, 7]);

        path.quadraticBezierTo(
          p0.offset.dx + (random4 - 0.5) * drawingPath.width * 0.5,
          p0.offset.dy + (random5 - 0.5) * drawingPath.width * 0.5,
          (p0.offset.dx + p1.offset.dx) / 2 +
              (random6 - 0.5) * drawingPath.width * 0.5,
          (p0.offset.dy + p1.offset.dy) / 2 +
              (random7 - 0.5) * drawingPath.width * 0.5,
        );
      }

      canvas.drawPath(path, paint);
    }
  },
);

final star = BrushData(
  id: 9,
  name: 'star',
  stroke: 'star_stroke',
  densityOffset: 20,
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.fill;

    for (final point in drawingPath.points) {
      final starPath = Path();
      final center = point.offset;
      final size = drawingPath.width;

      for (int i = 0; i < 5; i++) {
        final angle = (i * 4 * pi / 5) - pi / 2;
        final outerPoint = Offset(
          center.dx + size * cos(angle),
          center.dy + size * sin(angle),
        );
        final innerAngle = angle + pi / 5;
        final innerPoint = Offset(
          center.dx + size * 0.4 * cos(innerAngle),
          center.dy + size * 0.4 * sin(innerAngle),
        );

        if (i == 0) {
          starPath.moveTo(outerPoint.dx, outerPoint.dy);
        } else {
          starPath.lineTo(outerPoint.dx, outerPoint.dy);
        }
        starPath.lineTo(innerPoint.dx, innerPoint.dy);
      }
      starPath.close();

      canvas.drawPath(starPath, paint);
    }
  },
);

final heart = BrushData(
  id: 10,
  name: 'heart',
  stroke: 'heart_stroke',
  densityOffset: 10,
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.fill;

    for (final point in drawingPath.points) {
      final center = point.offset;
      final size = drawingPath.width * 2.0;

      final path = Path();

      // Starting point at the top center of the heart
      path.moveTo(center.dx, center.dy + size * 0.2);

      // Left side of the heart
      path.cubicTo(
        center.dx - size * 0.6, center.dy - size * 0.2, // Control point 1
        center.dx - size * 0.6, center.dy + size * 0.5, // Control point 2
        center.dx, center.dy + size * 0.85, // End point
      );

      // Right side of the heart
      path.cubicTo(
        center.dx + size * 0.6, center.dy + size * 0.5, // Control point 1
        center.dx + size * 0.6, center.dy - size * 0.2, // Control point 2
        center.dx, center.dy + size * 0.2, // End point
      );

      path.close();

      canvas.drawPath(path, paint);
    }
  },
);

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

final bubbleBrush = BrushData(
  id: 12,
  name: 'bubble',
  stroke: 'bubble_stroke',
  densityOffset: 20,
  customPainter: (canvas, size, drawingPath) {
    for (final point in drawingPath.points) {
      final random1 =
          drawingPath.getRandom([point.offset.dx, point.offset.dy, 1]);
      final random2 =
          drawingPath.getRandom([point.offset.dy, point.offset.dx, 2]);
      final random3 =
          drawingPath.getRandom([point.offset.dx, point.offset.dy, 3]);

      final paint = Paint()
        ..color = drawingPath.color.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      final bubbleRadius =
          (drawingPath.width / 2) + random1 * (drawingPath.width);

      canvas.drawCircle(
        point.offset + Offset(random2 * 10 - 5, random3 * 10 - 5),
        bubbleRadius,
        paint,
      );
    }
  },
);

final glitterBrush = BrushData(
  id: 13,
  name: 'glitter',
  stroke: 'glitter_stroke',
  densityOffset: 20,
  customPainter: (canvas, size, drawingPath) {
    for (final point in drawingPath.points) {
      final offset = point.offset;
      final random1 = drawingPath.getRandom([offset.dx, offset.dy, 1]);
      final random2 = drawingPath.getRandom([offset.dy, offset.dx, 2]);
      final random3 = drawingPath.getRandom([offset.dx, offset.dy, 3]);
      final random4 = drawingPath.getRandom([offset.dy, offset.dx, 4]);

      final paint = Paint()
        ..color = drawingPath.color.withOpacity(random1)
        ..style = PaintingStyle.fill;

      final glitterSize = random2 * drawingPath.width / 2;

      canvas.drawCircle(
        point.offset +
            Offset(
              random3 * 10 - 5,
              random4 * 10 - 5,
            ),
        glitterSize,
        paint,
      );
    }
  },
);

final rainbowBrush = BrushData(
  id: 14,
  name: 'rainbow',
  stroke: 'rainbow_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final path = Path();
    path.moveTo(
        drawingPath.points.first.offset.dx, drawingPath.points.first.offset.dy);

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

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pathMetrics = path.computeMetrics().toList();
    for (var metric in pathMetrics) {
      final length = metric.length;
      final step = length / 360;
      for (double i = 0; i < length; i += step) {
        final color = HSVColor.fromAHSV(
          1.0,
          (i / length) * 360, // Hue from 0 to 360
          1.0,
          1.0,
        ).toColor();

        paint.color = color;

        final offset = metric.getTangentForOffset(i)!.position;
        canvas.drawCircle(offset, drawingPath.width / 2, paint);
      }
    }
  },
);

final sparkleBrush = BrushData(
  id: 15,
  name: 'sparkle',
  stroke: 'sparkle_stroke',
  densityOffset: 5.0,
  customPainter: (canvas, size, drawingPath) {
    final random = Random();
    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.fill;

    for (final point in drawingPath.points) {
      final offset = point.offset;
      final randomSize = drawingPath.getRandom([offset.dx, offset.dy, 1]);
      final randomRotation = drawingPath.getRandom([offset.dy, offset.dx, 2]);
      final randomOpacity = drawingPath.getRandom([offset.dx, offset.dy, 3]);

      paint.color = drawingPath.color.withOpacity(0.5 + randomOpacity * 0.5);

      final size = drawingPath.width * (0.5 + randomSize * 0.5);

      canvas.save();
      canvas.translate(point.offset.dx, point.offset.dy);
      canvas.rotate(randomRotation * 2 * pi);

      final path = Path();
      path.moveTo(0, -size / 2);
      for (int i = 1; i < 5; i++) {
        final angle = i * pi / 2.5;
        final x = sin(angle) * size / 2;
        final y = -cos(angle) * size / 2;
        path.lineTo(x, y);
      }
      path.close();

      canvas.drawPath(path, paint);
      canvas.restore();
    }
  },
);

final leafBrush = BrushData(
  id: 16,
  name: 'leaf',
  stroke: 'leaf_stroke',
  densityOffset: 15.0,
  customPainter: (canvas, size, drawingPath) {
    for (final point in drawingPath.points) {
      final offset = point.offset;
      final randomSize = drawingPath.getRandom([offset.dx, offset.dy, 1]);
      final randomRotation = drawingPath.getRandom([offset.dy, offset.dx, 2]);
      final randomColorVariation =
          drawingPath.getRandom([offset.dx, offset.dy, 3]);
      final randomSkew = drawingPath.getRandom([offset.dy, offset.dx, 4]);

      final paint = Paint()
        ..color = drawingPath.color
        ..style = PaintingStyle.fill;

      // Slightly vary the hue for natural color variation
      final colorVariation =
          (randomColorVariation - 0.5) * 10.0; // +/- 5 degrees hue shift
      final hsvColor = HSVColor.fromColor(paint.color);
      paint.color =
          hsvColor.withHue((hsvColor.hue + colorVariation) % 360).toColor();

      final size = drawingPath.width * (0.8 + randomSize * 0.4);

      canvas.save();
      canvas.translate(point.offset.dx, point.offset.dy);
      canvas.rotate((randomRotation - 0.5) * pi * 2);
      canvas.skew(
          (randomSkew - 0.5) * 0.2, 0.0); // Subtle skew for natural variation

      // Draw a leaf shape using cubic Bezier curves
      final path = Path();
      path.moveTo(0, -size / 2);
      path.cubicTo(
        size / 2, -size / 2, // Control point 1
        size / 2, size / 2, // Control point 2
        0, size / 2, // End point
      );
      path.cubicTo(
        -size / 2, size / 2, // Control point 3
        -size / 2, -size / 2, // Control point 4
        0, -size / 2, // Back to start
      );
      path.close();

      canvas.drawPath(path, paint);
      canvas.restore();
    }
  },
);

final grassBrush = BrushData(
  id: 17,
  name: 'grass',
  stroke: 'grass_stroke',
  densityOffset: 8.0,
  customPainter: (canvas, size, drawingPath) {
    for (final point in drawingPath.points) {
      final offset = point.offset;
      final randomLength = drawingPath.getRandom([offset.dx, offset.dy, 1]);
      final randomAngle = drawingPath.getRandom([offset.dy, offset.dx, 2]);
      final randomCurvature = drawingPath.getRandom([offset.dx, offset.dy, 3]);
      final randomColorVariation =
          drawingPath.getRandom([offset.dy, offset.dx, 4]);

      final paint = Paint()
        ..color = drawingPath.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = drawingPath.width * 0.1
        ..strokeCap = StrokeCap.round;

      // Slight color variation
      final colorVariation =
          (randomColorVariation - 0.5) * 5.0; // +/- 2.5 degrees hue shift
      final hsvColor = HSVColor.fromColor(paint.color);
      paint.color =
          hsvColor.withHue((hsvColor.hue + colorVariation) % 360).toColor();

      final length = drawingPath.width * 2 * (0.5 + randomLength * 0.5);
      final angle = (randomAngle - 0.5) * pi / 6; // -30 to +30 degrees
      final curvature = (randomCurvature - 0.5) * length / 2;

      final path = Path();
      path.moveTo(point.offset.dx, point.offset.dy);
      path.quadraticBezierTo(
        point.offset.dx + curvature * cos(angle),
        point.offset.dy - length / 2,
        point.offset.dx + curvature * cos(angle),
        point.offset.dy - length,
      );

      canvas.drawPath(path, paint);
    }
  },
);

final pixelBrush = BrushData(
  id: 18,
  name: 'pixel',
  stroke: 'pixel_stroke',
  densityOffset: 5.0,
  customPainter: (canvas, size, drawingPath) {
    final pixelSize = drawingPath.width.ceil();
    for (var i = 0; i < drawingPath.points.length - 1; i++) {
      final point = drawingPath.points[i];
      final paint = Paint()..color = drawingPath.color;

      final x = point.offset.dx - point.offset.dx % pixelSize;
      final y = point.offset.dy - point.offset.dy % pixelSize;

      if (i <= drawingPath.points.length - 1) {
        point.offset.calculateDensityOffset(
          drawingPath.points[i + 1].offset,
          pixelSize.toDouble(),
          (offset) {
            canvas.drawRect(
              Rect.fromLTWH(
                offset.dx - offset.dx % pixelSize,
                offset.dy - offset.dy % pixelSize,
                pixelSize.toDouble(),
                pixelSize.toDouble(),
              ),
              paint,
            );
          },
        );
      } else {
        canvas.drawRect(
          Rect.fromLTWH(x, y, pixelSize.toDouble(), pixelSize.toDouble()),
          paint,
        );
      }
    }
  },
);

final glowBrush = BrushData(
  id: 16,
  name: 'neonGlow',
  stroke: 'neon_glow_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
    final path = Path();
    path.moveTo(
        drawingPath.points.first.offset.dx, drawingPath.points.first.offset.dy);
    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1].offset;
      final p1 = drawingPath.points[i].offset;
      path.quadraticBezierTo(
        p0.dx,
        p0.dy,
        (p0.dx + p1.dx) / 2,
        (p0.dy + p1.dy) / 2,
      );
    }

    for (int i = 0; i < 3; i++) {
      final paint = Paint()
        ..color = drawingPath.color.withOpacity(0.3 - i * 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = drawingPath.width + i * 4
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, (i + 1) * 5.0);
      canvas.drawPath(path, paint);
    }

    // Draw the core of the neon line
    final corePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width * 0.7;
    canvas.drawPath(path, corePaint);
  },
);

final mosaicBrush = BrushData(
  id: 15,
  name: 'mosaic',
  stroke: 'mosaic_stroke',
  densityOffset: 10.0,
  customPainter: (canvas, size, drawingPath) {
    for (final point in drawingPath.points) {
      final size = drawingPath.width * 1.5;
      final rect = Rect.fromCenter(
        center: point.offset,
        width: size,
        height: size,
      );
      final paint = Paint()
        ..color = drawingPath.color.withOpacity(0.7)
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, paint);

      // Add inner details
      final innerPaint = Paint()
        ..color = drawingPath.color.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawLine(
        rect.topLeft + Offset(size * 0.2, size * 0.2),
        rect.bottomRight - Offset(size * 0.2, size * 0.2),
        innerPaint,
      );
      canvas.drawLine(
        rect.topRight + Offset(-size * 0.2, size * 0.2),
        rect.bottomLeft + Offset(size * 0.2, -size * 0.2),
        innerPaint,
      );
    }
  },
);

final splatBrush = BrushData(
  id: 17,
  name: 'splat',
  stroke: 'splat_stroke',
  densityOffset: 30.0,
  customPainter: (canvas, size, drawingPath) {
    for (final point in drawingPath.points) {
      final center = point.offset;
      final random = [
        drawingPath.getRandom([center.dx, center.dy, 1]),
        drawingPath.getRandom([center.dy, center.dx, 2]),
        drawingPath.getRandom([center.dx, center.dy, 3]),
        drawingPath.getRandom([center.dy, center.dx, 4]),
        drawingPath.getRandom([center.dx, center.dy, 5]),
      ];

      for (int i = 0; i < 5; i++) {
        final radius = drawingPath.width * (0.5 + random[i] * 1.5);
        final angle = random[i] * 2 * pi;
        final offset = Offset(cos(angle) * radius, sin(angle) * radius);
        final paint = Paint()
          ..color = drawingPath.color.withOpacity(0.3 + random[i] * 0.4)
          ..style = PaintingStyle.fill;

        final splatPath = Path()
          ..moveTo(center.dx + offset.dx, center.dy + offset.dy);

        for (int j = 0; j < 5; j++) {
          final controlAngle = angle + (j / 5) * 2 * pi;
          final controlRadius = radius * (0.8 + random[(i + j) % 5] * 0.4);
          final controlPoint = center +
              Offset(
                cos(controlAngle) * controlRadius,
                sin(controlAngle) * controlRadius,
              );
          splatPath.quadraticBezierTo(
            controlPoint.dx,
            controlPoint.dy,
            center.dx + cos(angle + ((j + 1) / 5) * 2 * pi) * radius,
            center.dy + sin(angle + ((j + 1) / 5) * 2 * pi) * radius,
          );
        }

        canvas.drawPath(splatPath, paint);
      }
    }
  },
);

final calligraphyBrush = BrushData(
  id: 19,
  name: 'calligraphy',
  stroke: 'calligraphy_stroke',
  densityOffset: 2.0,
  customPainter: (canvas, size, drawingPath) {
    final path = Path();
    path.moveTo(
        drawingPath.points.first.offset.dx, drawingPath.points.first.offset.dy);
    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1].offset;
      final p1 = drawingPath.points[i].offset;
      path.quadraticBezierTo(
        p0.dx,
        p0.dy,
        (p0.dx + p1.dx) / 2,
        (p0.dy + p1.dy) / 2,
      );
    }

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = ui.Gradient.linear(
        drawingPath.points.first.offset,
        drawingPath.points.last.offset,
        [drawingPath.color.withOpacity(0.5), drawingPath.color],
        [0, 1],
      );

    canvas.drawPath(path, paint);
  },
);

final electricBrush = BrushData(
  id: 20,
  name: 'electric',
  stroke: 'electric_stroke',
  densityOffset: 5.0,
  customPainter: (canvas, size, drawingPath) {
    for (int i = 1; i < drawingPath.points.length; i++) {
      final start = drawingPath.points[i - 1].offset;
      final end = drawingPath.points[i].offset;
      final random = [
        drawingPath.getRandom([i, start.dx, start.dy, 1]),
        drawingPath.getRandom([i, end.dx, end.dy, 2]),
      ];

      final path = Path()..moveTo(start.dx, start.dy);

      const numSegments = 5;
      for (int j = 1; j <= numSegments; j++) {
        final t = j / numSegments;
        final x = start.dx + (end.dx - start.dx) * t;
        final y = start.dy + (end.dy - start.dy) * t;
        final offset = Offset(
          (random[0] - 0.5) * drawingPath.width * 2,
          (random[1] - 0.5) * drawingPath.width * 2,
        );
        path.lineTo(x + offset.dx, y + offset.dy);
      }

      final paint = Paint()
        ..color = drawingPath.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = drawingPath.width * 0.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(path, paint);

      // Add glow effect
      final glowPaint = Paint()
        ..color = drawingPath.color.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = drawingPath.width * 1.5
        ..maskFilter =
            MaskFilter.blur(BlurStyle.normal, drawingPath.width * 0.5);

      canvas.drawPath(path, glowPaint);
    }
  },
);

final furBrush = BrushData(
  id: 21,
  name: 'fur',
  stroke: 'fur_stroke',
  densityOffset: 3.0,
  customPainter: (canvas, size, drawingPath) {
    final random = Random();
    for (var i = 0; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i];
      final offset = point.offset;
      final lengthRandom = drawingPath.getRandom([i, offset.dx, offset.dy, 1]);
      final angleRandom = drawingPath.getRandom([i, offset.dy, offset.dx, 2]);
      final colorRandom = drawingPath.getRandom([i, offset.dx, offset.dy, 3]);

      final furLength = drawingPath.width * (0.5 + lengthRandom);
      final furAngle = angleRandom * 2 * pi;
      final colorVariation = (colorRandom - 0.5) * 0.2;

      final endPoint = Offset(
        point.offset.dx + cos(furAngle) * furLength,
        point.offset.dy + sin(furAngle) * furLength,
      );

      final paint = Paint()
        ..color = drawingPath.color.withOpacity(0.6 + colorVariation)
        ..strokeWidth = drawingPath.width * 0.1
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(point.offset, endPoint, paint);
    }
  },
);

final galaxyBrush = BrushData(
  id: 22,
  name: 'galaxy',
  stroke: 'galaxy_stroke',
  densityOffset: 10.0,
  customPainter: (canvas, size, drawingPath) {
    for (final point in drawingPath.points) {
      final center = point.offset;

      // Create a radial gradient for the galaxy background
      final gradient = RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [
          drawingPath.color,
          drawingPath.color.withOpacity(0.7),
          drawingPath.color.withOpacity(0.3),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      );

      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromCircle(
          center: center,
          radius: drawingPath.width * 2,
        ));

      canvas.drawCircle(center, drawingPath.width * 2, paint);

      // Add stars
      for (int i = 0; i < 20; i++) {
        final randomOffset = List.generate(
          20,
          (j) => drawingPath.getRandom([i, center.dx, center.dy, j]),
        );

        final starOffset = Offset(
          center.dx + (randomOffset[i] - 0.5) * drawingPath.width * 4,
          center.dy +
              (randomOffset[(i + 1) % 20] - 0.5) * drawingPath.width * 4,
        );
        final starSize = drawingPath.width * 0.1 * randomOffset[(i + 2) % 20];
        final starOpacity = 0.5 + randomOffset[(i + 3) % 20] * 0.5;
        final starColor = HSLColor.fromColor(Colors.white)
            .withLightness(0.7 + randomOffset[(i + 4) % 20] * 0.3)
            .toColor();

        final starPaint = Paint()
          ..color = starColor.withOpacity(starOpacity)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(starOffset, starSize, starPaint);
      }
    }
  },
);

final fractalBrush = BrushData(
  id: 23,
  name: 'fractal',
  stroke: 'fractal_stroke',
  densityOffset: 20.0,
  customPainter: (canvas, size, drawingPath) {
    void drawFractal(Offset start, Offset end, int depth, double width) {
      if (depth == 0 || width < 0.5) {
        final paint = Paint()
          ..color = drawingPath.color.withOpacity(0.7)
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(start, end, paint);
        return;
      }

      final third = (end - start) / 3;
      final leftBranch = start + third;
      final rightBranch = end - third;

      final middleOffset = Offset(
        -third.dy * sqrt(3) / 2,
        third.dx * sqrt(3) / 2,
      );
      final middle = leftBranch + middleOffset;

      drawFractal(start, leftBranch, depth - 1, width * 0.8);
      drawFractal(leftBranch, middle, depth - 1, width * 0.8);
      drawFractal(middle, rightBranch, depth - 1, width * 0.8);
      drawFractal(rightBranch, end, depth - 1, width * 0.8);
    }

    for (int i = 1; i < drawingPath.points.length; i++) {
      final start = drawingPath.points[i - 1].offset;
      final end = drawingPath.points[i].offset;
      drawFractal(start, end, 4, drawingPath.width);
    }
  },
);

final fireBrush = BrushData(
  id: 23,
  name: 'fire',
  stroke: 'fire_stroke',
  densityOffset: 10.0,
  customPainter: (canvas, size, drawingPath) {
    for (var i = 0; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i];
      final offset = point.offset;

      final randomSize = drawingPath.getRandom([i, offset.dx, offset.dy, 1]);
      final randomAngle = drawingPath.getRandom([i, offset.dy, offset.dx, 2]);
      final randomOpacity = drawingPath.getRandom([i, offset.dx, offset.dy, 3]);
      final randomColorVariation =
          drawingPath.getRandom([i, offset.dy, offset.dx, 4]);

      final flameHeight = drawingPath.width * (1.0 + randomSize);
      final flameWidth = drawingPath.width * (0.5 + randomSize * 0.5);

      final paint = Paint()
        ..shader = ui.Gradient.linear(
          point.offset,
          point.offset.translate(0, -flameHeight),
          [
            Colors.red.withOpacity(0.0),
            Colors.orange.withOpacity(randomOpacity * 0.5 + 0.5),
            Colors.yellow.withOpacity(randomOpacity * 0.5 + 0.5),
          ],
          [0.0, 0.5, 1.0],
        )
        ..blendMode = BlendMode.screen;

      final path = Path();
      path.moveTo(point.offset.dx, point.offset.dy);
      path.quadraticBezierTo(
        point.offset.dx - flameWidth / 2,
        point.offset.dy - flameHeight / 2,
        point.offset.dx,
        point.offset.dy - flameHeight,
      );
      path.quadraticBezierTo(
        point.offset.dx + flameWidth / 2,
        point.offset.dy - flameHeight / 2,
        point.offset.dx,
        point.offset.dy,
      );
      path.close();

      canvas.save();
      canvas.translate(point.offset.dx, point.offset.dy);
      canvas.rotate((randomAngle - 0.5) * pi / 4);
      canvas.translate(-point.offset.dx, -point.offset.dy);
      canvas.drawPath(path, paint);
      canvas.restore();
    }
  },
);

// Snowflake Brush
final snowflakeBrush = BrushData(
  id: 24,
  name: 'snowflake',
  stroke: 'snowflake_stroke',
  densityOffset: 15.0,
  customPainter: (canvas, size, drawingPath) {
    for (var i = 0; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i];
      final offset = point.offset;

      final randomSize = drawingPath.getRandom([i, offset.dx, offset.dy, 1]);
      final randomRotation =
          drawingPath.getRandom([i, offset.dy, offset.dx, 2]);
      final randomOpacity = drawingPath.getRandom([i, offset.dx, offset.dy, 3]);

      final size = drawingPath.width * (0.5 + randomSize * 1.0);

      final paint = Paint()
        ..color = Colors.white.withOpacity(0.5 + randomOpacity * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.1;

      canvas.save();
      canvas.translate(point.offset.dx, point.offset.dy);
      canvas.rotate(randomRotation * 2 * pi);

      final path = Path();
      for (int i = 0; i < 6; i++) {
        final angle = i * pi / 3;
        final x = cos(angle) * size;
        final y = sin(angle) * size;
        path.moveTo(0, 0);
        path.lineTo(x, y);
        // Draw small branches
        final branchAngle1 = angle + pi / 12;
        final branchAngle2 = angle - pi / 12;
        final branchLength = size * 0.3;
        path.moveTo(x * 0.7, y * 0.7);
        path.lineTo(
          x * 0.7 + cos(branchAngle1) * branchLength,
          y * 0.7 + sin(branchAngle1) * branchLength,
        );
        path.moveTo(x * 0.7, y * 0.7);
        path.lineTo(
          x * 0.7 + cos(branchAngle2) * branchLength,
          y * 0.7 + sin(branchAngle2) * branchLength,
        );
      }

      canvas.drawPath(path, paint);
      canvas.restore();
    }
  },
);

// Cloud Brush
final cloudBrush = BrushData(
  id: 25,
  name: 'cloud',
  stroke: 'cloud_stroke',
  densityOffset: 5.0,
  customPainter: (canvas, size, drawingPath) {
    for (var i = 0; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i];
      final o = point.offset;

      final randomSize = drawingPath.getRandom([i, o.dx, o.dy, 1]);
      final randomOffsetX = drawingPath.getRandom([i, o.dy, o.dx, 2]);
      final randomOffsetY = drawingPath.getRandom([i, o.dx, o.dy, 3]);

      final size = drawingPath.width * (2.0 + randomSize * 2.0);

      final paint = Paint()
        ..color = Colors.white.withOpacity(0.5)
        ..style = PaintingStyle.fill;

      final offset = point.offset.translate(
        (randomOffsetX - 0.5) * size * 0.5,
        (randomOffsetY - 0.5) * size * 0.5,
      );

      canvas.drawCircle(offset, size * 0.3, paint);
      canvas.drawCircle(
        offset.translate(size * 0.2, -size * 0.1),
        size * 0.25,
        paint,
      );
      canvas.drawCircle(
        offset.translate(-size * 0.2, -size * 0.1),
        size * 0.25,
        paint,
      );
      canvas.drawCircle(
        offset.translate(0, -size * 0.2),
        size * 0.2,
        paint,
      );
    }
  },
);

// Lightning Brush
final lightningBrush = BrushData(
  id: 26,
  name: 'lightning',
  stroke: 'lightning_stroke',
  densityOffset: 25.0,
  customPainter: (canvas, size, drawingPath) {
    for (var i = 0; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i];
      final offset = point.offset;

      final randomLength = drawingPath.getRandom([i, offset.dx, offset.dy, 1]);
      final randomAngle = drawingPath.getRandom([i, offset.dy, offset.dx, 2]);
      final randomJaggedness =
          drawingPath.getRandom([i, offset.dx, offset.dy, 3]);

      final length = drawingPath.width * 5 * (0.5 + randomLength * 0.5);
      final angle = (randomAngle - 0.5) * pi / 3; // -60 to +60 degrees
      final jaggedness = (randomJaggedness) * length / 5;

      final paint = Paint()
        ..color = Colors.yellow.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = drawingPath.width * 0.2
        ..strokeCap = StrokeCap.round;

      final path = Path();
      path.moveTo(point.offset.dx, point.offset.dy);
      var currentPoint = point.offset;
      var currentAngle = angle;
      var remainingLength = length;

      while (remainingLength > 0) {
        final segmentLength = min(remainingLength, drawingPath.width * 2);
        final nextPoint = currentPoint.translate(
          cos(currentAngle) * segmentLength,
          sin(currentAngle) * segmentLength,
        );
        path.lineTo(nextPoint.dx, nextPoint.dy);

        currentAngle += (Random().nextDouble() - 0.5) * jaggedness;
        currentPoint = nextPoint;
        remainingLength -= segmentLength;
      }

      canvas.drawPath(path, paint);
    }
  },
);

// Feather Brush
final featherBrush = BrushData(
  id: 27,
  name: 'feather',
  stroke: 'feather_stroke',
  densityOffset: 15.0,
  customPainter: (canvas, size, drawingPath) {
    final random = Random();
    for (var i = 0; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i];
      final offset = point.offset;

      final randomSize = drawingPath.getRandom([i, offset.dx, offset.dy, 1]);
      final randomRotation =
          drawingPath.getRandom([i, offset.dy, offset.dx, 2]);
      final randomSkew = drawingPath.getRandom([i, offset.dx, offset.dy, 3]);

      final size = drawingPath.width * (1.5 + randomSize * 0.5);

      final paint = Paint()
        ..color = drawingPath.color.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(point.offset.dx, point.offset.dy);
      canvas.rotate((randomRotation - 0.5) * pi / 4);
      canvas.skew((randomSkew - 0.5) * 0.2, 0.0);

      final path = Path();
      path.moveTo(0, -size / 2);
      path.quadraticBezierTo(
        size / 4,
        -size / 4,
        size / 2,
        0,
      );
      path.quadraticBezierTo(
        size / 4,
        size / 4,
        0,
        size / 2,
      );
      path.quadraticBezierTo(
        -size / 4,
        size / 4,
        -size / 2,
        0,
      );
      path.quadraticBezierTo(
        -size / 4,
        -size / 4,
        0,
        -size / 2,
      );
      path.close();

      // Draw the central shaft
      final shaftPaint = Paint()
        ..color = Colors.white.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.05;

      final shaftPath = Path();
      shaftPath.moveTo(0, -size / 2);
      shaftPath.lineTo(0, size / 2);

      canvas.drawPath(path, paint);
      canvas.drawPath(shaftPath, shaftPaint);

      canvas.restore();
    }
  },
);

final galaxyBrush1 = BrushData(
  id: 28,
  name: 'galaxy',
  stroke: 'galaxy_stroke',
  densityOffset: 20.0,
  customPainter: (canvas, size, drawingPath) {
    for (var i = 0; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i];
      final sizeRandom = drawingPath.getRandom([i, drawingPath.width]);
      final opacityRandom = drawingPath.getRandom([i, drawingPath.width, 1]);
      final colorRandom = drawingPath.getRandom([i, drawingPath.width, 2]);

      final starSize = sizeRandom * drawingPath.width;
      final opacity = opacityRandom * 0.5 + 0.5;
      final colorShift = colorRandom * 360;

      final paint = Paint()
        ..color = HSVColor.fromAHSV(
          1.0,
          (colorShift + 240) % 360, // Shift hue towards blue/purple
          0.7,
          1.0,
        ).toColor().withOpacity(opacity)
        ..style = PaintingStyle.fill;

      // Draw a star
      final path = Path();
      const numPoints = 5;
      final outerRadius = starSize;
      final innerRadius = starSize / 2;
      for (int i = 0; i < numPoints * 2; i++) {
        final angle = i * pi / numPoints;
        final radius = i.isEven ? outerRadius : innerRadius;
        final x = point.offset.dx + radius * cos(angle);
        final y = point.offset.dy + radius * sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);

      // Add small dots to simulate distant stars
      for (int j = 0; j < 5; j++) {
        final dxRandom = drawingPath.getRandom([i, j, point.offset.dx]);
        final dyRandom = drawingPath.getRandom([i, j, point.offset.dy]);
        final dotSizeRandom = drawingPath.getRandom([i, j, starSize]);
        final colorRandom = drawingPath.getRandom([i, j, -1]);

        final offset = Offset(
          point.offset.dx + (dxRandom - 0.5) * drawingPath.width * 2,
          point.offset.dy + (dyRandom - 0.5) * drawingPath.width * 2,
        );
        final dotSize = dotSizeRandom * starSize * 0.2;
        final dotPaint = Paint()
          ..color = Colors.white.withOpacity(colorRandom * 0.5 + 0.5)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(offset, dotSize, dotPaint);
      }
    }
  },
);

// Confetti Brush
final confettiBrush = BrushData(
  id: 29,
  name: 'confetti',
  stroke: 'confetti_stroke',
  densityOffset: 10.0,
  customPainter: (canvas, size, drawingPath) {
    final random = Random();
    for (var i = 0; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i];
      final offset = point.offset;

      final random1 = drawingPath.getRandom([i, offset.dx, offset.dy, 1]);
      final random2 = drawingPath.getRandom([i, offset.dy, offset.dx, 2]);
      final random3 = drawingPath.getRandom([i, offset.dx, offset.dy, 3]);

      final size = drawingPath.width * (0.5 + random1);
      final rotation = random2 * 2 * pi;
      final hueShift = random3 * 360;

      final paint = Paint()
        ..color = HSVColor.fromAHSV(1.0, hueShift, 0.8, 1.0).toColor()
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(point.offset.dx, point.offset.dy);
      canvas.rotate(rotation);

      final rect =
          Rect.fromCenter(center: Offset.zero, width: size, height: size / 2);
      canvas.drawRect(rect, paint);
      canvas.restore();
    }
  },
);

// Metallic Brush
final metallicBrush = BrushData(
  id: 30,
  name: 'metallic',
  stroke: 'metallic_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
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

    final gradient = ui.Gradient.linear(
      Offset(0, 0),
      Offset(drawingPath.width, drawingPath.width),
      [Colors.grey.shade300, Colors.grey.shade800, Colors.grey.shade300],
      [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  },
);

// Embroidery Brush
final embroideryBrush = BrushData(
  id: 31,
  name: 'embroidery',
  stroke: 'embroidery_stroke',
  densityOffset: 5.0,
  customPainter: (canvas, size, drawingPath) {
    final path = Path();
    path.moveTo(
      drawingPath.points.first.offset.dx,
      drawingPath.points.first.offset.dy,
    );

    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1];
      final p1 = drawingPath.points[i];

      path.lineTo(p1.offset.dx, p1.offset.dy);
    }

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width * 1.5
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path, paint);

    // Add stitching effect
    for (int i = 0; i < drawingPath.points.length - 1; i++) {
      final p0 = drawingPath.points[i].offset;
      final p1 = drawingPath.points[i + 1].offset;

      final midPoint = Offset(
        (p0.dx + p1.dx) / 2,
        (p0.dy + p1.dy) / 2,
      );

      final stitchPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = drawingPath.width * 0.5;

      canvas.drawLine(p0, midPoint, stitchPaint);
      canvas.drawLine(midPoint, p1, stitchPaint);
    }
  },
);

// Stained Glass Brush
final stainedGlassBrush = BrushData(
  id: 32,
  name: 'stainedGlass',
  stroke: 'stained_glass_stroke',
  densityOffset: 20.0,
  customPainter: (canvas, size, drawingPath) {
    for (var i = 0; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i];
      final offset = point.offset;

      final random1 = drawingPath.getRandom([i, offset.dx, offset.dy, 1]);
      final random2 = drawingPath.getRandom([i, offset.dy, offset.dx, 2]);
      final random3 = drawingPath.getRandom([i, offset.dx, offset.dy, 3]);

      final hueShift = random1 * 360;
      final shapeType = random2;
      final rotation = random3 * 2 * pi;

      final paint = Paint()
        ..color = HSVColor.fromAHSV(1.0, hueShift, 0.7, 0.9)
            .toColor()
            .withOpacity(0.7)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(point.offset.dx, point.offset.dy);
      canvas.rotate(rotation);

      final size = drawingPath.width * 1.5;

      final path = Path();
      if (shapeType < 0.33) {
        // Triangle
        path.moveTo(0, -size / 2);
        path.lineTo(size / 2, size / 2);
        path.lineTo(-size / 2, size / 2);
      } else if (shapeType < 0.66) {
        // Rectangle
        path.addRect(
            Rect.fromCenter(center: Offset.zero, width: size, height: size));
      } else {
        // Circle
        path.addOval(Rect.fromCircle(center: Offset.zero, radius: size / 2));
      }
      path.close();

      // Simulate glass texture
      final glassPaint = Paint()
        ..shader = ui.Gradient.radial(
          Offset.zero,
          size / 2,
          [
            paint.color.withOpacity(0.8),
            paint.color.withOpacity(0.4),
            paint.color.withOpacity(0.1),
          ],
          [0.0, 0.7, 1.0],
        )
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, glassPaint);

      // Draw leading (the black lines between glass pieces)
      final leadingPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = drawingPath.width * 0.1;

      canvas.drawPath(path, leadingPaint);
      canvas.restore();
    }
  },
);

final ribbonBrush = BrushData(
  id: 24,
  name: 'ribbon',
  stroke: 'ribbon_stroke',
  densityOffset: 2.0,
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final path = Path();
    final shadowPath = Path();

    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1].offset;
      final p1 = drawingPath.points[i].offset;
      final random = drawingPath.getRandom([i, p0.dx, p0.dy, p1.dx, p1.dy, 0]);

      final perpendicular = (p1 - p0).dy != 0 || (p1 - p0).dx != 0
          ? Offset((p1 - p0).dy, -(p1 - p0).dx).normalized()
          : Offset.zero;

      final width = drawingPath.width * (0.5 + random * 0.5);
      final twist = sin(i * 0.2) * width * 2;

      final topEdge = p1 + perpendicular * (width + twist);
      final bottomEdge = p1 - perpendicular * (width - twist);

      if (i == 1) {
        path.moveTo(topEdge.dx, topEdge.dy);
        shadowPath.moveTo(bottomEdge.dx, bottomEdge.dy);
      }

      path.lineTo(topEdge.dx, topEdge.dy);
      shadowPath.lineTo(bottomEdge.dx, bottomEdge.dy);
    }

    for (int i = drawingPath.points.length - 1; i >= 1; i--) {
      final p0 = drawingPath.points[i].offset;
      final p1 = drawingPath.points[i - 1].offset;
      final random = drawingPath.getRandom([i, p0.dx, p0.dy, p1.dx, p1.dy, 1]);

      final perpendicular = (p1 - p0).dy != 0 || (p1 - p0).dx != 0
          ? Offset((p1 - p0).dy, -(p1 - p0).dx).normalized()
          : Offset.zero;

      final width = drawingPath.width * (0.5 + random * 0.5);
      final twist = sin(i * 0.2) * width * 2;

      final bottomEdge = p0 - perpendicular * (width - twist);
      path.lineTo(bottomEdge.dx, bottomEdge.dy);
    }

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = drawingPath.color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width * 0.5;

    canvas.drawPath(shadowPath, shadowPaint);
    canvas.drawPath(path, paint);
  },
);

final particleFieldBrush = BrushData(
  id: 25,
  name: 'particleField',
  stroke: 'particle_field_stroke',
  densityOffset: 10.0,
  customPainter: (canvas, size, drawingPath) {
    for (final point in drawingPath.points) {
      final center = point.offset;

      for (int i = 0; i < 50; i++) {
        final random = List.generate(
          50,
          (j) => drawingPath.getRandom([i, center.dx, center.dy, j]),
        );

        final radius = drawingPath.width * 2 * random[i];
        final angle = random[(i + 1) % 50] * 2 * pi;
        final particleOffset = Offset(
          center.dx + cos(angle) * radius,
          center.dy + sin(angle) * radius,
        );

        final particleSize = drawingPath.width * 0.2 * random[(i + 2) % 50];
        final particleOpacity = 0.1 + random[(i + 3) % 50] * 0.4;

        final particlePaint = Paint()
          ..color = drawingPath.color.withOpacity(particleOpacity)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(particleOffset, particleSize, particlePaint);
      }
    }
  },
);

final waveInterferenceBrush = BrushData(
  id: 26,
  name: 'waveInterference',
  stroke: 'wave_interference_stroke',
  densityOffset: 5.0,
  customPainter: (canvas, size, drawingPath) {
    final path = Path();
    path.moveTo(
        drawingPath.points.first.offset.dx, drawingPath.points.first.offset.dy);

    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1].offset;
      final p1 = drawingPath.points[i].offset;
      path.quadraticBezierTo(
        p0.dx,
        p0.dy,
        (p0.dx + p1.dx) / 2,
        (p0.dy + p1.dy) / 2,
      );
    }

    final pathMetrics = path.computeMetrics();
    final totalLength =
        pathMetrics.fold<double>(0, (prev, curr) => prev + curr.length);

    for (final metric in pathMetrics) {
      for (double distance = 0; distance <= metric.length; distance += 2) {
        final pos = metric.getTangentForOffset(distance)!.position;
        final progress = (metric.length - distance) / totalLength;

        final waveHeight = drawingPath.width * sin(progress * 10) * 0.5;
        final perpendicular =
            metric.getTangentForOffset(distance)!.vector.dy != 0 ||
                    metric.getTangentForOffset(distance)!.vector.dx != 0
                ? Offset(
                    metric.getTangentForOffset(distance)!.vector.dy,
                    -metric.getTangentForOffset(distance)!.vector.dx,
                  ).normalized()
                : Offset.zero;

        final wavePos = pos + perpendicular * waveHeight;

        final wavePaint = Paint()
          ..color = drawingPath.color.withOpacity(0.1 + progress * 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = drawingPath.width * 0.2;

        canvas.drawCircle(wavePos, drawingPath.width * 0.1, wavePaint);
      }
    }
  },
);

final voronoiBrush = BrushData(
  id: 27,
  name: 'voronoi',
  stroke: 'voronoi_stroke',
  densityOffset: 20.0,
  customPainter: (canvas, size, drawingPath) {
    final cellPoints = <Offset>[];
    final cellColors = <Color>[];

    for (var i = 0; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i];

      final center = point.offset;
      final random = List.generate(20, (j) => drawingPath.getRandom([i, j]));

      for (int i = 0; i < 10; i++) {
        final cellOffset = Offset(
          center.dx + (random[i * 2] - 0.5) * drawingPath.width * 4,
          center.dy + (random[i * 2 + 1] - 0.5) * drawingPath.width * 4,
        );
        cellPoints.add(cellOffset);

        final cellColor = drawingPath.color.withOpacity(0.1 + random[i] * 0.4);
        cellColors.add(cellColor);
      }
    }

    final rect = Rect.fromPoints(
      drawingPath.points.first.offset,
      drawingPath.points.last.offset,
    ).inflate(drawingPath.width * 2);

    for (double y = rect.top; y < rect.bottom; y += 2) {
      for (double x = rect.left; x < rect.right; x += 2) {
        final point = Offset(x, y);
        var minDist = double.infinity;
        var closestIndex = 0;

        for (int i = 0; i < cellPoints.length; i++) {
          final dist = (point - cellPoints[i]).distance;
          if (dist < minDist) {
            minDist = dist;
            closestIndex = i;
          }
        }

        final paint = Paint()
          ..color = cellColors[closestIndex]
          ..style = PaintingStyle.fill;

        canvas.drawCircle(point, 1, paint);
      }
    }
  },
);

final chaosTheoryBrush = BrushData(
  id: 28,
  name: 'chaosTheory',
  stroke: 'chaos_theory_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final points = <Offset>[];
    double x = drawingPath.points.first.offset.dx;
    double y = drawingPath.points.first.offset.dy;

    final a = 10.0;
    final b = 28.0;
    final c = 8.0 / 3.0;
    final dt = 0.01;

    for (int i = 0; i < 1000; i++) {
      final dx = a * (y - x) * dt;
      final dy = (x * (b - y) - y) * dt;
      final dz = (x * y - c * y) * dt;

      x += dx;
      y += dy;

      points.add(Offset(x, y));
    }

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width * 0.2;

    final scale = drawingPath.width * 0.1;
    final translate = drawingPath.points.last.offset;

    canvas.save();
    canvas.translate(translate.dx, translate.dy);
    canvas.scale(scale);
    canvas.drawPath(path, paint);
    canvas.restore();
  },
);

final inkBrush = BrushData(
  id: 33,
  name: 'ink',
  stroke: 'ink_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final mainPath = Path();
    mainPath.moveTo(
        drawingPath.points.first.offset.dx, drawingPath.points.first.offset.dy);

    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1].offset;
      final p1 = drawingPath.points[i].offset;
      final mid = (p0 + p1) / 2;
      mainPath.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(mainPath, paint);

    // Add ink splatters
    for (var i = 0; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i];
      final offset = point.offset;
      final random0 = drawingPath.getRandom([i, offset.dx, offset.dy, 0]);
      final random1 = drawingPath.getRandom([i, offset.dx, offset.dy, 1]);
      final random2 = drawingPath.getRandom([i, offset.dy, offset.dx, 2]);
      if (random0 < 0.1) {
        // 10% chance of splatter at each point
        final splatterPath = Path();
        final splatterCenter = point.offset;
        for (int i = 0; i < 5; i++) {
          final angle = random1 * 2 * pi;
          final distance = random2 * drawingPath.width * 2;
          final splatterPoint = splatterCenter +
              Offset(cos(angle) * distance, sin(angle) * distance);
          if (i == 0) {
            splatterPath.moveTo(splatterPoint.dx, splatterPoint.dy);
          } else {
            splatterPath.lineTo(splatterPoint.dx, splatterPoint.dy);
          }
        }
        splatterPath.close();

        final splatterPaint = Paint()
          ..color = drawingPath.color.withOpacity(0.3)
          ..style = PaintingStyle.fill;
        canvas.drawPath(splatterPath, splatterPaint);
      }
    }
  },
);

// Fireworks Brush
final fireworksBrush = BrushData(
  id: 34,
  name: 'fireworks',
  stroke: 'fireworks_stroke',
  densityOffset: 30.0,
  customPainter: (canvas, size, drawingPath) {
    for (var i = 0; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i];
      final offset = point.offset;
      final center = point.offset;
      final random = List.generate(
        100,
        (j) => drawingPath.getRandom([i, offset.dx, offset.dy, j]),
      );

      for (int i = 0; i < 50; i++) {
        final angle = random[i * 2] * 2 * pi;
        final distance = random[i * 2 + 1] * drawingPath.width * 3;
        final velocity = Offset(cos(angle) * distance, sin(angle) * distance);
        final endPoint = center + velocity;

        final paint = Paint()
          ..color = HSLColor.fromColor(drawingPath.color)
              .withLightness((0.5 + random[i] * 0.5) *
                  HSLColor.fromColor(drawingPath.color).lightness)
              .toColor()
              .withOpacity(1 - distance / (drawingPath.width * 3))
          ..strokeWidth = drawingPath.width * 0.1
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(center, endPoint, paint);
      }

      // Add a bright center
      final centerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, drawingPath.width * 0.5, centerPaint);
    }
  },
);

final glassBrush = BrushData(
  id: 35,
  name: 'glass',
  stroke: 'glass_stroke',
  densityOffset: 5.0,
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final path = Path();
    path.moveTo(
        drawingPath.points.first.offset.dx, drawingPath.points.first.offset.dy);

    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1].offset;
      final p1 = drawingPath.points[i].offset;
      final mid = (p0 + p1) / 2;
      path.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }

    final paint = Paint()
      ..color = drawingPath.color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);

    // Add glass reflections
    for (int i = 1; i < drawingPath.points.length; i += 2) {
      final point = drawingPath.points[i].offset;
      final random = List.generate(
        6,
        (j) => drawingPath.getRandom([i, point.dx, point.dy, j]),
      );

      final reflectionPath = Path();
      reflectionPath.moveTo(point.dx, point.dy);

      for (int j = 0; j < 3; j++) {
        final controlPoint1 = point +
            Offset(
              random[j * 2] * drawingPath.width,
              random[j * 2 + 1] * drawingPath.width,
            );
        final controlPoint2 = point +
            Offset(
              random[j * 2 + 1] * drawingPath.width,
              -random[j * 2] * drawingPath.width,
            );
        final endPoint = point +
            Offset(
              (random[j * 2] + random[j * 2 + 1]) * drawingPath.width * 0.5,
              0,
            );

        reflectionPath.cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          endPoint.dx,
          endPoint.dy,
        );
      }

      final reflectionPaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = drawingPath.width * 0.3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(reflectionPath, reflectionPaint);
    }
  },
);

final embossBrush = BrushData(
  id: 37,
  name: 'emboss',
  stroke: 'emboss_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
    final path = Path();
    path.moveTo(
      drawingPath.points.first.offset.dx,
      drawingPath.points.first.offset.dy,
    );

    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1].offset;
      final p1 = drawingPath.points[i].offset;
      path.quadraticBezierTo(
        p0.dx,
        p0.dy,
        (p0.dx + p1.dx) / 2,
        (p0.dy + p1.dy) / 2,
      );
    }

    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

    canvas.save();
    canvas.translate(2, 2); // Offset for shadow
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // Draw highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width
      ..blendMode = BlendMode.srcOver;

    canvas.save();
    canvas.translate(-2, -2); // Offset for highlight
    canvas.drawPath(path, highlightPaint);
    canvas.restore();

    // Draw the main path
    final mainPaint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, mainPaint);
  },
);
