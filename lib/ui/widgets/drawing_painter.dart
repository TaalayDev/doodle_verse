import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../core/canvas/drawing_canvas.dart';
import '../../core/canvas/drawing_controller.dart';
import '../../data/models/drawing_path.dart';

class DrawingPainter extends CustomPainter {
  DrawingPainter(this.controller) : super(repaint: controller);

  final DrawingController controller;
  final DrawingCanvas _drawingCanvas = DrawingCanvas();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());

    for (var path in controller.paths) {
      _drawingCanvas.drawPath(canvas, size, path);
    }
    if (controller.currentPath != null) {
      _drawingCanvas.drawPath(canvas, size, controller.currentPath!);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) => false;
}
