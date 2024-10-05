import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' show Random;

import 'package:flutter/material.dart';

class PencilEffect {
  final ui.Image noiseTexture;
  final Random random = Random();

  PencilEffect(this.noiseTexture);

  void drawPencilEffect(Canvas canvas, Path path, Color color, double width) {
    final paintMatrix4 = Matrix4.identity()
      ..rotateZ(random.nextDouble() * 2 * 3.14159);
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(noiseTexture.width.toDouble(), noiseTexture.height.toDouble()),
        [color.withOpacity(0.1), color.withOpacity(0.3)],
        [0, 1],
        TileMode.repeated,
        paintMatrix4.storage,
      )
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, width / 4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final shaderMatrix4 = Matrix4.identity()..scale(1 / (width * 2));
    // Apply the noise texture
    paint.shader = ui.ImageShader(
      noiseTexture,
      TileMode.repeated,
      TileMode.repeated,
      shaderMatrix4.storage,
    );

    // Draw the path multiple times with slight offsets
    for (int i = 0; i < 3; i++) {
      final offsetPath = path.shift(Offset(
        random.nextDouble() * width / 2 - width / 4,
        random.nextDouble() * width / 2 - width / 4,
      ));
      canvas.drawPath(offsetPath, paint);
    }
  }

  // Method to create a noise texture (call this once and reuse the texture)
  static Future<ui.Image> createNoiseTexture(int width, int height) async {
    final pixels = Uint8List(width * height * 4);
    final random = Random();

    for (int i = 0; i < pixels.length; i += 4) {
      final value = random.nextInt(256);
      pixels[i] = value; // R
      pixels[i + 1] = value; // G
      pixels[i + 2] = value; // B
      pixels[i + 3] = 255; // A
    }

    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels,
      width,
      height,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );

    return completer.future;
  }
}
