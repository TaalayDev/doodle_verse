import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';

import '../../data.dart';
import '../../data/models/drawing_path.dart';
import 'dirty_region_tracker.dart';
import 'drawing_canvas.dart';

class LayerCacheImage extends Equatable {
  final int id;
  final ui.Image image;
  final bool isVisible;
  final bool isDirty;

  const LayerCacheImage(
    this.id,
    this.image, {
    this.isVisible = true,
    this.isDirty = true,
  });

  LayerCacheImage copyWith({
    int? id,
    ui.Image? image,
    bool? isVisible,
    bool? isDirty,
  }) {
    return LayerCacheImage(
      id ?? this.id,
      image ?? this.image,
      isVisible: isVisible ?? this.isVisible,
      isDirty: isDirty ?? this.isDirty,
    );
  }

  @override
  List<Object?> get props => [id];
}

class DrawState extends Equatable {
  final List<LayerModel> layers;
  final int currentLayerIndex;
  final List<LayerCacheImage> layersCache;

  const DrawState({
    required this.layers,
    required this.currentLayerIndex,
    this.layersCache = const [],
  });

  LayerModel get currentLayer => layers[currentLayerIndex];

  DrawState copyWith({
    List<LayerModel>? layers,
    int? currentLayerIndex,
    List<LayerCacheImage>? layersCache,
  }) {
    return DrawState(
      layers: layers ?? this.layers,
      currentLayerIndex: currentLayerIndex ?? this.currentLayerIndex,
      layersCache: layersCache ?? this.layersCache,
    );
  }

  @override
  List<Object?> get props => [layers, currentLayerIndex, layersCache];
}

class DrawingController {
  DrawingController(
    this.context, {
    this.currentPath,
    ProjectModel? project,
  }) {
    if (project != null) {
      loadState(project);
    }
  }

  final DrawingCanvas drawingCanvas = DrawingCanvas();
  late Function() notifyListeners = () {};

  final BuildContext context;
  DrawState _currentState = const DrawState(layers: [], currentLayerIndex: 0);
  final List<DrawState> _undoStates = [];
  final List<DrawState> _redoStates = [];
  DrawingPath? currentPath;
  ui.Image? _currentPathImage;

  bool isDirty = true;

  List<LayerCacheImage> get cachedImages => _currentState.layersCache;

  int get currentLayerIndex => _currentState.currentLayerIndex;
  LayerModel get currentLayer =>
      _currentState.layers[_currentState.currentLayerIndex];
  DrawState get currentState => _currentState;

  final DirtyRegionTracker dirtyRegionTracker = DirtyRegionTracker();

  final double devicePixelRatio =
      WidgetsBinding.instance.window.devicePixelRatio;

  bool get canUndo => _undoStates.isNotEmpty;
  bool get canRedo => _redoStates.isNotEmpty;

  Offset _prevPosition = Offset.zero;
  Offset _currentPosition = Offset.zero;

  ui.Image? get currentPathImage => _currentPathImage;

  void startPath(BrushData brush, Color color, double width, Offset offset) {
    _prevPosition = offset;

    currentPath = DrawingPath(
      Path()..moveTo(offset.dx, offset.dy),
      brush: brush,
      color: color,
      width: width,
      points: [offset],
      startPoint: offset,
    );
    dirtyRegionTracker.addPath(currentPath!);
    notifyListeners();
  }

  void addPoint(Offset offset, BrushData brush, double brushSize) {
    if (currentPath != null) {
      _currentPosition = offset;
      currentPath = currentPath!.copyWith(
        points: [...currentPath!.points, offset],
        endPoint: offset,
      );

      final lerpX = _prevPosition.dx + (offset.dx - _prevPosition.dx) / 2;
      final lerpY = _prevPosition.dy + (offset.dy - _prevPosition.dy) / 2;

      currentPath!.path.quadraticBezierTo(
        _prevPosition.dx,
        _prevPosition.dy,
        lerpX,
        lerpY,
      );

      dirtyRegionTracker.addPath(currentPath!);
      notifyListeners();
    }
  }

  void currentPathCached(ui.Image image) {
    _currentPathImage = image;
    if (currentPath != null) {
      final lerpX =
          _prevPosition.dx + (_currentPosition.dx - _prevPosition.dx) / 2;
      final lerpY =
          _prevPosition.dy + (_currentPosition.dy - _prevPosition.dy) / 2;

      currentPath?.path.reset();
      currentPath?.path.moveTo(lerpX, lerpY);
      _prevPosition = _currentPosition;
    }
    notifyListeners();
  }

  void endPath() async {
    if (currentPath case var path?) {
      var updatedLayer = _currentState.currentLayer.copyWith(
        states: [
          ..._currentState.currentLayer.states,
          LayerStateModel(
            id: _currentState.currentLayer.states.length,
            drawingPath: path,
          ),
        ],
      );
      var updatedLayers = List<LayerModel>.from(_currentState.layers);
      updatedLayers[_currentState.currentLayerIndex] = updatedLayer;

      _undoStates.add(_currentState);
      _currentState = _currentState.copyWith(layers: updatedLayers);
      _redoStates.clear();

      currentPath = null;
      _prevPosition = Offset.zero;
      _currentPosition = Offset.zero;
      isDirty = true;
      notifyListeners();
    }
  }

  void undo() {
    if (canUndo) return;
    _redoStates.add(_currentState);
    _currentState = _undoStates.removeLast();
    isDirty = true;
    notifyListeners();
  }

  void redo() {
    if (canRedo) return;
    _undoStates.add(_currentState);
    _currentState = _redoStates.removeLast();
    isDirty = true;
    notifyListeners();
  }

  void clear() {
    _undoStates.add(_currentState);
    _redoStates.clear();
    currentPath = null;
    dirtyRegionTracker.clear();
    notifyListeners();
  }

  Rect? getDirtyRegion() {
    return dirtyRegionTracker.getBoundingBox();
  }

  void clearDirtyRegions() {
    dirtyRegionTracker.clear();
  }

  void loadState(ProjectModel project) {
    _currentState = DrawState(
      layers: project.layers,
      currentLayerIndex: project.layers.length - 1,
    );
  }

  void updateLayerCache(Size size, Rect? region) {
    for (var i = 0; i < _currentState.layers.length; i++) {
      final layer = _currentState.layers[i];
      if (!layer.isVisible) {
        continue;
      }
      final cache = _currentState.layersCache.firstWhereOrNull(
        (cache) => cache.id == layer.id,
      );
      if (cache == null ||
          cache.isDirty == true ||
          layer.id == currentLayer.id) {
        _updateLayerCache(size, layer, region);
      }
    }
    _updateCache(size);
  }

  void _setLayerCacheVisibility(int layerId, bool isVisible) {
    final updatedCache = _currentState.layersCache.map((cache) {
      if (cache.id == layerId) {
        return cache.copyWith(isVisible: isVisible, isDirty: true);
      }
      return cache;
    }).toList();

    _currentState = _currentState.copyWith(layersCache: updatedCache);
    notifyListeners();
  }

  void _removeLayerCache(int layerId) {
    final updatedCache = _currentState.layersCache
        .where((cache) => cache.id != layerId)
        .toList();

    _currentState = _currentState.copyWith(layersCache: updatedCache);
    notifyListeners();
  }

  void _updateLayerCache(
    Size size,
    LayerModel layer,
    Rect? region,
  ) {
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

    final layerCache = _currentState.layersCache.firstWhereOrNull(
      (cache) => cache.id == layer.id,
    );
    if (layerCache != null) {
      canvas.drawImage(layerCache.image, Offset.zero, Paint());
      if (_currentPathImage != null && layer.id == currentLayer.id) {
        canvas.drawImage(_currentPathImage!, Offset.zero, Paint());
      }
      _currentPathImage = null;
    } else {
      final paths = layer.states.map((state) => state.drawingPath).toList();
      for (final path in paths) {
        drawingCanvas.drawPath(canvas, size, path);
      }
    }

    canvas.restore();

    final picture = recorder.endRecording();
    final image = picture.toImageSync(
      width.toInt(),
      height.toInt(),
    );

    final index = _currentState.layersCache.indexWhere((cache) {
      return cache.id == layer.id;
    });
    if (index != -1) {
      final updatedCache = List<LayerCacheImage>.from(
        _currentState.layersCache,
      );
      updatedCache[index] = updatedCache[index].copyWith(
        image: image,
        isDirty: false,
      );
      _currentState = _currentState.copyWith(layersCache: updatedCache);
    } else {
      _currentState = _currentState.copyWith(
        layersCache: [
          ..._currentState.layersCache,
          LayerCacheImage(layer.id, image),
        ],
      );
    }
  }

  void _updateCache(Size size) {
    _currentState = _currentState.copyWith();
    isDirty = false;
  }

  // Layer
  void setActiveLayer(int index) {
    _currentState = _currentState.copyWith(currentLayerIndex: index);
    isDirty = true;
    notifyListeners();
  }

  void setLayerVisibility(int index, bool isVisible) {
    final updatedLayer =
        _currentState.layers[index].copyWith(isVisible: isVisible);
    final updatedLayers = List<LayerModel>.from(_currentState.layers);
    updatedLayers[index] = updatedLayer;

    _currentState = _currentState.copyWith(
      layers: updatedLayers,
    );
    _setLayerCacheVisibility(updatedLayer.id, isVisible);

    isDirty = true;
    notifyListeners();
  }

  void addLayer(LayerModel layer) {
    _currentState = _currentState.copyWith(
      layers: [..._currentState.layers, layer],
      currentLayerIndex: _currentState.layers.length,
    );
    isDirty = true;
    notifyListeners();
  }

  void deleteLayer(int index) {
    _removeLayerCache(_currentState.layers[index].id);
    _currentState = _currentState.copyWith(
      layers: List<LayerModel>.from(_currentState.layers)..removeAt(index),
      currentLayerIndex: 0,
    );
    isDirty = true;
    notifyListeners();
  }

  void updateLayer(LayerModel layer) {
    final updatedLayers = List<LayerModel>.from(_currentState.layers);
    updatedLayers[_currentState.currentLayerIndex] = layer;

    _currentState = _currentState.copyWith(layers: updatedLayers);
    notifyListeners();
  }

  void dispose() {
    _undoStates.clear();
    _redoStates.clear();
  }
}
