import 'dart:ui' as ui;
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/const.dart';
import '../../config/assets.dart';
import '../../data.dart';
import '../extensions/offset_extensions.dart';
import 'pencil_effect.dart';
import 'shader_manager.dart';

final _random = Random();

Future<ui.Image?> _resizeImage(ui.Image image, int width, int height) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawImageRect(
    image,
    Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    Paint(),
  );

  final picture = recorder.endRecording();
  final img = await picture.toImage(width, height);
  return img.toByteData(format: ui.ImageByteFormat.png).then((byteData) {
    final buffer = byteData!.buffer.asUint8List();
    return ui
        .instantiateImageCodec(buffer)
        .then((codec) => codec.getNextFrame())
        .then((frame) => frame.image);
  });
}

Future<ui.Image?> _loadUIImage(String asset) async {
  final data = await rootBundle.load(asset);
  final bytes = data.buffer.asUint8List();
  final codec = await ui.instantiateImageCodec(bytes);
  final fi = await codec.getNextFrame();

  return _resizeImage(fi.image, 64, 64);
}

Future<BrushData> get pencil async => BrushData(
      id: 1,
      name: 'pencil',
      stroke: 'pencil_stroke',
      opacityDiff: 0.2,
      isNew: true,
      isLocked: true,
      densityOffset: 3.0,
      strokeJoin: ui.StrokeJoin.bevel,
      random: [-1, 1],
      sizeRandom: [-3, 3],
      useBrushWidthDensity: false,
      brush: await _loadUIImage(Assets.images.stampPencil),
    );

final softPencilBrush = BrushData(
  id: 2,
  name: 'soft pencil',
  stroke: 'soft_pencil_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final paint = Paint()
      ..color = drawingPath.color.withOpacity(0.2)
      ..strokeWidth = drawingPath.width * 0.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final position = metric.getTangentForOffset(distance)!.position;

      for (int j = 0; j < 3; j++) {
        final random1 = _random.nextDouble();
        final random2 = _random.nextDouble();
        final random3 = _random.nextDouble();

        final offset = Offset(
          (random1 - 0.5) * drawingPath.width,
          (random2 - 0.5) * drawingPath.width,
        );

        canvas.drawLine(
          position + offset,
          position + offset + Offset(random3 - 0.5, random3 - 0.5),
          paint,
        );
      }

      distance += drawingPath.width * 0.5;
    }
  },
);

final hardPencilBrush = BrushData(
  id: 3,
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
      final p1 = drawingPath.points[i];
      final p2 = drawingPath.points[i + 1];
      canvas.drawLine(p1, p2, paint);
    }
  },
);

final sketchyPencilBrush = BrushData(
  id: 4,
  name: 'sketchy pencil',
  stroke: 'sketchy_pencil_stroke',
  densityOffset: 2.0,
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color.withOpacity(0.2)
      ..strokeWidth = drawingPath.width * 0.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final position = metric.getTangentForOffset(distance)!.position;

      for (int j = 0; j < 4; j++) {
        final random1 = _random.nextDouble();
        final random2 = _random.nextDouble();
        final random3 = _random.nextDouble();
        final random4 = _random.nextDouble();

        // Calculate random offsets centered around zero
        final offset1 = Offset(
          (random1 - 0.5) * drawingPath.width * 0.5,
          (random2 - 0.5) * drawingPath.width * 0.5,
        );

        final controlPoint = position + offset1;

        // Random end point offset
        final endPoint = position +
            Offset(
              (random3 - 0.5) * 10.0,
              (random4 - 0.5) * 10.0,
            );

        canvas.drawLine(controlPoint, endPoint, paint);
      }

      distance += drawingPath.width * 0.5;
    }
  },
);

final coloredPencilBrush = BrushData(
  id: 5,
  name: 'colored pencil',
  stroke: 'colored_pencil_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color.withOpacity(0.5)
      ..strokeWidth = drawingPath.width * 0.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    Offset? prevPosition;
    while (distance < length) {
      final position = metric.getTangentForOffset(distance)!.position;
      if (prevPosition != null) {
        final p1 = prevPosition;
        final p2 = position;

        canvas.drawLine(p1, p2, paint);

        final perpendicular = Offset(p2.dy - p1.dy, p1.dx - p2.dx).normalized();
        for (int j = 0; j < 3; j++) {
          final offset = perpendicular * (j - 1) * drawingPath.width * 0.2;
          canvas.drawLine(
            p1 + offset,
            p2 + offset,
            paint..color = drawingPath.color.withOpacity(0.3),
          );
        }
      }

      prevPosition = position;

      distance += drawingPath.width * 0.5;
    }
  },
);

const defaultBrush = BrushData(
  id: 6,
  name: 'Default',
  stroke: 'brush_stroke',
  densityOffset: 1.0,
  strokeCap: ui.StrokeCap.round,
);

Future<BrushData> get marker async => BrushData(
      id: 7,
      name: 'marker',
      stroke: 'marker_stroke',
      isNew: true,
      opacityDiff: 0.7,
      strokeCap: ui.StrokeCap.square,
      strokeJoin: ui.StrokeJoin.bevel,
      isLocked: true,
      densityOffset: 1.0,
      useBrushWidthDensity: false,
      brush: await _loadUIImage(Assets.images.brush2),
    );

final watercolor = BrushData(
  id: 8,
  name: 'watercolor',
  stroke: 'watercolor_stroke',
  densityOffset: 2.0,
  opacityDiff: 0.5,
  sizeRandom: [-20, 20],
  useBrushWidthDensity: false,
  customPainter: (canvas, size, drawingPath) async {
    final path = drawingPath.createPath();

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
  id: 9,
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
  id: 10,
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

    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    Offset? prevPosition;

    var distance = 0.0;
    while (distance < length) {
      final position = metric.getTangentForOffset(distance)!.position;

      if (prevPosition != null) {
        for (int j = 0; j < 3; j++) {
          final x = _random.nextDouble();
          final y = _random.nextDouble();
          final w = _random.nextDouble();

          final offset = Offset(
            (x - 0.5) * drawingPath.width * 0.3,
            (y - 0.5) * drawingPath.width * 0.3,
          );

          canvas.drawLine(
            prevPosition + offset,
            position + offset,
            paint..strokeWidth = drawingPath.width * (0.8 + w * 0.4),
          );
        }
      }

      prevPosition = position;
      distance += drawingPath.width * 0.5;
    }
  },
);

final sprayPaint = BrushData(
  id: 11,
  name: 'sprayPaint',
  stroke: 'spray_paint_stroke',
  opacityDiff: 0.2,
  densityOffset: 5.0,
  random: [-5, 5],
  sizeRandom: [-5, 5],
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final position = metric.getTangentForOffset(distance)!.position;
      for (int i = 0; i < 20; i++) {
        final dx =
            position.dx + (_random.nextDouble() - 0.5) * drawingPath.width * 4;
        final dy =
            position.dy + (_random.nextDouble() - 0.5) * drawingPath.width * 4;
        final radius = _random.nextDouble() * 1.5;
        canvas.drawCircle(Offset(dx, dy), radius, paint);
      }

      distance += drawingPath.width * 1;
    }
  },
);

const neon = BrushData(
  id: 12,
  name: 'neon',
  stroke: 'neon_stroke',
  opacityDiff: 0.1,
  densityOffset: 1,
  strokeCap: ui.StrokeCap.round,
  strokeJoin: ui.StrokeJoin.round,
  blendMode: ui.BlendMode.screen,
);

final charcoal = BrushData(
  id: 13,
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

    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final position = metric.getTangentForOffset(distance)!.position;

      final random1 = _random.nextDouble();
      final random2 = _random.nextDouble();

      // Add random offsets to create a rough, smudged effect
      final controlPoint = Offset(
        position.dx + (random1 - 0.5) * drawingPath.width * 0.5,
        position.dy + (random2 - 0.5) * drawingPath.width * 0.5,
      );

      canvas.drawLine(position, controlPoint, paint);

      distance += drawingPath.width * 0.5;
    }
  },
);

final sketchy = BrushData(
  id: 14,
  name: 'sketchy',
  stroke: 'sketchy_stroke',
  densityOffset: 30,
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    for (int j = 0; j < 3; j++) {
      final random1 = _random.nextDouble();
      final random2 = _random.nextDouble();
      final random3 = _random.nextDouble();

      paint.strokeWidth = drawingPath.width * (0.5 + random1 * 0.5);

      var distance = 0.0;
      while (distance < length) {
        final position = metric.getTangentForOffset(distance)!.position;

        final random4 = _random.nextDouble();
        final random5 = _random.nextDouble();
        final random6 = _random.nextDouble();

        final controlPoint = Offset(
          position.dx + (random2 - 0.5) * drawingPath.width * 0.5,
          position.dy + (random3 - 0.5) * drawingPath.width * 0.5,
        );

        final endPoint = Offset(
          position.dx + (random4 - 0.5) * drawingPath.width * 0.5,
          position.dy + (random5 - 0.5) * drawingPath.width * 0.5,
        );

        canvas.drawLine(position, controlPoint, paint);

        paint.strokeWidth = drawingPath.width * (0.3 + random6 * 0.2);
        canvas.drawLine(controlPoint, endPoint, paint);

        distance += drawingPath.width * 0.5;
      }
    }
  },
);

final star = BrushData(
  id: 15,
  name: 'star',
  stroke: 'star_stroke',
  densityOffset: 20,
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.fill;

    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final position = metric.getTangentForOffset(distance)!.position;

      final starPath = Path();
      final center = position;
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

      distance += drawingPath.width * 2;
    }
  },
);

final heart = BrushData(
  id: 16,
  name: 'heart',
  stroke: 'heart_stroke',
  densityOffset: 10,
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.fill;

    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final position = metric.getTangentForOffset(distance)!.position;

      final center = position;
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

      distance += drawingPath.width * 2;
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
  id: 17,
  name: 'bubble',
  stroke: 'bubble_stroke',
  densityOffset: 20,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final position = metric.getTangentForOffset(distance)!.position;

      final random1 = _random.nextDouble();
      final random2 = _random.nextDouble();
      final random3 = _random.nextDouble();

      final paint = Paint()
        ..color = drawingPath.color.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      final bubbleRadius =
          (drawingPath.width / 2) + random1 * (drawingPath.width);

      canvas.drawCircle(
        position + Offset(random2 * 10 - 5, random3 * 10 - 5),
        bubbleRadius,
        paint,
      );

      distance += drawingPath.width * 10;
    }
  },
);

final glitterBrush = BrushData(
  id: 18,
  name: 'glitter',
  stroke: 'glitter_stroke',
  densityOffset: 20,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final offset = metric.getTangentForOffset(distance)!.position;

      final random1 = _random.nextDouble();
      final random2 = _random.nextDouble();
      final random3 = _random.nextDouble();
      final random4 = _random.nextDouble();

      final paint = Paint()
        ..color = drawingPath.color.withOpacity(random1)
        ..style = PaintingStyle.fill;

      final glitterSize = random2 * drawingPath.width / 2;

      canvas.drawCircle(
        offset +
            Offset(
              random3 * 10 - 5,
              random4 * 10 - 5,
            ),
        glitterSize,
        paint,
      );

      distance += drawingPath.width * 2;
    }
  },
);

final rainbowBrush = BrushData(
  id: 19,
  name: 'rainbow',
  stroke: 'rainbow_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();

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
  id: 20,
  name: 'sparkle',
  stroke: 'sparkle_stroke',
  densityOffset: 5.0,
  customPainter: (canvas, size, drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = drawingPath.width
      ..style = PaintingStyle.fill;

    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;

      final randomSize = _random.nextDouble();
      final randomRotation = _random.nextDouble();
      final randomOpacity = _random.nextDouble();

      paint.color = drawingPath.color.withOpacity(0.5 + randomOpacity * 0.5);

      final size = drawingPath.width * (0.5 + randomSize * 0.5);

      canvas.save();
      canvas.translate(point.dx, point.dy);
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

      distance += drawingPath.width * 2;
    }
  },
);

final leafBrush = BrushData(
  id: 21,
  name: 'leaf',
  stroke: 'leaf_stroke',
  densityOffset: 15.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;

      final randomSize = _random.nextDouble();
      final randomRotation = _random.nextDouble();
      final randomColorVariation = _random.nextDouble();
      final randomSkew = _random.nextDouble();

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
      canvas.translate(point.dx, point.dy);
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

      distance += drawingPath.width * 2;
    }
  },
);

final grassBrush = BrushData(
  id: 22,
  name: 'grass',
  stroke: 'grass_stroke',
  densityOffset: 8.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;

      final randomLength = _random.nextDouble();
      final randomAngle = _random.nextDouble();
      final randomCurvature = _random.nextDouble();
      final randomColorVariation = _random.nextDouble();

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
      path.moveTo(point.dx, point.dy);
      path.quadraticBezierTo(
        point.dx + curvature * cos(angle),
        point.dy - length / 2,
        point.dx + curvature * cos(angle),
        point.dy - length,
      );

      canvas.drawPath(path, paint);

      distance += drawingPath.width * 1;
    }
  },
);

final pixelBrush = BrushData(
  id: 23,
  name: 'pixel',
  stroke: 'pixel_stroke',
  densityOffset: 5.0,
  customPainter: (canvas, size, drawingPath) {
    final pixelSize = drawingPath.width.ceil();
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    Offset? prevPoint;
    final step = pixelSize / 2;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;

      final paint = Paint()..color = drawingPath.color;

      final x = point.dx - point.dx % pixelSize;
      final y = point.dy - point.dy % pixelSize;

      if (prevPoint != null) {
        Offset(x, y).calculateDensityOffset(
          prevPoint,
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

      prevPoint = point;
      distance += step;
    }
  },
);

final glowBrush = BrushData(
  id: 24,
  name: 'neonGlow',
  stroke: 'neon_glow_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();

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
  id: 25,
  name: 'mosaic',
  stroke: 'mosaic_stroke',
  densityOffset: 10.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;

      final size = drawingPath.width * 1.5;
      final rect = Rect.fromCenter(
        center: point,
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

      distance += drawingPath.width * 0.75;
    }
  },
);

final splatBrush = BrushData(
  id: 26,
  name: 'splat',
  stroke: 'splat_stroke',
  densityOffset: 30.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;
      final center = point;

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

      distance += drawingPath.width * 2;
    }
  },
);

final calligraphyBrush = BrushData(
  id: 27,
  name: 'calligraphy',
  stroke: 'calligraphy_stroke',
  densityOffset: 2.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();

    final paint = Paint()
      ..color = drawingPath.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawingPath.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = ui.Gradient.linear(
        drawingPath.points.first,
        drawingPath.points.last,
        [drawingPath.color.withOpacity(0.5), drawingPath.color],
        [0, 1],
      );

    canvas.drawPath(path, paint);
  },
);

final electricBrush = BrushData(
  id: 28,
  name: 'electric',
  stroke: 'electric_stroke',
  densityOffset: 5.0,
  customPainter: (canvas, size, drawingPath) {},
);

final furBrush = BrushData(
  id: 29,
  name: 'fur',
  stroke: 'fur_stroke',
  densityOffset: 3.0,
  customPainter: (canvas, size, drawingPath) {},
);

final galaxyBrush = BrushData(
  id: 30,
  name: 'galaxy',
  stroke: 'galaxy_stroke',
  densityOffset: 10.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;

      final center = point;

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

      distance += drawingPath.width * 2;
    }
  },
);

final fractalBrush = BrushData(
  id: 31,
  name: 'fractal',
  stroke: 'fractal_stroke',
  densityOffset: 20.0,
  customPainter: (canvas, size, drawingPath) {},
);

final fireBrush = BrushData(
  id: 32,
  name: 'fire',
  stroke: 'fire_stroke',
  densityOffset: 10.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;

      final randomSize = _random.nextDouble();
      final randomAngle = _random.nextDouble();
      final randomOpacity = _random.nextDouble();
      final randomColorVariation = _random.nextDouble();

      final flameHeight = drawingPath.width * (1.0 + randomSize);
      final flameWidth = drawingPath.width * (0.5 + randomSize * 0.5);

      final paint = Paint()
        ..shader = ui.Gradient.linear(
          point,
          point.translate(0, -flameHeight),
          [
            Colors.red.withOpacity(0.0),
            Colors.orange.withOpacity(randomOpacity * 0.5 + 0.5),
            Colors.yellow.withOpacity(randomOpacity * 0.5 + 0.5),
          ],
          [0.0, 0.5, 1.0],
        )
        ..blendMode = BlendMode.screen;

      final path = Path();
      path.moveTo(point.dx, point.dy);
      path.quadraticBezierTo(
        point.dx - flameWidth / 2,
        point.dy - flameHeight / 2,
        point.dx,
        point.dy - flameHeight,
      );
      path.quadraticBezierTo(
        point.dx + flameWidth / 2,
        point.dy - flameHeight / 2,
        point.dx,
        point.dy,
      );
      path.close();

      canvas.save();
      canvas.translate(point.dx, point.dy);
      canvas.rotate((randomAngle - 0.5) * pi / 4);
      canvas.translate(-point.dx, -point.dy);
      canvas.drawPath(path, paint);
      canvas.restore();

      distance += drawingPath.width * 0.5;
    }
  },
);

// Snowflake Brush
final snowflakeBrush = BrushData(
  id: 33,
  name: 'snowflake',
  stroke: 'snowflake_stroke',
  densityOffset: 15.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;

      final randomSize = _random.nextDouble();
      final randomRotation = _random.nextDouble();
      final randomOpacity = _random.nextDouble();

      final size = drawingPath.width * (0.5 + randomSize * 1.0);

      final paint = Paint()
        ..color = Colors.white.withOpacity(0.5 + randomOpacity * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.1;

      canvas.save();
      canvas.translate(point.dx, point.dy);
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

      distance += drawingPath.width * 2;
    }
  },
);

// Cloud Brush
final cloudBrush = BrushData(
  id: 35,
  name: 'cloud',
  stroke: 'cloud_stroke',
  densityOffset: 5.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;

      final randomSize = _random.nextDouble();
      final randomOffsetX = _random.nextDouble();
      final randomOffsetY = _random.nextDouble();

      final size = drawingPath.width * (2.0 + randomSize * 2.0);

      final paint = Paint()
        ..color = Colors.white.withOpacity(0.5)
        ..style = PaintingStyle.fill;

      final offset = point.translate(
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

      distance += drawingPath.width * 2;
    }
  },
);

// Lightning Brush
final lightningBrush = BrushData(
  id: 36,
  name: 'lightning',
  stroke: 'lightning_stroke',
  densityOffset: 25.0,
  customPainter: (canvas, size, drawingPath) {},
);

// Feather Brush
final featherBrush = BrushData(
  id: 37,
  name: 'feather',
  stroke: 'feather_stroke',
  densityOffset: 15.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;

      final randomSize = _random.nextDouble();
      final randomRotation = _random.nextDouble();
      final randomSkew = _random.nextDouble();

      final size = drawingPath.width * (1.5 + randomSize * 0.5);

      final paint = Paint()
        ..color = drawingPath.color.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(point.dx, point.dy);
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

      distance += drawingPath.width * 2;
    }
  },
);

final galaxyBrush1 = BrushData(
  id: 38,
  name: 'galaxy',
  stroke: 'galaxy_stroke',
  densityOffset: 20.0,
  customPainter: (canvas, size, drawingPath) {},
);

// Confetti Brush
final confettiBrush = BrushData(
  id: 39,
  name: 'confetti',
  stroke: 'confetti_stroke',
  densityOffset: 10.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;

      final random1 = _random.nextDouble();
      final random2 = _random.nextDouble();
      final random3 = _random.nextDouble();

      final size = drawingPath.width * (0.5 + random1);
      final rotation = random2 * 2 * pi;
      final hueShift = random3 * 360;

      final paint = Paint()
        ..color = HSVColor.fromAHSV(1.0, hueShift, 0.8, 1.0).toColor()
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(point.dx, point.dy);
      canvas.rotate(rotation);

      final rect =
          Rect.fromCenter(center: Offset.zero, width: size, height: size / 2);
      canvas.drawRect(rect, paint);
      canvas.restore();

      distance += drawingPath.width * 2;
    }
  },
);

// Metallic Brush
final metallicBrush = BrushData(
  id: 40,
  name: 'metallic',
  stroke: 'metallic_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();

    final gradient = ui.Gradient.linear(
      const Offset(0, 0),
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
  id: 41,
  name: 'embroidery',
  stroke: 'embroidery_stroke',
  densityOffset: 5.0,
  customPainter: (canvas, size, drawingPath) {},
);

// Stained Glass Brush
final stainedGlassBrush = BrushData(
  id: 42,
  name: 'stainedGlass',
  stroke: 'stained_glass_stroke',
  densityOffset: 20.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;

      final random1 = _random.nextDouble();
      final random2 = _random.nextDouble();
      final random3 = _random.nextDouble();

      final hueShift = random1 * 360;
      final shapeType = random2;
      final rotation = random3 * 2 * pi;

      final paint = Paint()
        ..color = HSVColor.fromAHSV(1.0, hueShift, 0.7, 0.9)
            .toColor()
            .withOpacity(0.7)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(point.dx, point.dy);
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

      distance += drawingPath.width * 2;
    }
  },
);

final ribbonBrush = BrushData(
  id: 43,
  name: 'ribbon',
  stroke: 'ribbon_stroke',
  densityOffset: 2.0,
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final path = Path();
    final shadowPath = Path();

    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1];
      final p1 = drawingPath.points[i];
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
      final p0 = drawingPath.points[i];
      final p1 = drawingPath.points[i - 1];
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
  id: 44,
  name: 'particleField',
  stroke: 'particle_field_stroke',
  densityOffset: 10.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;
      final center = point;

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

      distance += drawingPath.width * 2;
    }
  },
);

final waveInterferenceBrush = BrushData(
  id: 45,
  name: 'waveInterference',
  stroke: 'wave_interference_stroke',
  densityOffset: 5.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();

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
  id: 46,
  name: 'voronoi',
  stroke: 'voronoi_stroke',
  densityOffset: 20.0,
  customPainter: (canvas, size, drawingPath) {
    final cellPoints = <Offset>[];
    final cellColors = <Color>[];

    for (var i = 0; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i];

      final center = point;
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
      drawingPath.points.first,
      drawingPath.points.last,
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
  id: 47,
  name: 'chaosTheory',
  stroke: 'chaos_theory_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
    if (drawingPath.points.length < 2) return;

    final points = <Offset>[];
    double x = drawingPath.points.first.dx;
    double y = drawingPath.points.first.dy;

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
    final translate = drawingPath.points.last;

    canvas.save();
    canvas.translate(translate.dx, translate.dy);
    canvas.scale(scale);
    canvas.drawPath(path, paint);
    canvas.restore();
  },
);

final inkBrush = BrushData(
  id: 48,
  name: 'ink',
  stroke: 'ink_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {},
);

// Fireworks Brush
final fireworksBrush = BrushData(
  id: 49,
  name: 'fireworks',
  stroke: 'fireworks_stroke',
  densityOffset: 30.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();
    final metrics = path.computeMetrics();

    final metric = metrics.firstOrNull;
    if (metric == null) return;
    final length = metric.length;

    var distance = 0.0;
    while (distance < length) {
      final point = metric.getTangentForOffset(distance)!.position;
      final offset = point;
      final center = point;
      final random = List.generate(
        100,
        (j) => _random.nextDouble(),
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

      distance += drawingPath.width * 2;
    }
  },
);

final glassBrush = BrushData(
  id: 50,
  name: 'glass',
  stroke: 'glass_stroke',
  densityOffset: 5.0,
  customPainter: (canvas, size, drawingPath) {},
);

final embossBrush = BrushData(
  id: 51,
  name: 'emboss',
  stroke: 'emboss_stroke',
  densityOffset: 1.0,
  customPainter: (canvas, size, drawingPath) {
    final path = drawingPath.createPath();

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
