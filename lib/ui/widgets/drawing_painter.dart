import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../core/canvas/drawing_canvas.dart';
import '../../core/canvas/drawing_controller.dart';

class DrawingPainter extends CustomPainter {
  DrawingPainter(
    this.controller,
  ) : super(repaint: controller);

  final DrawingController controller;
  final DrawingCanvas _drawingCanvas = DrawingCanvas();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    final dirtyRegion = controller.getDirtyRegion();

    if (controller.cachedImage == null ||
        controller.paths.length != controller.lastPathsLength) {
      _renderPathsToImage(size, null);
    }

    if (controller.cachedImage != null) {
      canvas.drawImage(controller.cachedImage!, Offset.zero, Paint());
    }
    _renderDirtyRegion(canvas, size, Offset.zero & size);

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
