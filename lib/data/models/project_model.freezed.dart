// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProjectModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<LayerModel> get layers => throw _privateConstructorUsedError;
  String? get cachedImageUrl => throw _privateConstructorUsedError;
  int get createdAt => throw _privateConstructorUsedError;
  int get lastModified => throw _privateConstructorUsedError;
  Size get canvasSize => throw _privateConstructorUsedError;
  double get zoomLevel => throw _privateConstructorUsedError;
  Offset? get lastViewportPosition => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProjectModelCopyWith<ProjectModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectModelCopyWith<$Res> {
  factory $ProjectModelCopyWith(
          ProjectModel value, $Res Function(ProjectModel) then) =
      _$ProjectModelCopyWithImpl<$Res, ProjectModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      List<LayerModel> layers,
      String? cachedImageUrl,
      int createdAt,
      int lastModified,
      Size canvasSize,
      double zoomLevel,
      Offset? lastViewportPosition});
}

/// @nodoc
class _$ProjectModelCopyWithImpl<$Res, $Val extends ProjectModel>
    implements $ProjectModelCopyWith<$Res> {
  _$ProjectModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? layers = null,
    Object? cachedImageUrl = freezed,
    Object? createdAt = null,
    Object? lastModified = null,
    Object? canvasSize = null,
    Object? zoomLevel = null,
    Object? lastViewportPosition = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      layers: null == layers
          ? _value.layers
          : layers // ignore: cast_nullable_to_non_nullable
              as List<LayerModel>,
      cachedImageUrl: freezed == cachedImageUrl
          ? _value.cachedImageUrl
          : cachedImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      lastModified: null == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as int,
      canvasSize: null == canvasSize
          ? _value.canvasSize
          : canvasSize // ignore: cast_nullable_to_non_nullable
              as Size,
      zoomLevel: null == zoomLevel
          ? _value.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      lastViewportPosition: freezed == lastViewportPosition
          ? _value.lastViewportPosition
          : lastViewportPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectModelImplCopyWith<$Res>
    implements $ProjectModelCopyWith<$Res> {
  factory _$$ProjectModelImplCopyWith(
          _$ProjectModelImpl value, $Res Function(_$ProjectModelImpl) then) =
      __$$ProjectModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      List<LayerModel> layers,
      String? cachedImageUrl,
      int createdAt,
      int lastModified,
      Size canvasSize,
      double zoomLevel,
      Offset? lastViewportPosition});
}

/// @nodoc
class __$$ProjectModelImplCopyWithImpl<$Res>
    extends _$ProjectModelCopyWithImpl<$Res, _$ProjectModelImpl>
    implements _$$ProjectModelImplCopyWith<$Res> {
  __$$ProjectModelImplCopyWithImpl(
      _$ProjectModelImpl _value, $Res Function(_$ProjectModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? layers = null,
    Object? cachedImageUrl = freezed,
    Object? createdAt = null,
    Object? lastModified = null,
    Object? canvasSize = null,
    Object? zoomLevel = null,
    Object? lastViewportPosition = freezed,
  }) {
    return _then(_$ProjectModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      layers: null == layers
          ? _value._layers
          : layers // ignore: cast_nullable_to_non_nullable
              as List<LayerModel>,
      cachedImageUrl: freezed == cachedImageUrl
          ? _value.cachedImageUrl
          : cachedImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      lastModified: null == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as int,
      canvasSize: null == canvasSize
          ? _value.canvasSize
          : canvasSize // ignore: cast_nullable_to_non_nullable
              as Size,
      zoomLevel: null == zoomLevel
          ? _value.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      lastViewportPosition: freezed == lastViewportPosition
          ? _value.lastViewportPosition
          : lastViewportPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
    ));
  }
}

/// @nodoc

class _$ProjectModelImpl extends _ProjectModel {
  const _$ProjectModelImpl(
      {required this.id,
      required this.name,
      required final List<LayerModel> layers,
      this.cachedImageUrl,
      required this.createdAt,
      required this.lastModified,
      this.canvasSize = const Size(1080, 1920),
      this.zoomLevel = 1.0,
      this.lastViewportPosition})
      : _layers = layers,
        super._();

  @override
  final String id;
  @override
  final String name;
  final List<LayerModel> _layers;
  @override
  List<LayerModel> get layers {
    if (_layers is EqualUnmodifiableListView) return _layers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_layers);
  }

  @override
  final String? cachedImageUrl;
  @override
  final int createdAt;
  @override
  final int lastModified;
  @override
  @JsonKey()
  final Size canvasSize;
  @override
  @JsonKey()
  final double zoomLevel;
  @override
  final Offset? lastViewportPosition;

  @override
  String toString() {
    return 'ProjectModel(id: $id, name: $name, layers: $layers, cachedImageUrl: $cachedImageUrl, createdAt: $createdAt, lastModified: $lastModified, canvasSize: $canvasSize, zoomLevel: $zoomLevel, lastViewportPosition: $lastViewportPosition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._layers, _layers) &&
            (identical(other.cachedImageUrl, cachedImageUrl) ||
                other.cachedImageUrl == cachedImageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified) &&
            (identical(other.canvasSize, canvasSize) ||
                other.canvasSize == canvasSize) &&
            (identical(other.zoomLevel, zoomLevel) ||
                other.zoomLevel == zoomLevel) &&
            (identical(other.lastViewportPosition, lastViewportPosition) ||
                other.lastViewportPosition == lastViewportPosition));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      const DeepCollectionEquality().hash(_layers),
      cachedImageUrl,
      createdAt,
      lastModified,
      canvasSize,
      zoomLevel,
      lastViewportPosition);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      __$$ProjectModelImplCopyWithImpl<_$ProjectModelImpl>(this, _$identity);
}

abstract class _ProjectModel extends ProjectModel {
  const factory _ProjectModel(
      {required final String id,
      required final String name,
      required final List<LayerModel> layers,
      final String? cachedImageUrl,
      required final int createdAt,
      required final int lastModified,
      final Size canvasSize,
      final double zoomLevel,
      final Offset? lastViewportPosition}) = _$ProjectModelImpl;
  const _ProjectModel._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  List<LayerModel> get layers;
  @override
  String? get cachedImageUrl;
  @override
  int get createdAt;
  @override
  int get lastModified;
  @override
  Size get canvasSize;
  @override
  double get zoomLevel;
  @override
  Offset? get lastViewportPosition;
  @override
  @JsonKey(ignore: true)
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LayerModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isVisible => throw _privateConstructorUsedError;
  bool get isLocked => throw _privateConstructorUsedError;
  bool get isBackground => throw _privateConstructorUsedError;
  double get opacity => throw _privateConstructorUsedError;
  String? get imagePath =>
      throw _privateConstructorUsedError; // File path to the layer image
  List<LayerStateModel> get prevStates => throw _privateConstructorUsedError;
  List<LayerStateModel> get redoStates => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LayerModelCopyWith<LayerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LayerModelCopyWith<$Res> {
  factory $LayerModelCopyWith(
          LayerModel value, $Res Function(LayerModel) then) =
      _$LayerModelCopyWithImpl<$Res, LayerModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      bool isVisible,
      bool isLocked,
      bool isBackground,
      double opacity,
      String? imagePath,
      List<LayerStateModel> prevStates,
      List<LayerStateModel> redoStates});
}

/// @nodoc
class _$LayerModelCopyWithImpl<$Res, $Val extends LayerModel>
    implements $LayerModelCopyWith<$Res> {
  _$LayerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isVisible = null,
    Object? isLocked = null,
    Object? isBackground = null,
    Object? opacity = null,
    Object? imagePath = freezed,
    Object? prevStates = null,
    Object? redoStates = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      isBackground: null == isBackground
          ? _value.isBackground
          : isBackground // ignore: cast_nullable_to_non_nullable
              as bool,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      prevStates: null == prevStates
          ? _value.prevStates
          : prevStates // ignore: cast_nullable_to_non_nullable
              as List<LayerStateModel>,
      redoStates: null == redoStates
          ? _value.redoStates
          : redoStates // ignore: cast_nullable_to_non_nullable
              as List<LayerStateModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LayerModelImplCopyWith<$Res>
    implements $LayerModelCopyWith<$Res> {
  factory _$$LayerModelImplCopyWith(
          _$LayerModelImpl value, $Res Function(_$LayerModelImpl) then) =
      __$$LayerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      bool isVisible,
      bool isLocked,
      bool isBackground,
      double opacity,
      String? imagePath,
      List<LayerStateModel> prevStates,
      List<LayerStateModel> redoStates});
}

/// @nodoc
class __$$LayerModelImplCopyWithImpl<$Res>
    extends _$LayerModelCopyWithImpl<$Res, _$LayerModelImpl>
    implements _$$LayerModelImplCopyWith<$Res> {
  __$$LayerModelImplCopyWithImpl(
      _$LayerModelImpl _value, $Res Function(_$LayerModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isVisible = null,
    Object? isLocked = null,
    Object? isBackground = null,
    Object? opacity = null,
    Object? imagePath = freezed,
    Object? prevStates = null,
    Object? redoStates = null,
  }) {
    return _then(_$LayerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      isBackground: null == isBackground
          ? _value.isBackground
          : isBackground // ignore: cast_nullable_to_non_nullable
              as bool,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      prevStates: null == prevStates
          ? _value._prevStates
          : prevStates // ignore: cast_nullable_to_non_nullable
              as List<LayerStateModel>,
      redoStates: null == redoStates
          ? _value._redoStates
          : redoStates // ignore: cast_nullable_to_non_nullable
              as List<LayerStateModel>,
    ));
  }
}

/// @nodoc

class _$LayerModelImpl extends _LayerModel {
  const _$LayerModelImpl(
      {required this.id,
      required this.name,
      this.isVisible = true,
      this.isLocked = false,
      this.isBackground = false,
      this.opacity = 1.0,
      this.imagePath,
      final List<LayerStateModel> prevStates = const [],
      final List<LayerStateModel> redoStates = const []})
      : _prevStates = prevStates,
        _redoStates = redoStates,
        super._();

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final bool isVisible;
  @override
  @JsonKey()
  final bool isLocked;
  @override
  @JsonKey()
  final bool isBackground;
  @override
  @JsonKey()
  final double opacity;
  @override
  final String? imagePath;
// File path to the layer image
  final List<LayerStateModel> _prevStates;
// File path to the layer image
  @override
  @JsonKey()
  List<LayerStateModel> get prevStates {
    if (_prevStates is EqualUnmodifiableListView) return _prevStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prevStates);
  }

  final List<LayerStateModel> _redoStates;
  @override
  @JsonKey()
  List<LayerStateModel> get redoStates {
    if (_redoStates is EqualUnmodifiableListView) return _redoStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_redoStates);
  }

  @override
  String toString() {
    return 'LayerModel(id: $id, name: $name, isVisible: $isVisible, isLocked: $isLocked, isBackground: $isBackground, opacity: $opacity, imagePath: $imagePath, prevStates: $prevStates, redoStates: $redoStates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LayerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked) &&
            (identical(other.isBackground, isBackground) ||
                other.isBackground == isBackground) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            const DeepCollectionEquality()
                .equals(other._prevStates, _prevStates) &&
            const DeepCollectionEquality()
                .equals(other._redoStates, _redoStates));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      isVisible,
      isLocked,
      isBackground,
      opacity,
      imagePath,
      const DeepCollectionEquality().hash(_prevStates),
      const DeepCollectionEquality().hash(_redoStates));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LayerModelImplCopyWith<_$LayerModelImpl> get copyWith =>
      __$$LayerModelImplCopyWithImpl<_$LayerModelImpl>(this, _$identity);
}

abstract class _LayerModel extends LayerModel {
  const factory _LayerModel(
      {required final String id,
      required final String name,
      final bool isVisible,
      final bool isLocked,
      final bool isBackground,
      final double opacity,
      final String? imagePath,
      final List<LayerStateModel> prevStates,
      final List<LayerStateModel> redoStates}) = _$LayerModelImpl;
  const _LayerModel._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  bool get isVisible;
  @override
  bool get isLocked;
  @override
  bool get isBackground;
  @override
  double get opacity;
  @override
  String? get imagePath;
  @override // File path to the layer image
  List<LayerStateModel> get prevStates;
  @override
  List<LayerStateModel> get redoStates;
  @override
  @JsonKey(ignore: true)
  _$$LayerModelImplCopyWith<_$LayerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LayerStateModel {
  DrawingPath get drawingPath => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LayerStateModelCopyWith<LayerStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LayerStateModelCopyWith<$Res> {
  factory $LayerStateModelCopyWith(
          LayerStateModel value, $Res Function(LayerStateModel) then) =
      _$LayerStateModelCopyWithImpl<$Res, LayerStateModel>;
  @useResult
  $Res call({DrawingPath drawingPath});
}

/// @nodoc
class _$LayerStateModelCopyWithImpl<$Res, $Val extends LayerStateModel>
    implements $LayerStateModelCopyWith<$Res> {
  _$LayerStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? drawingPath = null,
  }) {
    return _then(_value.copyWith(
      drawingPath: null == drawingPath
          ? _value.drawingPath
          : drawingPath // ignore: cast_nullable_to_non_nullable
              as DrawingPath,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LayerStateModelImplCopyWith<$Res>
    implements $LayerStateModelCopyWith<$Res> {
  factory _$$LayerStateModelImplCopyWith(_$LayerStateModelImpl value,
          $Res Function(_$LayerStateModelImpl) then) =
      __$$LayerStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DrawingPath drawingPath});
}

/// @nodoc
class __$$LayerStateModelImplCopyWithImpl<$Res>
    extends _$LayerStateModelCopyWithImpl<$Res, _$LayerStateModelImpl>
    implements _$$LayerStateModelImplCopyWith<$Res> {
  __$$LayerStateModelImplCopyWithImpl(
      _$LayerStateModelImpl _value, $Res Function(_$LayerStateModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? drawingPath = null,
  }) {
    return _then(_$LayerStateModelImpl(
      drawingPath: null == drawingPath
          ? _value.drawingPath
          : drawingPath // ignore: cast_nullable_to_non_nullable
              as DrawingPath,
    ));
  }
}

/// @nodoc

class _$LayerStateModelImpl extends _LayerStateModel {
  const _$LayerStateModelImpl({required this.drawingPath}) : super._();

  @override
  final DrawingPath drawingPath;

  @override
  String toString() {
    return 'LayerStateModel(drawingPath: $drawingPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LayerStateModelImpl &&
            (identical(other.drawingPath, drawingPath) ||
                other.drawingPath == drawingPath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, drawingPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LayerStateModelImplCopyWith<_$LayerStateModelImpl> get copyWith =>
      __$$LayerStateModelImplCopyWithImpl<_$LayerStateModelImpl>(
          this, _$identity);
}

abstract class _LayerStateModel extends LayerStateModel {
  const factory _LayerStateModel({required final DrawingPath drawingPath}) =
      _$LayerStateModelImpl;
  const _LayerStateModel._() : super._();

  @override
  DrawingPath get drawingPath;
  @override
  @JsonKey(ignore: true)
  _$$LayerStateModelImplCopyWith<_$LayerStateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
