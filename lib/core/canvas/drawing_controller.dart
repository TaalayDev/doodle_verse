import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../data.dart';
import '../../data/models/drawing_path.dart';
import 'dirty_region_tracker.dart';
import 'drawing_canvas.dart';

class DrawState {
  final List<LayerModel> layers;
  final int currentLayerIndex;
  final Map<int, ui.Image> layersCache;
  final ui.Image? compositeCache;

  DrawState({
    required this.layers,
    required this.currentLayerIndex,
    this.layersCache = const {},
    this.compositeCache,
  });

  LayerModel get currentLayer => layers[currentLayerIndex];

  DrawState copyWith({
    List<LayerModel>? layers,
    int? currentLayerIndex,
    Map<int, ui.Image>? layersCache,
    ui.Image? compositeCache,
  }) {
    return DrawState(
      layers: layers ?? this.layers,
      currentLayerIndex: currentLayerIndex ?? this.currentLayerIndex,
      layersCache: layersCache ?? this.layersCache,
      compositeCache: compositeCache ?? this.compositeCache,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DrawState &&
        listEquals(other.layers, layers) &&
        other.currentLayerIndex == currentLayerIndex &&
        mapEquals(other.layersCache, layersCache) &&
        other.compositeCache == compositeCache;
  }

  @override
  int get hashCode =>
      layers.hashCode ^
      currentLayerIndex.hashCode ^
      layersCache.hashCode ^
      compositeCache.hashCode;
}

class DrawingController extends ChangeNotifier {
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

  final BuildContext context;
  DrawState _currentState = DrawState(layers: [], currentLayerIndex: 0);
  final List<DrawState> _undoStates = [];
  final List<DrawState> _redoStates = [];
  DrawingPath? currentPath;
  bool isDirty = true;

  ui.Image? get cachedImage => _currentState.compositeCache;

  int get currentLayerIndex => _currentState.currentLayerIndex;
  LayerModel get currentLayer =>
      _currentState.layers[_currentState.currentLayerIndex];
  DrawState get currentState => _currentState;

  final DirtyRegionTracker dirtyRegionTracker = DirtyRegionTracker();

  final double devicePixelRatio =
      WidgetsBinding.instance.window.devicePixelRatio;

  bool get canUndo => _undoStates.isNotEmpty;
  bool get canRedo => _redoStates.isNotEmpty;

  void startPath(BrushData brush, Color color, double width, Offset offset) {
    currentPath = DrawingPath(
      brush: brush,
      color: color,
      width: width,
      points: [offset],
    );
    dirtyRegionTracker.addPath(currentPath!);
    notifyListeners();
  }

  void addPoint(Offset offset, BrushData brush, double brushSize) {
    if (currentPath != null) {
      currentPath!.points.add(offset);

      dirtyRegionTracker.addPath(currentPath!);
      notifyListeners();
    }
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

      isDirty = true;
      currentPath = null;
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
    for (var layer in _currentState.layers) {
      _updateLayerCache(size, layer, region);
    }
    _updateCache(size);
  }

  void _updateLayerCache(
    Size size,
    LayerModel layer,
    Rect? region,
  ) async {
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

    final paths = layer.states.map((e) => e.drawingPath).toList();

    for (var path in paths) {
      drawingCanvas.drawPath(canvas, size, path);
    }

    canvas.restore();

    final picture = recorder.endRecording();
    final image = picture.toImageSync(
      width.toInt(),
      height.toInt(),
    );

    _currentState = _currentState.copyWith(
      layersCache: {
        ..._currentState.layersCache,
        layer.id: image,
      },
    );
  }

  void _updateCache(Size size) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final width = size.width;
    final height = size.height;
    canvas.saveLayer(
      Rect.fromLTWH(0, 0, width, height),
      Paint()..isAntiAlias = true,
    );

    for (var image in _currentState.layersCache.values) {
      canvas.drawImage(image, Offset.zero, Paint());
    }

    canvas.restore();

    final picture = recorder.endRecording();
    final image = picture.toImageSync(
      width.toInt(),
      height.toInt(),
    );

    _currentState = _currentState.copyWith(compositeCache: image);
    isDirty = false;
  }

  // Layer
  void setActiveLayer(int index) {
    _currentState = _currentState.copyWith(currentLayerIndex: index);
    notifyListeners();
  }

  void setLayerVisibility(int index, bool isVisible) {
    final updatedLayer =
        _currentState.layers[index].copyWith(isVisible: isVisible);
    final updatedLayers = List<LayerModel>.from(_currentState.layers);
    updatedLayers[index] = updatedLayer;

    _currentState = _currentState.copyWith(layers: updatedLayers);
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

  @override
  void dispose() {
    _undoStates.clear();
    _redoStates.clear();
    super.dispose();
  }
}
