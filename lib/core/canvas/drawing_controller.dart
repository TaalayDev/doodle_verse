import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

import '../../data.dart';
import '../../data/models/drawing_path.dart';
import 'dirty_region_tracker.dart';
import 'drawing_canvas.dart';

class DrawingController extends ChangeNotifier {
  DrawingController(
    this.context, {
    this.currentPath,
  });

  final BuildContext context;
  final List<DrawingPath> paths = [];
  final List<DrawingPath> _redoStack = [];
  DrawingPath? currentPath;
  ui.Image? _cachedImage;
  ui.Image? get cachedImage => _cachedImage;
  set cachedImage(ui.Image? image) {
    _cachedImage = image;
  }

  int lastPathsLength = 0;

  final DirtyRegionTracker dirtyRegionTracker = DirtyRegionTracker();

  final double devicePixelRatio =
      WidgetsBinding.instance.window.devicePixelRatio;

  bool get canUndo => paths.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

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
      paths.add(path);
      currentPath = null;
      _redoStack.clear();
      _updateTilesForPath(paths.last);
      notifyListeners();
    }
  }

  void _updateTilesForPath(DrawingPath path) {}

  void undo() {
    if (paths.isNotEmpty) {
      final removedPath = paths.removeLast();
      _redoStack.add(removedPath);
      _updateTilesForPath(removedPath);
      notifyListeners();
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      final restoredPath = _redoStack.removeLast();
      paths.add(restoredPath);
      _updateTilesForPath(restoredPath);
      notifyListeners();
    }
  }

  void clear() {
    paths.clear();
    currentPath = null;
    _redoStack.clear();
    notifyListeners();
  }

  Rect? getDirtyRegion() {
    return dirtyRegionTracker.getBoundingBox();
  }

  void clearDirtyRegions() {
    dirtyRegionTracker.clear();
  }

  void loadStates(List<DrawingPath> newPaths, List<DrawingPath> redoPaths) {
    paths.addAll(newPaths);
    _redoStack.addAll(redoPaths);
    _rebuildTileCache();
    notifyListeners();
  }

  void _rebuildTileCache() {
    for (var path in paths) {
      _updateTilesForPath(path);
    }
  }

  @override
  void dispose() {
    paths.clear();
    _redoStack.clear();
    super.dispose();
  }
}
