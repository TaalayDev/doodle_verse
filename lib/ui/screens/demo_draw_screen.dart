import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:doodle_verse/core/canvas/tools_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

final Map<String, double> _randomCache = {};
final Random _random = Random();

class DemoDrawingScreen extends StatefulWidget {
  const DemoDrawingScreen({super.key});

  @override
  State<DemoDrawingScreen> createState() => _DemoDrawingScreenState();
}

class _DemoDrawingScreenState extends State<DemoDrawingScreen> {
  StrokeOptions options = StrokeOptions(
    size: 16,
    thinning: 0.7,
    smoothing: 0.5,
    streamline: 0.5,
    start: StrokeEndOptions.start(
      taperEnabled: true,
      customTaper: 0.0,
      cap: true,
    ),
    end: StrokeEndOptions.end(
      taperEnabled: true,
      customTaper: 0.0,
      cap: true,
    ),
    simulatePressure: true,
    isComplete: false,
  );

  /// Previous lines drawn.
  final lines = ValueNotifier(<Stroke>[]);

  /// The current line being drawn.
  final line = ValueNotifier<Stroke?>(null);

  void clear() => setState(() {
        lines.value = [];
        line.value = null;
      });

  void onPointerDown(PointerDownEvent details) {
    final supportsPressure = details.kind == PointerDeviceKind.stylus;
    options = options.copyWith(simulatePressure: !supportsPressure);

    final localPosition = details.localPosition;
    final point = PointVector(
      localPosition.dx,
      localPosition.dy,
      supportsPressure ? details.pressure : null,
    );

    line.value = Stroke([point]);
  }

  void onPointerMove(PointerMoveEvent details) {
    final supportsPressure = details.pressureMin < 1;
    final localPosition = details.localPosition;
    final point = PointVector(
      localPosition.dx,
      localPosition.dy,
      supportsPressure ? details.pressure : null,
    );

    line.value = Stroke([...line.value!.points, point]);
  }

  void onPointerUp(PointerUpEvent details) {
    lines.value = [...lines.value, line.value!];
    line.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Listener(
        onPointerDown: onPointerDown,
        onPointerMove: onPointerMove,
        onPointerUp: onPointerUp,
        child: Stack(
          children: [
            Positioned.fill(
              child: ValueListenableBuilder(
                valueListenable: lines,
                builder: (context, lines, _) {
                  return CustomPaint(
                    painter: StrokePainter(
                      color: colorScheme.onSurface,
                      lines: lines,
                      options: options,
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: ValueListenableBuilder(
                valueListenable: line,
                builder: (context, line, _) {
                  return CustomPaint(
                    painter: StrokePainter(
                      color: colorScheme.onSurface,
                      lines: line == null ? [] : [line],
                      options: options,
                    ),
                  );
                },
              ),
            ),
            Toolbar(
              options: options,
              updateOptions: setState,
              clear: clear,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    lines.dispose();
    line.dispose();
    super.dispose();
  }
}

class StrokePainter extends CustomPainter {
  StrokePainter({
    required this.color,
    required this.lines,
    required this.options,
  });

  final Color color;
  final List<Stroke> lines;
  final StrokeOptions options;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    for (final line in lines) {
      final outlinePoints = getStroke(line.points, options: options);

      if (outlinePoints.isEmpty) {
        continue;
      } else if (outlinePoints.length < 2) {
        // If the path only has one point, draw a dot.
        canvas.drawCircle(
          outlinePoints.first,
          options.size / 2,
          paint,
        );
      } else {
        final path = Path();
        path.moveTo(outlinePoints.first.dx, outlinePoints.first.dy);
        for (int i = 0; i < outlinePoints.length - 1; ++i) {
          final p0 = outlinePoints[i];
          final p1 = outlinePoints[i + 1];
          path.quadraticBezierTo(
            p0.dx,
            p0.dy,
            (p0.dx + p1.dx) / 2,
            (p0.dy + p1.dy) / 2,
          );
        }
        // You'll see performance improvements if you cache this Path
        // instead of creating a new one every paint.
        // canvas.drawPath(path, paint);
        // _drawPencilEffect(canvas, path, paint, options.size);
        _drawStartPath(canvas, path, paint, options.size);
      }
    }
  }

  void _drawStartPath(Canvas canvas, Path path, Paint paint, double width) {
    final adjustedPaint = paint
      ..color = paint.color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = width;

    final pathMetrics = path.computeMetrics();
    final Random random = Random();
    final Path modifiedPath = Path();

    // Traverse through the entire path
    for (var metric in pathMetrics) {
      double distance = 0.0;
      final length = metric.length;

      // Traverse the path with a certain step to simulate pencil texture
      while (distance < length) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent == null) break;

        final position = tangent.position;

        final randomX = getRandom([position.dx, position.dy, distance]);
        final randomY = getRandom([position.dy, position.dx, distance]);
        // Slight variations in position to simulate pencil randomness
        final dx = (randomX - 0.5) * width * 0.3;
        final dy = (randomY - 0.5) * width * 0.3;

        // Add the randomized point to the modified path
        if (distance == 0.0) {
          modifiedPath.moveTo(position.dx + dx, position.dy + dy);
        } else {
          modifiedPath.lineTo(position.dx + dx, position.dy + dy);
        }

        // Increase the distance by a factor to control how often we apply randomness
        distance += width * 0.7; // Adjust based on desired smoothness
      }
    }

    // Draw the entire modified path in one go
    canvas.drawPath(modifiedPath, adjustedPaint);
  }

  void _drawPencilEffect(Canvas canvas, Path path, Paint paint, double width) {
    final adjustedPaint = paint
      ..color = paint.color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = width;

    final pathMetrics = path.computeMetrics();
    final Random random = Random();
    final Path modifiedPath = Path();

    // Traverse through the entire path
    for (var metric in pathMetrics) {
      double distance = 0.0;
      final length = metric.length;

      // Traverse the path with a certain step to simulate pencil texture
      while (distance < length) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent == null) break;

        final position = tangent.position;

        final randomX = getRandom([position.dx, position.dy, distance]);
        final randomY = getRandom([position.dy, position.dx, distance]);
        // Slight variations in position to simulate pencil randomness
        final dx = (randomX - 0.5) * width * 0.3;
        final dy = (randomY - 0.5) * width * 0.3;

        // Add the randomized point to the modified path
        if (distance == 0.0) {
          modifiedPath.moveTo(position.dx + dx, position.dy + dy);
        } else {
          modifiedPath.lineTo(position.dx + dx, position.dy + dy);
        }

        // Increase the distance by a factor to control how often we apply randomness
        distance += width * 0.7; // Adjust based on desired smoothness
      }
    }

    // Draw the entire modified path in one go
    canvas.drawPath(modifiedPath, adjustedPaint);
  }

  double getRandom(List<num> vals) {
    final key = vals.join(',');
    return _randomCache.putIfAbsent(key, () => _random.nextDouble());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Toolbar extends StatelessWidget {
  const Toolbar({
    super.key,
    required this.options,
    required this.updateOptions,
    required this.clear,
  });

  final StrokeOptions options;
  final void Function(void Function()) updateOptions;
  final void Function() clear;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      width: 200,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Size',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Slider(
                value: options.size,
                min: 1,
                max: 50,
                divisions: 100,
                label: options.size.round().toString(),
                onChanged: (double value) => {
                  updateOptions(() {
                    options.size = value;
                  })
                },
              ),
              const Text(
                'Thinning',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Slider(
                value: options.thinning,
                min: -1,
                max: 1,
                divisions: 100,
                label: options.thinning.toStringAsFixed(2),
                onChanged: (double value) => {
                  updateOptions(() {
                    options.thinning = value;
                  })
                },
              ),
              const Text(
                'Streamline',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Slider(
                value: options.streamline,
                min: 0,
                max: 1,
                divisions: 100,
                label: options.streamline.toStringAsFixed(2),
                onChanged: (double value) => {
                  updateOptions(() {
                    options.streamline = value;
                  })
                },
              ),
              const Text(
                'Smoothing',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Slider(
                value: options.smoothing,
                min: 0,
                max: 1,
                divisions: 100,
                label: options.smoothing.toStringAsFixed(2),
                onChanged: (double value) => {
                  updateOptions(() {
                    options.smoothing = value;
                  })
                },
              ),
              const Text(
                'Taper Start',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Slider(
                value: options.start.customTaper!,
                min: 0,
                max: 100,
                divisions: 100,
                label: options.start.customTaper!.toStringAsFixed(2),
                onChanged: (double value) => {
                  updateOptions(() {
                    options.start.customTaper = value;
                  })
                },
              ),
              const Text(
                'Taper End',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Slider(
                value: options.end.customTaper!,
                min: 0,
                max: 100,
                divisions: 100,
                label: options.end.customTaper!.toStringAsFixed(2),
                onChanged: (double value) => {
                  updateOptions(() {
                    options.end.customTaper = value;
                  })
                },
              ),
              const Text(
                'Clear',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              IconButton(
                icon: const Icon(Icons.replay),
                onPressed: clear,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Stroke {
  final List<PointVector> points;

  const Stroke(this.points);
}
