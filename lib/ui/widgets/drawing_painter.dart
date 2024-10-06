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

    if (controller.isDirty) {
      _renderCacheImage(size, null);
    }

    for (var i = 0; i < controller.cachedImages.length; i++) {
      final cache = controller.cachedImages[i];
      if (!cache.isVisible) continue;
      canvas.drawImage(cache.image, Offset.zero, Paint());
      if (controller.currentLayer.id == cache.id) {
        _renderDirtyRegion(canvas, size, Offset.zero & size);
      }
    }

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
    final paint = Paint();

    regionCanvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    if (controller.currentPath != null) {
      var path = controller.currentPath!.brush.blendMode == BlendMode.clear
          ? controller.currentPath!.copyWith(
              color: Colors.white,
              brush: controller.currentPath!.brush.copyWith(
                blendMode: BlendMode.srcOver,
              ),
            )
          : controller.currentPath!;
      _drawingCanvas.drawPath(
        regionCanvas,
        size,
        path,
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
  bool shouldRepaint(covariant DrawingPainter oldDelegate) => true;
}
