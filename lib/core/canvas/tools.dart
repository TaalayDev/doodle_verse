import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../data.dart';

extension CanvasX on Canvas {
  ui.Picture getPicture() {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawPaint(Paint()..color = Colors.transparent);
    return recorder.endRecording();
  }
}

final fillTool = BrushData(
  id: 41,
  name: 'fill',
  stroke: 'fill_tool',
  customPainter: (canvas, size, drawingPath) async {
    if (drawingPath.points.isEmpty) return;

    final startPoint = drawingPath.points.first.offset;

    // Create an image from the canvas
    final recorder = ui.PictureRecorder();
    final canvasSize = canvas.getLocalClipBounds().size;
    final canvasImage = Canvas(recorder);

    // Draw the existing content onto the new canvas
    canvas.save();
    canvasImage.drawPicture(canvas.getPicture());
    canvas.restore();

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      canvasSize.width.toInt(),
      canvasSize.height.toInt(),
    );

    // Perform flood fill
    await _floodFill(image, startPoint, drawingPath.color);

    // Draw the filled area back onto the original canvas
    final paint = Paint()..color = drawingPath.color;
    canvas.drawImage(image, Offset.zero, paint);
  },
);

Future<void> _floodFill(
    ui.Image image, Offset startPoint, Color fillColor) async {
  final width = image.width;
  final height = image.height;
  final bytesPerPixel = 4; // Assuming RGBA format
  final pixels = await image.toByteData(format: ui.ImageByteFormat.rawRgba);

  if (pixels == null) return;

  final startX = startPoint.dx.toInt();
  final startY = startPoint.dy.toInt();

  final targetColor = _getPixelColor(pixels, width, startX, startY);
  if (targetColor == fillColor) return;

  final queue = <Point<int>>[];
  queue.add(Point(startX, startY));

  while (queue.isNotEmpty) {
    final point = queue.removeLast();
    final x = point.x;
    final y = point.y;

    if (_getPixelColor(pixels, width, x, y) != targetColor) continue;

    var westX = x;
    var eastX = x + 1;

    while (
        westX >= 0 && _getPixelColor(pixels, width, westX, y) == targetColor) {
      _setPixelColor(pixels, width, westX, y, fillColor);
      if (y > 0 && _getPixelColor(pixels, width, westX, y - 1) == targetColor) {
        queue.add(Point(westX, y - 1));
      }
      if (y < height - 1 &&
          _getPixelColor(pixels, width, westX, y + 1) == targetColor) {
        queue.add(Point(westX, y + 1));
      }
      westX--;
    }

    while (eastX < width &&
        _getPixelColor(pixels, width, eastX, y) == targetColor) {
      _setPixelColor(pixels, width, eastX, y, fillColor);
      if (y > 0 && _getPixelColor(pixels, width, eastX, y - 1) == targetColor) {
        queue.add(Point(eastX, y - 1));
      }
      if (y < height - 1 &&
          _getPixelColor(pixels, width, eastX, y + 1) == targetColor) {
        queue.add(Point(eastX, y + 1));
      }
      eastX++;
    }
  }
}

Color _getPixelColor(ByteData pixels, int width, int x, int y) {
  final offset = (y * width + x) * 4;
  return Color.fromARGB(
    pixels.getUint8(offset + 3),
    pixels.getUint8(offset),
    pixels.getUint8(offset + 1),
    pixels.getUint8(offset + 2),
  );
}

void _setPixelColor(ByteData pixels, int width, int x, int y, Color color) {
  final offset = (y * width + x) * 4;
  pixels.setUint8(offset, color.red);
  pixels.setUint8(offset + 1, color.green);
  pixels.setUint8(offset + 2, color.blue);
  pixels.setUint8(offset + 3, color.alpha);
}
