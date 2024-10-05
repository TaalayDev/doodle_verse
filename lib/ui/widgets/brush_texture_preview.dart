import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/canvas/drawing_canvas.dart';
import '../../data/models/drawing_path.dart';
import '../../data.dart';

class BrushTexturePreview extends StatelessWidget {
  final BrushData brush;
  final Color color;
  final bool isSelected;

  const BrushTexturePreview({
    super.key,
    required this.brush,
    required this.color,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          width: 2,
        ),
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CustomPaint(
            painter: _BrushTexturePainter(brush: brush, color: color),
          ),
        ),
      ),
    );
  }
}

class _BrushTexturePainter extends CustomPainter {
  final BrushData brush;
  final Color color;

  _BrushTexturePainter({required this.brush, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final drawingPath = DrawingPath(
      brush: brush,
      color: color,
      width: 4,
      points: _createCurvedLinePoints(size),
    );

    DrawingCanvas().drawPath(canvas, size, drawingPath);
  }

  List<Offset> _createCurvedLinePoints(Size size) {
    final points = <Offset>[];

    final double width = size.width;
    final double height = size.height;
    final double midWidth = width / 2;
    final double midHeight = height / 2;
    final double quarterWidth = width / 4;
    final double quarterHeight = height / 4;
    final double eighthWidth = width / 8;

    points.add(Offset(5, midHeight));
    points.add(Offset(eighthWidth, midHeight - quarterHeight));
    points.add(Offset(quarterWidth, midHeight));
    points.add(Offset(eighthWidth * 3, midHeight + quarterHeight));
    points.add(Offset(midWidth, midHeight));
    points.add(Offset(eighthWidth * 5, midHeight - quarterHeight));
    points.add(Offset(quarterWidth * 3, midHeight));
    points.add(Offset(eighthWidth * 7, midHeight + quarterHeight));
    points.add(Offset(width, midHeight));

    return points;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
