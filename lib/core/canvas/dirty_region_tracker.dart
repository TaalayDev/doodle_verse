import 'dart:ui';
import '../../data/models/drawing_path.dart';

class DirtyRegionTracker {
  List<Rect> _dirtyRegions = [];

  void addDirtyRegion(Rect region) {
    _dirtyRegions.add(region);
  }

  void addPath(DrawingPath path) {
    if (path.points.isEmpty) return;

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (var point in path.points) {
      minX = minX < point.dx ? minX : point.dx;
      minY = minY < point.dy ? minY : point.dy;
      maxX = maxX > point.dx ? maxX : point.dx;
      maxY = maxY > point.dy ? maxY : point.dy;
    }

    // Add some padding to the region to account for stroke width
    final padding = path.width / 2;
    addDirtyRegion(Rect.fromLTRB(
      minX - padding,
      minY - padding,
      maxX + padding,
      maxY + padding,
    ));
  }

  List<Rect> getDirtyRegions() {
    return _dirtyRegions;
  }

  void clear() {
    _dirtyRegions.clear();
  }

  Rect? getBoundingBox() {
    if (_dirtyRegions.isEmpty) return null;

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (var region in _dirtyRegions) {
      minX = minX < region.left ? minX : region.left;
      minY = minY < region.top ? minY : region.top;
      maxX = maxX > region.right ? maxX : region.right;
      maxY = maxY > region.bottom ? maxY : region.bottom;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}
