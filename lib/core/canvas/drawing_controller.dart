import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:math';

import '../../data.dart';
import '../../data/models/drawing_path.dart';
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

  bool get canUndo => paths.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void startPath(BrushData brush, Color color, double width, Offset offset) {
    currentPath = DrawingPath(
      brush: brush,
      color: color,
      width: width,
      points: [
        DrawingPoint(
          offset: offset,
          randomOffset: [],
          randomSize: null,
        )
      ],
    );
    notifyListeners();
  }

  void addPoint(Offset offset, BrushData brush, double brushSize) {
    if (currentPath != null) {
      final random = Random().nextDouble() * brush.random[1] + brush.random[0];
      final adjustedOffset = Offset(offset.dx + random, offset.dy + random);

      currentPath!.points.add(
        DrawingPoint(
          offset: adjustedOffset,
          randomOffset: [
            Random().nextDouble() +
                (brush.random.isNotEmpty
                    ? brush.random[1] + brush.random[0]
                    : 0),
            Random().nextDouble() +
                (brush.random.isNotEmpty
                    ? brush.random[1] + brush.random[0]
                    : 0),
          ],
          randomSize: brushSize,
        ),
      );
      notifyListeners();
    }
  }

  void endPath() async {
    if (currentPath != null) {
      if (currentPath!.brush.brush != null) {
        await _capturePathImage(currentPath!);
      }
      paths.add(currentPath!);
      currentPath = null;
      notifyListeners();
    }
  }

  void undo() {
    if (paths.isNotEmpty) {
      final removedPath = paths.removeLast();
      _redoStack.add(removedPath);
      notifyListeners();
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      final restoredPath = _redoStack.removeLast();
      paths.add(restoredPath);
      notifyListeners();
    }
  }

  void clear() {
    paths.clear();
    currentPath = null;
    _redoStack.clear();
    notifyListeners();
  }

  Future<void> _capturePathImage(DrawingPath path) async {
    path.image = await _renderPathsToImage(path);
    notifyListeners();
  }

  Future<ui.Image?> _renderPathsToImage(DrawingPath? drawingPath) async {
    if (drawingPath == null) return null;

    final size = MediaQuery.of(context).size;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );
    DrawingCanvas().drawPath(canvas, drawingPath);
    canvas.restore();

    final picture = recorder.endRecording();

    final image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );

    return image;
  }

  @override
  void dispose() {
    paths.clear();
    _redoStack.clear();
    super.dispose();
  }
}
