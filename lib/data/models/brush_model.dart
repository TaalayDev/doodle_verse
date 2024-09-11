import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../config/assets.dart';

part 'brush_model.freezed.dart';

@freezed
class BrushData with _$BrushData {
  const factory BrushData({
    required int id,
    required String name,
    required String stroke,
    Image? brush,
    Image? texture,
    @Default(false) bool isLocked,
    @Default(false) bool isNew,
    @Default(0.0) double opacityDiff,
    ColorFilter? colorFilter,
    @Default(StrokeCap.butt) StrokeCap strokeCap,
    @Default(StrokeJoin.round) StrokeJoin strokeJoin,
    @Default(BlendMode.srcOver) BlendMode blendMode,
    @Default(5.0) double densityOffset,
    @Default(true) bool useBrushWidthDensity,
    @Default([0, 0]) List<int> random,
    @Default([0, 0]) List<int> sizeRandom,
    MaskFilter? maskFilter,
    Path Function(double width, Offset, Offset)? pathEffect,
  }) = _BrushData;
}
