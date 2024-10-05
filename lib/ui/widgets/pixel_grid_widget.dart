import 'dart:math';

import 'package:flutter/material.dart';

enum PixelTool {
  pencil,
  fill,
  eraser,
  line,
  rectangle,
  circle,
  select,
  eyedropper,
  brush,
  mirror,
  gradient,
  rotate,
  pixelPerfectLine,
  sprayPaint,
}

enum MirrorAxis { horizontal, vertical, both }

class SelectionModel {
  final int x;
  final int y;
  final int width;
  final int height;
  final List<Point<int>> pixels;

  Rect get rect => Rect.fromLTWH(
        x.toDouble(),
        y.toDouble(),
        width.toDouble(),
        height.toDouble(),
      );

  SelectionModel({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.pixels = const [],
  });
}

class PixelGrid extends StatefulWidget {
  final int width;
  final int height;
  final List<Color> pixels;
  final Function(int x, int y) onTapPixel;
  final Function() onStartDrawing;
  final Function() onFinishDrawing;

  final Function(SelectionModel?)? onSelectionChanged;
  final Function(SelectionModel)? onMoveSelection;
  final Function(Color)? onColorPicked;
  final Function(List<Color>)? onGradientApplied;
  final Function(double)? onRotateSelection;

  final int brushSize;
  final int sprayIntensity;
  final PixelTool currentTool;
  final Color currentColor;
  final Function(List<Point<int>>) onDrawShape;

  const PixelGrid({
    super.key,
    required this.width,
    required this.height,
    required this.pixels,
    required this.onTapPixel,
    required this.currentTool,
    required this.currentColor,
    required this.onDrawShape,
    required this.onStartDrawing,
    required this.onFinishDrawing,
    this.onColorPicked,
    this.brushSize = 1,
    this.onSelectionChanged,
    this.onMoveSelection,
    this.onGradientApplied,
    this.onRotateSelection,
    this.sprayIntensity = 5,
  });

  @override
  _PixelGridState createState() => _PixelGridState();
}

class _PixelGridState extends State<PixelGrid> {
  final _boxKey = GlobalKey();

  Offset? _previousPosition;

  Offset? _startPosition;
  Offset? _currentPosition;
  List<Point<int>> _previewPixels = [];

  Rect? _selectionRect;
  bool _isDraggingSelection = false;
  Offset? _selectionStart;
  Offset? _selectionCurrent;
  List<MapEntry<Point<int>, Color>>? _selectedPixels;

  Offset? _gradientStart;
  Offset? _gradientEnd;

  Offset _dragOffset = Offset.zero;

  RenderBox get renderBox =>
      _boxKey.currentContext!.findRenderObject() as RenderBox;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _boxKey,
      child: GestureDetector(
        onPanStart: (details) {
          if (widget.currentTool == PixelTool.select) {
            if (_isPointInsideSelection(details.localPosition)) {
              _startDraggingSelection(details.localPosition);
            } else {
              _startSelection(details.localPosition);
            }
          } else if (widget.currentTool == PixelTool.eyedropper) {
            _handleEyedropper(details.localPosition);
          } else if (widget.currentTool == PixelTool.gradient) {
            _startGradient(details.localPosition);
          } else {
            widget.onStartDrawing();
            _startDrawing(details.localPosition);
          }
        },
        onPanUpdate: (details) {
          if (widget.currentTool == PixelTool.select) {
            if (_isDraggingSelection) {
              _updateDraggingSelection(details.delta);
            } else if (widget.currentTool == PixelTool.eyedropper) {
              _handleEyedropper(details.localPosition);
            } else {
              _updateSelection(details.localPosition);
            }
          } else if (widget.currentTool == PixelTool.gradient) {
            _updateGradient(details.localPosition);
          } else {
            _updateDrawing(details.localPosition);
          }
        },
        onPanEnd: (details) {
          if (widget.currentTool == PixelTool.select) {
            if (_isDraggingSelection) {
              _endDraggingSelection();
            } else {
              _endSelection();
            }
          } else if (widget.currentTool == PixelTool.gradient) {
            _endGradient();
          } else {
            _endDrawing();
            widget.onFinishDrawing();
          }
        },
        onTapDown: (details) {
          if (widget.currentTool == PixelTool.fill) {
            widget.onTapPixel(
              (details.localPosition.dx / renderBox.size.width * widget.width)
                  .floor(),
              (details.localPosition.dy / renderBox.size.height * widget.height)
                  .floor(),
            );
          } else if (widget.currentTool == PixelTool.eyedropper) {
            _handleEyedropper(details.localPosition);
          } else if (widget.currentTool == PixelTool.select) {
            if (!_isPointInsideSelection(details.localPosition)) {
              _startSelection(details.localPosition);
            }
          } else {
            widget.onStartDrawing();
            _startDrawing(details.localPosition);
          }
        },
        onTapUp: (details) {
          _endDrawing();
          widget.onFinishDrawing();
        },
        child: CustomPaint(
          painter: _PixelGridPainter(
            width: widget.width,
            height: widget.height,
            pixels: widget.pixels,
            previewPixels: _previewPixels,
            previewColor: widget.currentColor,
            selectionRect: _selectionRect,
            gradientStart: _gradientStart,
            gradientEnd: _gradientEnd,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }

  void _handleEyedropper(Offset position) {
    final pixelWidth = renderBox.size.width / widget.width;
    final pixelHeight = renderBox.size.height / widget.height;

    final x = (position.dx / pixelWidth).floor();
    final y = (position.dy / pixelHeight).floor();

    if (x >= 0 && x < widget.width && y >= 0 && y < widget.height) {
      final pickedColor = widget.pixels[y * widget.width + x];
      widget.onColorPicked?.call(pickedColor);
    }
  }

  void _startGradient(Offset position) {
    setState(() {
      _gradientStart = position;
      _gradientEnd = position;
    });
  }

  void _updateGradient(Offset position) {
    setState(() {
      _gradientEnd = position;
    });
  }

  void _endGradient() {
    if (_gradientStart != null && _gradientEnd != null) {
      final pixelWidth = renderBox.size.width / widget.width;
      final pixelHeight = renderBox.size.height / widget.height;

      final startX = (_gradientStart!.dx / pixelWidth).floor();
      final startY = (_gradientStart!.dy / pixelHeight).floor();
      final endX = (_gradientEnd!.dx / pixelWidth).floor();
      final endY = (_gradientEnd!.dy / pixelHeight).floor();

      final gradientColors =
          _generateGradientColors(startX, startY, endX, endY);
      widget.onGradientApplied?.call(gradientColors);
    }

    setState(() {
      _gradientStart = null;
      _gradientEnd = null;
    });
  }

  List<Color> _generateGradientColors(
    int startX,
    int startY,
    int endX,
    int endY,
  ) {
    final gradientColors =
        List<Color>.filled(widget.width * widget.height, Colors.transparent);
    final gradient = LinearGradient(
      begin: Alignment(startX / widget.width, startY / widget.height),
      end: Alignment(endX / widget.width, endY / widget.height),
      colors: [widget.currentColor, Colors.transparent],
    );

    for (int y = 0; y < widget.height; y++) {
      for (int x = 0; x < widget.width; x++) {
        final t = (x - startX) / (endX - startX);
        gradientColors[y * widget.width + x] =
            gradient.colors[0].withOpacity(1 - t);
      }
    }

    return gradientColors;
  }

  bool _isPointInsideSelection(Offset point) {
    if (_selectionRect == null) return false;
    return _selectionRect!.contains(point);
  }

  void _startDraggingSelection(Offset position) {
    setState(() {
      _isDraggingSelection = true;
      _dragOffset = Offset.zero;
    });
  }

  void _updateDraggingSelection(Offset delta) {
    final boxSize = context.size!;
    final pixelWidth = boxSize.width / widget.width;
    final pixelHeight = boxSize.height / widget.height;

    // Accumulate the delta movement
    _dragOffset += delta;

    // Calculate the integer pixel movement
    final dx = (_dragOffset.dx / pixelWidth).round();
    final dy = (_dragOffset.dy / pixelHeight).round();

    if (dx != 0 || dy != 0) {
      // Update the selection rectangle
      setState(() {
        _selectionRect =
            _selectionRect!.shift(Offset(dx * pixelWidth, dy * pixelHeight));
        _dragOffset = Offset(_dragOffset.dx - dx * pixelWidth,
            _dragOffset.dy - dy * pixelHeight);

        // Create a new SelectionModel
        final newSelectionModel = SelectionModel(
          x: _selectionRect!.left ~/ pixelWidth,
          y: _selectionRect!.top ~/ pixelHeight,
          width: _selectionRect!.width ~/ pixelWidth,
          height: _selectionRect!.height ~/ pixelHeight,
        );

        // Call the controller to move the selection
        widget.onMoveSelection?.call(newSelectionModel);
      });
    }
  }

  void _endDraggingSelection() {
    setState(() {
      _isDraggingSelection = false;
      _dragOffset = Offset.zero;
    });
  }

  void _startSelection(Offset position) {
    setState(() {
      _selectionStart = position;
      _selectionCurrent = position;
      _selectionRect = Rect.fromPoints(_selectionStart!, _selectionCurrent!);

      _selectedPixels = null;
      _isDraggingSelection = false;

      widget.onSelectionChanged?.call(null);
    });
  }

  void _updateSelection(Offset position) {
    setState(() {
      _selectionCurrent = position;
      _selectionRect = Rect.fromPoints(_selectionStart!, _selectionCurrent!);
    });
  }

  void _startDrawing(Offset position) {
    _startPosition = position;
    _handleDrawing(position);
  }

  void _updateDrawing(Offset position) {
    _currentPosition = position;
    _handleDrawing(position);
  }

  void _endSelection() {
    final boxSize = context.size!;
    final pixelWidth = boxSize.width / widget.width;
    final pixelHeight = boxSize.height / widget.height;

    if (_selectionRect == null) return;
    if (_selectionRect!.width < pixelWidth ||
        _selectionRect!.height < pixelHeight) {
      setState(() {
        _selectionRect = null;
      });
      return;
    }

    int x0 = (_selectionRect!.left / pixelWidth).floor();
    int y0 = (_selectionRect!.top / pixelHeight).floor();
    int x1 = (_selectionRect!.right / pixelWidth).ceil();
    int y1 = (_selectionRect!.bottom / pixelHeight).ceil();

    // Extract the selected pixels
    List<MapEntry<Point<int>, Color>> selectedPixels = [];
    for (int y = y0; y < y1; y++) {
      for (int x = x0; x < x1; x++) {
        final color = widget.pixels[y * widget.width + x];
        selectedPixels.add(MapEntry(Point(x, y), color));
      }
    }

    x0 = x0.clamp(0, widget.width - 1);
    y0 = y0.clamp(0, widget.height - 1);
    x1 = x1.clamp(0, widget.width);
    y1 = y1.clamp(0, widget.height);

    setState(() {
      _selectedPixels = selectedPixels;
      _isDraggingSelection = true;
    });

    widget.onSelectionChanged?.call(SelectionModel(
      x: x0,
      y: y0,
      width: x1 - x0,
      height: y1 - y0,
    ));
  }

  void _endDrawing() {
    if (widget.currentTool == PixelTool.line ||
        widget.currentTool == PixelTool.rectangle ||
        widget.currentTool == PixelTool.circle) {
      widget.onDrawShape(_previewPixels);
    }
    _previewPixels.clear();
    _previousPosition = null;
    _startPosition = null;
    _currentPosition = null;
    setState(() {});
  }

  void _handleDrawing(Offset position) {
    final pixelWidth = renderBox.size.width / widget.width;
    final pixelHeight = renderBox.size.height / widget.height;

    final x = (position.dx / pixelWidth).floor();
    final y = (position.dy / pixelHeight).floor();

    if (x >= 0 && x < widget.width && y >= 0 && y < widget.height) {
      if (widget.currentTool == PixelTool.pencil ||
          widget.currentTool == PixelTool.eraser) {
        if (_previousPosition != null) {
          final previousX = (_previousPosition!.dx / pixelWidth).floor();
          final previousY = (_previousPosition!.dy / pixelHeight).floor();
          _drawLine(previousX, previousY, x, y);
        } else {
          widget.onTapPixel(x, y);
        }
        _previousPosition = position;
      } else if (widget.currentTool == PixelTool.line) {
        if (_startPosition != null && _currentPosition != null) {
          final startX = (_startPosition!.dx / pixelWidth).floor();
          final startY = (_startPosition!.dy / pixelHeight).floor();
          _previewPixels = _getLinePixels(startX, startY, x, y);
          setState(() {});
        }
      } else if (widget.currentTool == PixelTool.rectangle) {
        if (_startPosition != null && _currentPosition != null) {
          final startX = (_startPosition!.dx / pixelWidth).floor();
          final startY = (_startPosition!.dy / pixelHeight).floor();
          _previewPixels = _getRectanglePixels(startX, startY, x, y);
          setState(() {});
        }
      } else if (widget.currentTool == PixelTool.circle) {
        if (_startPosition != null && _currentPosition != null) {
          final startX = (_startPosition!.dx / pixelWidth).floor();
          final startY = (_startPosition!.dy / pixelHeight).floor();
          _previewPixels = _getCirclePixels(startX, startY, x, y);
          setState(() {});
        }
      } else if (widget.currentTool == PixelTool.brush) {
        print('Brush size: ${widget.brushSize}');
        final brushSize =
            widget.currentTool == PixelTool.brush ? widget.brushSize : 1;
        final centerX = x;
        final centerY = y;

        for (int i = -brushSize; i <= brushSize; i++) {
          for (int j = -brushSize; j <= brushSize; j++) {
            final brushX = centerX + i;
            final brushY = centerY + j;
            if (brushX >= 0 &&
                brushX < widget.width &&
                brushY >= 0 &&
                brushY < widget.height) {
              widget.onTapPixel(brushX, brushY);
            }
          }
        }
      } else if (widget.currentTool == PixelTool.mirror) {
        _drawMirror(x, y);
      }
    }
  }

  void _drawMirror(int x, int y) {
    widget.onTapPixel(x, y);
    final mirrorX = widget.width - 1 - x;
    widget.onTapPixel(mirrorX, y);
  }

  List<Point<int>> _getLinePixels(int x0, int y0, int x1, int y1) {
    final pixels = <Point<int>>[];

    int dx = (x1 - x0).abs();
    int dy = -(y1 - y0).abs();
    int sx = x0 < x1 ? 1 : -1;
    int sy = y0 < y1 ? 1 : -1;
    int err = dx + dy;

    int x = x0;
    int y = y0;

    while (true) {
      if (x >= 0 && x < widget.width && y >= 0 && y < widget.height) {
        pixels.add(Point(x, y));
      }

      if (x == x1 && y == y1) break;

      int e2 = 2 * err;
      if (e2 >= dy) {
        err += dy;
        x += sx;
      }
      if (e2 <= dx) {
        err += dx;
        y += sy;
      }
    }

    return pixels;
  }

  List<Point<int>> _getRectanglePixels(int x0, int y0, int x1, int y1) {
    final pixels = <Point<int>>[];

    int left = min(x0, x1);
    int right = max(x0, x1);
    int top = min(y0, y1);
    int bottom = max(y0, y1);

    // Top and bottom edges
    for (int x = left; x <= right; x++) {
      if (top >= 0 && top < widget.height) {
        if (x >= 0 && x < widget.width) pixels.add(Point(x, top));
      }
      if (bottom >= 0 && bottom < widget.height && top != bottom) {
        if (x >= 0 && x < widget.width) pixels.add(Point(x, bottom));
      }
    }

    // Left and right edges
    for (int y = top + 1; y < bottom; y++) {
      if (left >= 0 && left < widget.width) {
        if (y >= 0 && y < widget.height) pixels.add(Point(left, y));
      }
      if (right >= 0 && right < widget.width && left != right) {
        if (y >= 0 && y < widget.height) pixels.add(Point(right, y));
      }
    }

    return pixels;
  }

  List<Point<int>> _getCirclePixels(int x0, int y0, int x1, int y1) {
    final pixels = <Point<int>>[];

    int dx = x1 - x0;
    int dy = y1 - y0;
    int radius = sqrt(dx * dx + dy * dy).round();

    int f = 1 - radius;
    int ddF_x = 0;
    int ddF_y = -2 * radius;
    int x = 0;
    int y = radius;

    _addCirclePoints(pixels, x0, y0, x, y);

    while (x < y) {
      if (f >= 0) {
        y--;
        ddF_y += 2;
        f += ddF_y;
      }
      x++;
      ddF_x += 2;
      f += ddF_x + 1;

      _addCirclePoints(pixels, x0, y0, x, y);
    }

    return pixels;
  }

  void _addCirclePoints(List<Point<int>> pixels, int x0, int y0, int x, int y) {
    List<Point<int>> points = [
      Point(x0 + x, y0 + y),
      Point(x0 - x, y0 + y),
      Point(x0 + x, y0 - y),
      Point(x0 - x, y0 - y),
      Point(x0 + y, y0 + x),
      Point(x0 - y, y0 + x),
      Point(x0 + y, y0 - x),
      Point(x0 - y, y0 - x),
    ];

    for (var point in points) {
      if (point.x >= 0 &&
          point.x < widget.width &&
          point.y >= 0 &&
          point.y < widget.height) {
        pixels.add(point);
      }
    }
  }

  void _drawLine(int x0, int y0, int x1, int y1) {
    // Implement Bresenham's line algorithm
    int dx = (x1 - x0).abs();
    int dy = (y1 - y0).abs();
    int sx = x0 < x1 ? 1 : -1;
    int sy = y0 < y1 ? 1 : -1;
    int err = dx - dy;

    while (true) {
      widget.onTapPixel(x0, y0);

      if (x0 == x1 && y0 == y1) break;
      int e2 = 2 * err;
      if (e2 > -dy) {
        err -= dy;
        x0 += sx;
      }
      if (e2 < dx) {
        err += dx;
        y0 += sy;
      }
    }
  }

  bool _isPointInsideRect(Offset point, Rect rect) {
    return rect.contains(point);
  }
}

class _PixelGridPainter extends CustomPainter {
  final int width;
  final int height;
  final List<Color> pixels;
  final List<Point<int>> previewPixels;
  final Color previewColor;
  final Rect? selectionRect;
  final Offset? gradientStart;
  final Offset? gradientEnd;

  _PixelGridPainter({
    required this.width,
    required this.height,
    required this.pixels,
    this.previewPixels = const [],
    this.previewColor = Colors.black,
    this.selectionRect,
    this.gradientStart,
    this.gradientEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pixelWidth = size.width / width;
    final pixelHeight = size.height / height;

    // Draw existing pixels
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (pixels[y * width + x] == Colors.transparent) continue;

        final pixelColor = pixels[y * width + x];
        final rect = Rect.fromLTWH(
          x * pixelWidth,
          y * pixelHeight,
          pixelWidth,
          pixelHeight,
        );
        canvas.drawRect(rect, Paint()..color = pixelColor);
      }
    }

    // Draw preview pixels
    for (final point in previewPixels) {
      if (point.x >= 0 && point.x < width && point.y >= 0 && point.y < height) {
        final rect = Rect.fromLTWH(
          point.x * pixelWidth,
          point.y * pixelHeight,
          pixelWidth,
          pixelHeight,
        );
        canvas.drawRect(rect, Paint()..color = previewColor.withOpacity(0.5));
      }
    }

    if (selectionRect != null &&
        selectionRect!.width > 0 &&
        selectionRect!.height > 0) {
      final rect = Rect.fromLTWH(
        selectionRect!.left,
        selectionRect!.top,
        selectionRect!.width,
        selectionRect!.height,
      );
      canvas.drawRect(
        rect,
        Paint()
          ..color = Colors.blueAccent.withOpacity(0.3)
          ..style = PaintingStyle.fill,
      );
      canvas.drawRect(
        rect,
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

      const handleSize = 8.0;
      final handlePaint = Paint()..color = Colors.blue;

      final handleTopLeft = Rect.fromLTWH(
        selectionRect!.left - handleSize / 2,
        selectionRect!.top - handleSize / 2,
        handleSize,
        handleSize,
      );
      canvas.drawRect(handleTopLeft, handlePaint);

      final handleTopRight = Rect.fromLTWH(
        selectionRect!.right - handleSize / 2,
        selectionRect!.top - handleSize / 2,
        handleSize,
        handleSize,
      );

      canvas.drawRect(handleTopRight, handlePaint);

      final handleBottomLeft = Rect.fromLTWH(
        selectionRect!.left - handleSize / 2,
        selectionRect!.bottom - handleSize / 2,
        handleSize,
        handleSize,
      );

      canvas.drawRect(handleBottomLeft, handlePaint);

      final handleBottomRight = Rect.fromLTWH(
        selectionRect!.right - handleSize / 2,
        selectionRect!.bottom - handleSize / 2,
        handleSize,
        handleSize,
      );

      canvas.drawRect(handleBottomRight, handlePaint);
    }

    if (gradientStart != null && gradientEnd != null) {
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment(
            gradientStart!.dx / size.width,
            gradientStart!.dy / size.height,
          ),
          end: Alignment(
            gradientEnd!.dx / size.width,
            gradientEnd!.dy / size.height,
          ),
          colors: [Colors.black, Colors.transparent],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        gradientPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
