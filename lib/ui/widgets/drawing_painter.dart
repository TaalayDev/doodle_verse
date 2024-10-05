import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../core/canvas/drawing_canvas.dart';
import '../../core/canvas/drawing_controller.dart';

class DrawingPainter extends CustomPainter {
  DrawingPainter(
    this.controller, {
    this.isPreview = true,
  }) : super(repaint: controller);

  final DrawingController controller;
  final bool isPreview;
  final DrawingCanvas _drawingCanvas = DrawingCanvas();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    final dirtyRegion = controller.getDirtyRegion();

    if (!isPreview) {
      if (controller.cachedImage == null ||
          controller.paths.length != controller.lastPathsLength) {
        _renderPathsToImage(size, null);
      }

      if (controller.cachedImage != null) {
        canvas.drawImage(controller.cachedImage!, Offset.zero, Paint());
      }
    } else {
      _renderDirtyRegion(canvas, size, Offset.zero & size);
    }

    canvas.restore();
    controller.clearDirtyRegions();
  }

  void _renderPathsToImage(Size size, Rect? region) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final width = region?.width ?? size.width;
    final height = region?.height ?? size.height;
    canvas.saveLayer(
      Rect.fromLTWH(0, 0, width, height),
      Paint()..isAntiAlias = true,
    );

    if (region != null) {
      canvas.clipRect(region);
    }

    for (var path in controller.paths) {
      _drawingCanvas.drawPath(canvas, size, path);
    }

    canvas.restore();

    final picture = recorder.endRecording();
    final image = picture.toImageSync(
      width.toInt(),
      height.toInt(),
    );

    controller.cachedImage = image;
    controller.lastPathsLength = controller.paths.length;
  }

  void _renderDirtyRegion(
    Canvas canvas,
    Size size,
    Rect dirtyRegion,
  ) {
    final recorder = ui.PictureRecorder();
    final regionCanvas = Canvas(recorder);
    regionCanvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );

    regionCanvas.clipRect(dirtyRegion);

    if (controller.currentPath != null) {
      _drawingCanvas.drawPath(
        regionCanvas,
        size,
        controller.currentPath!,
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
      oldDelegate.controller != controller ||
      oldDelegate.isPreview != isPreview;
}
