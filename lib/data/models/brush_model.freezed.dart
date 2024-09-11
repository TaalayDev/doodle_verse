// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brush_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BrushData {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get stroke => throw _privateConstructorUsedError;
  Image? get brush => throw _privateConstructorUsedError;
  Image? get texture => throw _privateConstructorUsedError;
  bool get isLocked => throw _privateConstructorUsedError;
  bool get isNew => throw _privateConstructorUsedError;
  double get opacityDiff => throw _privateConstructorUsedError;
  ColorFilter? get colorFilter => throw _privateConstructorUsedError;
  StrokeCap get strokeCap => throw _privateConstructorUsedError;
  StrokeJoin get strokeJoin => throw _privateConstructorUsedError;
  BlendMode get blendMode => throw _privateConstructorUsedError;
  double get densityOffset => throw _privateConstructorUsedError;
  bool get useBrushWidthDensity => throw _privateConstructorUsedError;
  List<int> get random => throw _privateConstructorUsedError;
  List<int> get sizeRandom => throw _privateConstructorUsedError;
  MaskFilter? get maskFilter => throw _privateConstructorUsedError;
  Path Function(double, Offset, Offset)? get pathEffect =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BrushDataCopyWith<BrushData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrushDataCopyWith<$Res> {
  factory $BrushDataCopyWith(BrushData value, $Res Function(BrushData) then) =
      _$BrushDataCopyWithImpl<$Res, BrushData>;
  @useResult
  $Res call(
      {int id,
      String name,
      String stroke,
      Image? brush,
      Image? texture,
      bool isLocked,
      bool isNew,
      double opacityDiff,
      ColorFilter? colorFilter,
      StrokeCap strokeCap,
      StrokeJoin strokeJoin,
      BlendMode blendMode,
      double densityOffset,
      bool useBrushWidthDensity,
      List<int> random,
      List<int> sizeRandom,
      MaskFilter? maskFilter,
      Path Function(double, Offset, Offset)? pathEffect});
}

/// @nodoc
class _$BrushDataCopyWithImpl<$Res, $Val extends BrushData>
    implements $BrushDataCopyWith<$Res> {
  _$BrushDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? stroke = null,
    Object? brush = freezed,
    Object? texture = freezed,
    Object? isLocked = null,
    Object? isNew = null,
    Object? opacityDiff = null,
    Object? colorFilter = freezed,
    Object? strokeCap = null,
    Object? strokeJoin = null,
    Object? blendMode = null,
    Object? densityOffset = null,
    Object? useBrushWidthDensity = null,
    Object? random = null,
    Object? sizeRandom = null,
    Object? maskFilter = freezed,
    Object? pathEffect = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      stroke: null == stroke
          ? _value.stroke
          : stroke // ignore: cast_nullable_to_non_nullable
              as String,
      brush: freezed == brush
          ? _value.brush
          : brush // ignore: cast_nullable_to_non_nullable
              as Image?,
      texture: freezed == texture
          ? _value.texture
          : texture // ignore: cast_nullable_to_non_nullable
              as Image?,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      isNew: null == isNew
          ? _value.isNew
          : isNew // ignore: cast_nullable_to_non_nullable
              as bool,
      opacityDiff: null == opacityDiff
          ? _value.opacityDiff
          : opacityDiff // ignore: cast_nullable_to_non_nullable
              as double,
      colorFilter: freezed == colorFilter
          ? _value.colorFilter
          : colorFilter // ignore: cast_nullable_to_non_nullable
              as ColorFilter?,
      strokeCap: null == strokeCap
          ? _value.strokeCap
          : strokeCap // ignore: cast_nullable_to_non_nullable
              as StrokeCap,
      strokeJoin: null == strokeJoin
          ? _value.strokeJoin
          : strokeJoin // ignore: cast_nullable_to_non_nullable
              as StrokeJoin,
      blendMode: null == blendMode
          ? _value.blendMode
          : blendMode // ignore: cast_nullable_to_non_nullable
              as BlendMode,
      densityOffset: null == densityOffset
          ? _value.densityOffset
          : densityOffset // ignore: cast_nullable_to_non_nullable
              as double,
      useBrushWidthDensity: null == useBrushWidthDensity
          ? _value.useBrushWidthDensity
          : useBrushWidthDensity // ignore: cast_nullable_to_non_nullable
              as bool,
      random: null == random
          ? _value.random
          : random // ignore: cast_nullable_to_non_nullable
              as List<int>,
      sizeRandom: null == sizeRandom
          ? _value.sizeRandom
          : sizeRandom // ignore: cast_nullable_to_non_nullable
              as List<int>,
      maskFilter: freezed == maskFilter
          ? _value.maskFilter
          : maskFilter // ignore: cast_nullable_to_non_nullable
              as MaskFilter?,
      pathEffect: freezed == pathEffect
          ? _value.pathEffect
          : pathEffect // ignore: cast_nullable_to_non_nullable
              as Path Function(double, Offset, Offset)?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BrushDataImplCopyWith<$Res>
    implements $BrushDataCopyWith<$Res> {
  factory _$$BrushDataImplCopyWith(
          _$BrushDataImpl value, $Res Function(_$BrushDataImpl) then) =
      __$$BrushDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String stroke,
      Image? brush,
      Image? texture,
      bool isLocked,
      bool isNew,
      double opacityDiff,
      ColorFilter? colorFilter,
      StrokeCap strokeCap,
      StrokeJoin strokeJoin,
      BlendMode blendMode,
      double densityOffset,
      bool useBrushWidthDensity,
      List<int> random,
      List<int> sizeRandom,
      MaskFilter? maskFilter,
      Path Function(double, Offset, Offset)? pathEffect});
}

/// @nodoc
class __$$BrushDataImplCopyWithImpl<$Res>
    extends _$BrushDataCopyWithImpl<$Res, _$BrushDataImpl>
    implements _$$BrushDataImplCopyWith<$Res> {
  __$$BrushDataImplCopyWithImpl(
      _$BrushDataImpl _value, $Res Function(_$BrushDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? stroke = null,
    Object? brush = freezed,
    Object? texture = freezed,
    Object? isLocked = null,
    Object? isNew = null,
    Object? opacityDiff = null,
    Object? colorFilter = freezed,
    Object? strokeCap = null,
    Object? strokeJoin = null,
    Object? blendMode = null,
    Object? densityOffset = null,
    Object? useBrushWidthDensity = null,
    Object? random = null,
    Object? sizeRandom = null,
    Object? maskFilter = freezed,
    Object? pathEffect = freezed,
  }) {
    return _then(_$BrushDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      stroke: null == stroke
          ? _value.stroke
          : stroke // ignore: cast_nullable_to_non_nullable
              as String,
      brush: freezed == brush
          ? _value.brush
          : brush // ignore: cast_nullable_to_non_nullable
              as Image?,
      texture: freezed == texture
          ? _value.texture
          : texture // ignore: cast_nullable_to_non_nullable
              as Image?,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      isNew: null == isNew
          ? _value.isNew
          : isNew // ignore: cast_nullable_to_non_nullable
              as bool,
      opacityDiff: null == opacityDiff
          ? _value.opacityDiff
          : opacityDiff // ignore: cast_nullable_to_non_nullable
              as double,
      colorFilter: freezed == colorFilter
          ? _value.colorFilter
          : colorFilter // ignore: cast_nullable_to_non_nullable
              as ColorFilter?,
      strokeCap: null == strokeCap
          ? _value.strokeCap
          : strokeCap // ignore: cast_nullable_to_non_nullable
              as StrokeCap,
      strokeJoin: null == strokeJoin
          ? _value.strokeJoin
          : strokeJoin // ignore: cast_nullable_to_non_nullable
              as StrokeJoin,
      blendMode: null == blendMode
          ? _value.blendMode
          : blendMode // ignore: cast_nullable_to_non_nullable
              as BlendMode,
      densityOffset: null == densityOffset
          ? _value.densityOffset
          : densityOffset // ignore: cast_nullable_to_non_nullable
              as double,
      useBrushWidthDensity: null == useBrushWidthDensity
          ? _value.useBrushWidthDensity
          : useBrushWidthDensity // ignore: cast_nullable_to_non_nullable
              as bool,
      random: null == random
          ? _value._random
          : random // ignore: cast_nullable_to_non_nullable
              as List<int>,
      sizeRandom: null == sizeRandom
          ? _value._sizeRandom
          : sizeRandom // ignore: cast_nullable_to_non_nullable
              as List<int>,
      maskFilter: freezed == maskFilter
          ? _value.maskFilter
          : maskFilter // ignore: cast_nullable_to_non_nullable
              as MaskFilter?,
      pathEffect: freezed == pathEffect
          ? _value.pathEffect
          : pathEffect // ignore: cast_nullable_to_non_nullable
              as Path Function(double, Offset, Offset)?,
    ));
  }
}

/// @nodoc

class _$BrushDataImpl implements _BrushData {
  const _$BrushDataImpl(
      {required this.id,
      required this.name,
      required this.stroke,
      this.brush,
      this.texture,
      this.isLocked = false,
      this.isNew = false,
      this.opacityDiff = 0.0,
      this.colorFilter,
      this.strokeCap = StrokeCap.butt,
      this.strokeJoin = StrokeJoin.round,
      this.blendMode = BlendMode.srcOver,
      this.densityOffset = 5.0,
      this.useBrushWidthDensity = true,
      final List<int> random = const [0, 0],
      final List<int> sizeRandom = const [0, 0],
      this.maskFilter,
      this.pathEffect})
      : _random = random,
        _sizeRandom = sizeRandom;

  @override
  final int id;
  @override
  final String name;
  @override
  final String stroke;
  @override
  final Image? brush;
  @override
  final Image? texture;
  @override
  @JsonKey()
  final bool isLocked;
  @override
  @JsonKey()
  final bool isNew;
  @override
  @JsonKey()
  final double opacityDiff;
  @override
  final ColorFilter? colorFilter;
  @override
  @JsonKey()
  final StrokeCap strokeCap;
  @override
  @JsonKey()
  final StrokeJoin strokeJoin;
  @override
  @JsonKey()
  final BlendMode blendMode;
  @override
  @JsonKey()
  final double densityOffset;
  @override
  @JsonKey()
  final bool useBrushWidthDensity;
  final List<int> _random;
  @override
  @JsonKey()
  List<int> get random {
    if (_random is EqualUnmodifiableListView) return _random;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_random);
  }

  final List<int> _sizeRandom;
  @override
  @JsonKey()
  List<int> get sizeRandom {
    if (_sizeRandom is EqualUnmodifiableListView) return _sizeRandom;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sizeRandom);
  }

  @override
  final MaskFilter? maskFilter;
  @override
  final Path Function(double, Offset, Offset)? pathEffect;

  @override
  String toString() {
    return 'BrushData(id: $id, name: $name, stroke: $stroke, brush: $brush, texture: $texture, isLocked: $isLocked, isNew: $isNew, opacityDiff: $opacityDiff, colorFilter: $colorFilter, strokeCap: $strokeCap, strokeJoin: $strokeJoin, blendMode: $blendMode, densityOffset: $densityOffset, useBrushWidthDensity: $useBrushWidthDensity, random: $random, sizeRandom: $sizeRandom, maskFilter: $maskFilter, pathEffect: $pathEffect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrushDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.stroke, stroke) || other.stroke == stroke) &&
            (identical(other.brush, brush) || other.brush == brush) &&
            (identical(other.texture, texture) || other.texture == texture) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked) &&
            (identical(other.isNew, isNew) || other.isNew == isNew) &&
            (identical(other.opacityDiff, opacityDiff) ||
                other.opacityDiff == opacityDiff) &&
            (identical(other.colorFilter, colorFilter) ||
                other.colorFilter == colorFilter) &&
            (identical(other.strokeCap, strokeCap) ||
                other.strokeCap == strokeCap) &&
            (identical(other.strokeJoin, strokeJoin) ||
                other.strokeJoin == strokeJoin) &&
            (identical(other.blendMode, blendMode) ||
                other.blendMode == blendMode) &&
            (identical(other.densityOffset, densityOffset) ||
                other.densityOffset == densityOffset) &&
            (identical(other.useBrushWidthDensity, useBrushWidthDensity) ||
                other.useBrushWidthDensity == useBrushWidthDensity) &&
            const DeepCollectionEquality().equals(other._random, _random) &&
            const DeepCollectionEquality()
                .equals(other._sizeRandom, _sizeRandom) &&
            (identical(other.maskFilter, maskFilter) ||
                other.maskFilter == maskFilter) &&
            (identical(other.pathEffect, pathEffect) ||
                other.pathEffect == pathEffect));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      stroke,
      brush,
      texture,
      isLocked,
      isNew,
      opacityDiff,
      colorFilter,
      strokeCap,
      strokeJoin,
      blendMode,
      densityOffset,
      useBrushWidthDensity,
      const DeepCollectionEquality().hash(_random),
      const DeepCollectionEquality().hash(_sizeRandom),
      maskFilter,
      pathEffect);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BrushDataImplCopyWith<_$BrushDataImpl> get copyWith =>
      __$$BrushDataImplCopyWithImpl<_$BrushDataImpl>(this, _$identity);
}

abstract class _BrushData implements BrushData {
  const factory _BrushData(
          {required final int id,
          required final String name,
          required final String stroke,
          final Image? brush,
          final Image? texture,
          final bool isLocked,
          final bool isNew,
          final double opacityDiff,
          final ColorFilter? colorFilter,
          final StrokeCap strokeCap,
          final StrokeJoin strokeJoin,
          final BlendMode blendMode,
          final double densityOffset,
          final bool useBrushWidthDensity,
          final List<int> random,
          final List<int> sizeRandom,
          final MaskFilter? maskFilter,
          final Path Function(double, Offset, Offset)? pathEffect}) =
      _$BrushDataImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  String get stroke;
  @override
  Image? get brush;
  @override
  Image? get texture;
  @override
  bool get isLocked;
  @override
  bool get isNew;
  @override
  double get opacityDiff;
  @override
  ColorFilter? get colorFilter;
  @override
  StrokeCap get strokeCap;
  @override
  StrokeJoin get strokeJoin;
  @override
  BlendMode get blendMode;
  @override
  double get densityOffset;
  @override
  bool get useBrushWidthDensity;
  @override
  List<int> get random;
  @override
  List<int> get sizeRandom;
  @override
  MaskFilter? get maskFilter;
  @override
  Path Function(double, Offset, Offset)? get pathEffect;
  @override
  @JsonKey(ignore: true)
  _$$BrushDataImplCopyWith<_$BrushDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
