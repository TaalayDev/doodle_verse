import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../core/canvas/drawing_canvas.dart';
import '../../data/models/drawing_path.dart';

class DrawingPainter extends CustomPainter {
  DrawingPainter(this.paths, this.currentPath);

  final List<ui.Image> paths;
  final DrawingPath? currentPath;

  final DrawingCanvas _drawingCanvas = DrawingCanvas();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());

    for (var path in paths) {
      canvas.drawImage(path, Offset.zero, Paint());
    }
    if (currentPath != null) {
      _drawingCanvas.drawPath(canvas, currentPath!);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
