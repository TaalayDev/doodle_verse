import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../core/canvas/drawing_canvas.dart';
import '../../core/canvas/drawing_controller.dart';
import '../../data/models/drawing_path.dart';

class DrawingPainter extends CustomPainter {
  DrawingPainter(this.controller) : super(repaint: controller);

  final DrawingController controller;
  final DrawingCanvas _drawingCanvas = DrawingCanvas();
  ui.Picture? _cachedPicture;
  int _lastPathCount = 0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());

    if (_cachedPicture == null || _lastPathCount != controller.paths.length) {
      _renderCachedPicture(size);
    }

    if (_cachedPicture != null) {
      canvas.drawPicture(_cachedPicture!);
    }

    if (controller.currentPath != null) {
      _drawingCanvas.drawPath(canvas, size, controller.currentPath!);
    }

    canvas.restore();
  }

  void _renderCachedPicture(Size size) {
    final recorder = ui.PictureRecorder();
    final recordingCanvas = Canvas(recorder);

    for (var path in controller.paths) {
      _drawingCanvas.drawPath(recordingCanvas, size, path);
    }

    _cachedPicture = recorder.endRecording();
    _lastPathCount = controller.paths.length;
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) =>
      oldDelegate.controller != controller;
}
