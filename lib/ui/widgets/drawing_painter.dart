import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../core/canvas/drawing_canvas.dart';
import '../../core/canvas/drawing_controller.dart';

class DrawingPainter extends CustomPainter {
  DrawingPainter(
    this.controller,
  ) : super(repaint: controller);

  final DrawingController controller;
  DrawingCanvas get _drawingCanvas => controller.drawingCanvas;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    final dirtyRegion = controller.getDirtyRegion();

    if (controller.cachedImage == null || controller.isDirty) {
      _renderCacheImage(size, null);
    }

    if (controller.cachedImage != null) {
      canvas.drawImage(controller.cachedImage!, Offset.zero, Paint());
    }
    _renderDirtyRegion(canvas, size, Offset.zero & size);

    canvas.restore();
    controller.clearDirtyRegions();
  }

  void _renderCacheImage(Size size, Rect? region) async {
    controller.updateLayerCache(size, region);
  }

  void _renderDirtyRegion(
    Canvas canvas,
    Size size,
    Rect dirtyRegion,
  ) {
    final recorder = ui.PictureRecorder();
    final regionCanvas = Canvas(recorder);
    final paint = Paint()
      ..blendMode = BlendMode.srcOver
      ..isAntiAlias = true;

    regionCanvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    if (controller.currentPath != null) {
      _drawingCanvas.drawPath(
        regionCanvas,
        size,
        controller.currentPath!.copyWith(
          color: controller.currentPath!.brush.blendMode == BlendMode.clear
              ? Colors.white
              : controller.currentPath!.color,
          brush: controller.currentPath!.brush.copyWith(
            blendMode: BlendMode.srcOver,
          ),
        ),
      );
    }

    regionCanvas.restore();

    final picture = recorder.endRecording();
    final image = picture.toImageSync(
      dirtyRegion.width.toInt(),
      dirtyRegion.height.toInt(),
    );

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, dirtyRegion.width, dirtyRegion.height),
      dirtyRegion,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) =>
      oldDelegate.controller != controller;
}
