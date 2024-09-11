import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/assets.dart';
import '../data.dart';

part 'common.g.dart';

final localStorageProvider = Provider((ref) => LocalStorage());
final databaseProvider = Provider((ref) => DatabaseHelper.instance);

typedef ToolsData = ({
  BrushData pencil,
  BrushData defaultBrush,
  BrushData marker,
  BrushData watercolor,
  BrushData eraser,
  BrushData brush1,
  BrushData crayon,
  BrushData sprayPaint,
  BrushData neon,
  BrushData charcoal,
  BrushData star,
  BrushData sketchy,
  BrushData heart,
});

@riverpod
class Tools extends _$Tools {
  @override
  Future<ToolsData> build() async {
    final pencil = BrushData(
      id: 1,
      name: 'pencil',
      stroke: 'pencil_stroke',
      brush: await _loadUIImage(Assets.images.pencil),
      opacityDiff: 0.2,
      isNew: true,
      isLocked: true,
      densityOffset: 1.0,
      strokeJoin: ui.StrokeJoin.bevel,
      random: [-1, 1],
      sizeRandom: [-3, 3],
    );

    const defaultBrush = BrushData(
      id: 0,
      name: 'Default',
      stroke: 'brush_stroke',
      densityOffset: 1.0,
      strokeCap: ui.StrokeCap.round,
    );

    final marker = BrushData(
      id: 2,
      name: 'marker',
      stroke: 'marker_stroke',
      isNew: true,
      opacityDiff: 0.1,
      strokeCap: ui.StrokeCap.square,
      strokeJoin: ui.StrokeJoin.bevel,
      isLocked: true,
      densityOffset: 1.0,
      useBrushWidthDensity: false,
      brush: await _loadUIImage(Assets.images.marker),
    );

    final watercolor = BrushData(
      id: 3,
      name: 'watercolor',
      stroke: 'watercolor_stroke',
      brush: await _loadUIImage(Assets.images.watercolorSplash),
      densityOffset: 2.0,
      opacityDiff: 0.5,
      sizeRandom: [-20, 20],
      useBrushWidthDensity: false,
    );

    final brush1 = BrushData(
      id: 4,
      name: 'brush1',
      stroke: 'eraser_stroke',
      brush: await _loadUIImage(Assets.images.particles),
      densityOffset: 20.0,
      sizeRandom: [-5, 5],
    );

    const eraser = BrushData(
      id: 5,
      name: 'eraser',
      stroke: 'eraser_stroke',
      blendMode: ui.BlendMode.clear,
      colorFilter: ui.ColorFilter.mode(
        Colors.black,
        ui.BlendMode.clear,
      ),
    );

    final crayon = BrushData(
      id: 6,
      name: 'crayon',
      stroke: 'crayon_stroke',
      opacityDiff: 0.1,
      strokeCap: ui.StrokeCap.round,
      strokeJoin: ui.StrokeJoin.round,
      random: [-2, 2],
      sizeRandom: [-1, 1],
      pathEffect: (width, offset, randomOffset) {
        final crayon = Path();
        for (var i = 0; i < 3; i++) {
          crayon.moveTo(offset.dx + i * 2, offset.dy);
          crayon.lineTo(offset.dx + width + i * 2, offset.dy + width);
        }
        return crayon;
      },
    );

    final sprayPaint = BrushData(
      id: 7,
      name: 'sprayPaint',
      stroke: 'spray_paint_stroke',
      opacityDiff: 0.2,
      densityOffset: 5.0,
      random: [-5, 5],
      sizeRandom: [-5, 5],
      brush: await _loadUIImage(Assets.images.confeti),
    );

    const neon = BrushData(
      id: 8,
      name: 'neon',
      stroke: 'neon_stroke',
      opacityDiff: 0.1,
      densityOffset: 1,
      strokeCap: ui.StrokeCap.round,
      strokeJoin: ui.StrokeJoin.round,
      blendMode: ui.BlendMode.screen,
    );

    final charcoal = BrushData(
      id: 9,
      name: 'charcoal',
      stroke: 'charcoal_stroke',
      opacityDiff: 0.15,
      densityOffset: 5,
      strokeCap: ui.StrokeCap.square,
      strokeJoin: ui.StrokeJoin.bevel,
      random: [-3, 3],
      sizeRandom: [-2, 2],
      pathEffect: (width, offset, randomOffset) {
        final charcoal = Path();
        for (var i = 0; i < 5; i++) {
          final dx = offset.dx + (randomOffset.dx - 0.5) * width;
          final dy = offset.dy + (randomOffset.dy - 0.5) * width;
          charcoal.moveTo(dx, dy);
          charcoal.lineTo(dx + width / 2, dy + width / 2);
        }
        return charcoal;
      },
    );

    final sketchy = BrushData(
      id: 11,
      name: 'sketchy',
      stroke: 'sketchy_stroke',
      densityOffset: 30,
      pathEffect: (width, offset, random) {
        final path = Path();
        for (int i = 0; i < 5; i++) {
          final dx = (random.dx - 0.5) * width;
          final dy = (random.dx - 0.5) * width;

          path
            ..moveTo(offset.dx + dx, offset.dy + dy)
            ..lineTo(offset.dx + dx + random.dx * width,
                offset.dy + dy + random.dx * width);
        }
        return path;
      },
    );

    final star = BrushData(
      id: 9,
      name: 'star',
      stroke: 'star_stroke',
      densityOffset: 20,
      brush: await _loadUIImage(Assets.images.starBrush),
    );

    final heart = BrushData(
      id: 10,
      name: 'heart',
      stroke: 'heart_stroke',
      densityOffset: 20,
      brush: await _loadUIImage(Assets.images.heart),
    );

    return (
      pencil: pencil,
      defaultBrush: defaultBrush,
      marker: marker,
      watercolor: watercolor,
      eraser: eraser,
      brush1: brush1,
      crayon: crayon,
      sprayPaint: sprayPaint,
      neon: neon,
      charcoal: charcoal,
      sketchy: sketchy,
      star: star,
      heart: heart,
    );
  }

  Path _createStarPath(Offset center, double size) {
    final path = Path();
    // Define the star parameters
    final int numberOfPoints = 5;
    final double radiusOuter = size;
    final double radiusInner = size / 2;
    final double centerX = center.dx;
    final double centerY = center.dy;

    // Draw the star
    double angle = (2 * pi) / numberOfPoints;
    for (int i = 0; i < numberOfPoints; i++) {
      double outerX = centerX + radiusOuter * cos(i * angle - pi / 2);
      double outerY = centerY + radiusOuter * sin(i * angle - pi / 2);

      double innerX = centerX + radiusInner * cos((i + 0.5) * angle - pi / 2);
      double innerY = centerY + radiusInner * sin((i + 0.5) * angle - pi / 2);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }

    path.close();
    return path;
  }

  Future<ui.Image?> _loadUIImage(String asset) async {
    final data = await rootBundle.load(asset);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final fi = await codec.getNextFrame();

    return fi.image;
  }
}
