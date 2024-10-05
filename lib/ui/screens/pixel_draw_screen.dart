import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/pixel_grid_widget.dart';

final pixelDrawProvider = ChangeNotifierProvider.autoDispose(
  (ref) => PixelDrawingController(width: 256, height: 256),
);

class PixelDrawingController extends ChangeNotifier {
  late int width;
  late int height;
  late List<Color> pixels;
  Color currentColor = Colors.black;

  PixelTool currentTool = PixelTool.pencil;
  MirrorAxis mirrorAxis = MirrorAxis.vertical;

  final List<List<Color>> _undoStack = [];
  final List<List<Color>> _redoStack = [];

  SelectionModel? _selectionRect;
  SelectionModel? _originalSelectionRect;
  List<MapEntry<Point<int>, Color>> _selectedPixels = [];
  List<Color> _cachedPixels = [];

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  PixelDrawingController({required this.width, required this.height}) {
    pixels = List.filled(width * height, Colors.transparent);
  }

  void setPixel(int x, int y) {
    if (x >= 0 && x < width && y >= 0 && y < height) {
      if (_selectionRect != null && !_isPointInSelection(x, y)) {
        return;
      }

      _drawPixel(x, y);
      // if (currentTool == PixelTool.mirror) {
      //   _drawMirroredPixels(x, y);
      // }

      notifyListeners();

      if (_selectionRect != null) {
        _selectedPixels.add(MapEntry(Point(x, y), currentColor));
      }
    }
  }

  void _drawPixel(int x, int y) {
    pixels[y * width + x] = currentColor;
  }

  void _drawMirroredPixels(int x, int y) {
    switch (mirrorAxis) {
      case MirrorAxis.horizontal:
        int mirroredY = height - 1 - y;
        _drawPixel(x, mirroredY);
        break;
      case MirrorAxis.vertical:
        int mirroredX = width - 1 - x;
        _drawPixel(mirroredX, y);
        break;
      case MirrorAxis.both:
        int mirroredX = width - 1 - x;
        int mirroredY = height - 1 - y;
        _drawPixel(mirroredX, y); // Vertical mirror
        _drawPixel(x, mirroredY); // Horizontal mirror
        _drawPixel(mirroredX, mirroredY); // Both axes
        break;
    }
  }

  void fill(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) return;

    final targetColor = pixels[y * width + x];
    if (targetColor == currentColor) return;

    saveState();

    final queue = Queue<Point<int>>();
    queue.add(Point(x, y));

    while (queue.isNotEmpty) {
      final point = queue.removeFirst();
      final px = point.x;
      final py = point.y;

      if (px < 0 || px >= width || py < 0 || py >= height) continue;
      if (pixels[py * width + px] != targetColor) continue;

      if (_selectionRect != null && !_isPointInSelection(px, py)) {
        continue;
      }

      pixels[py * width + px] = currentColor;

      queue.add(Point(px + 1, py));
      queue.add(Point(px - 1, py));
      queue.add(Point(px, py + 1));
      queue.add(Point(px, py - 1));

      if (_selectionRect != null) {
        _selectedPixels.add(MapEntry(Point(px, py), currentColor));
      }
    }

    notifyListeners();
  }

  void drawShape(List<Point<int>> points) {
    for (final point in points) {
      setPixel(point.x, point.y);
    }
    notifyListeners();
  }

  void clear() {
    saveState();

    pixels = List.filled(width * height, Colors.transparent);
    notifyListeners();
  }

  void undo() {
    if (!canUndo) return;

    _redoStack.add(List.from(pixels));
    pixels = _undoStack.removeLast();
    notifyListeners();
  }

  void redo() {
    if (!canRedo) return;

    _undoStack.add(List.from(pixels));
    pixels = _redoStack.removeLast();
    notifyListeners();
  }

  void saveState() {
    _undoStack.add(List.from(pixels));
    if (_undoStack.length > 50) {
      _undoStack.removeAt(0);
    }
    _redoStack.clear();
  }

  void resize(int newWidth, int newHeight) {
    List<Color> newPixels = List.filled(
      newWidth * newHeight,
      Colors.transparent,
    );
    for (int y = 0; y < height && y < newHeight; y++) {
      for (int x = 0; x < width && x < newWidth; x++) {
        newPixels[y * newWidth + x] = pixels[y * width + x];
      }
    }
    width = newWidth;
    height = newHeight;
    pixels = newPixels;
    notifyListeners();
  }

  void applyGradient(List<Color> gradientColors) {
    for (int i = 0; i < pixels.length; i++) {
      if (gradientColors[i] != Colors.transparent) {
        pixels[i] = Color.alphaBlend(gradientColors[i], pixels[i]);
      }
    }
    notifyListeners();
  }

  void setSelection(SelectionModel? selection) {
    _selectionRect = selection;
    _originalSelectionRect = selection;
    if (selection != null) {
      _selectedPixels = _getSelectedPixels(selection);
      _cachedPixels = List.from(pixels);
    } else {
      _selectedPixels = [];
      _cachedPixels = [];
    }
    notifyListeners();
  }

  void moveSelection(SelectionModel model) {
    if (_selectionRect == null) return;

    // Calculate the difference in positions
    final dx = model.x - _selectionRect!.x;
    final dy = model.y - _selectionRect!.y;

    // Create a new list for the updated selected pixels
    List<MapEntry<Point<int>, Color>> newSelectedPixels = [];

    // Clear the pixels at the old positions
    for (final entry in _selectedPixels) {
      final x = entry.key.x;
      final y = entry.key.y;
      if (x >= 0 && x < width && y >= 0 && y < height) {
        final p = y * width + x;
        pixels[p] =
            _originalSelectionRect != null && !_isPointInOriginalSelection(x, y)
                ? _cachedPixels[p]
                : Colors.transparent;
      }
    }

    // Update the positions of selected pixels and apply them to the canvas
    for (final entry in _selectedPixels) {
      final newX = entry.key.x + dx;
      final newY = entry.key.y + dy;
      if (newX >= 0 && newX < width && newY >= 0 && newY < height) {
        pixels[newY * width + newX] = entry.value == Colors.transparent
            ? pixels[newY * width + newX]
            : entry.value;
        newSelectedPixels.add(MapEntry(Point(newX, newY), entry.value));
      }
    }

    // Update the selected pixels list with new positions
    _selectedPixels = newSelectedPixels;

    // Update the selection rectangle
    _selectionRect = model;

    notifyListeners();
  }

  List<MapEntry<Point<int>, Color>> _getSelectedPixels(
    SelectionModel selection,
  ) {
    List<MapEntry<Point<int>, Color>> selectedPixels = [];
    for (int y = selection.y; y < selection.y + selection.height; y++) {
      for (int x = selection.x; x < selection.x + selection.width; x++) {
        if (x >= 0 && x < width && y >= 0 && y < height) {
          final color = pixels[y * width + x];
          selectedPixels.add(MapEntry(Point(x, y), color));
        }
      }
    }
    return selectedPixels;
  }

  bool _isPointInOriginalSelection(int x, int y) {
    if (_originalSelectionRect == null) return false;

    final rect = _originalSelectionRect!.rect;
    return x >= rect.left && x < rect.right && y >= rect.top && y < rect.bottom;
  }

  bool _isPointInSelection(int x, int y) {
    if (_selectionRect == null) return false;

    final rect = _selectionRect!.rect;
    return x >= rect.left && x < rect.right && y >= rect.top && y < rect.bottom;
  }
}

class PixelDrawScreen extends HookConsumerWidget {
  const PixelDrawScreen({super.key, required this.id});

  final String id;

  double _calculateSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size.width > size.height) {
      return size.height - 60;
    } else {
      return size.width - 60;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTool = useState<PixelTool>(PixelTool.pencil);
    final controller = ref.watch(pixelDrawProvider);

    final message = useState('');

    useEffect(() {
      controller.currentTool = currentTool.value;
    }, [currentTool, controller]);

    return Scaffold(
      appBar: AppBar(
        title: Text(message.value),
        actions: [
          IconButton(
            icon: Icon(Icons.undo,
                color: controller.canUndo ? null : Colors.grey),
            onPressed: controller.canUndo ? () => controller.undo() : null,
            tooltip: 'Undo',
          ),
          IconButton(
            icon: Icon(Icons.redo,
                color: controller.canRedo ? null : Colors.grey),
            onPressed: controller.canRedo ? () => controller.redo() : null,
            tooltip: 'Redo',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Implement save functionality
            },
          ),
        ],
      ),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 600)
            Container(
              width: 60,
              color: Colors.grey[200],
              child: ToolMenu(
                currentTool: currentTool,
                onSelectTool: (tool) => currentTool.value = tool,
                onColorPicker: () {
                  showColorPicker(context, controller);
                },
                currentColor: controller.currentColor,
              ),
            ),
          Expanded(
            child: Column(
              children: [
                const Expanded(child: SizedBox()),
                Container(
                  clipBehavior: Clip.hardEdge,
                  width: _calculateSize(context),
                  height: _calculateSize(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: PixelGrid(
                    width: controller.width,
                    height: controller.height,
                    pixels: controller.pixels,
                    onTapPixel: (x, y) {
                      switch (currentTool.value) {
                        case PixelTool.pencil:
                          controller.setPixel(x, y);
                          break;
                        case PixelTool.mirror:
                          controller.setPixel(x, y);
                        case PixelTool.fill:
                          controller.fill(x, y);
                          break;
                        case PixelTool.eraser:
                          final originalColor = controller.currentColor;
                          controller.currentColor = Colors.transparent;
                          controller.setPixel(x, y);
                          controller.currentColor = originalColor;
                          break;
                        // For line, rectangle, circle tools, do nothing here
                        default:
                          break;
                      }
                    },
                    currentTool: currentTool.value,
                    currentColor: controller.currentColor,
                    onDrawShape: (points) {
                      controller.drawShape(points);
                    },
                    onStartDrawing: () {
                      controller.saveState();
                    },
                    onFinishDrawing: () {
                      message.value = 'Drawing saved';

                      // Clear the message after 2 seconds
                      Future.delayed(const Duration(seconds: 1), () {
                        message.value = '';
                      });
                    },
                    onSelectionChanged: (rect) {
                      controller.setSelection(rect);
                    },
                    onMoveSelection: (rect) {
                      controller.moveSelection(rect);
                    },
                    onColorPicked: (color) {
                      controller.currentColor =
                          color == Colors.transparent ? Colors.white : color;
                    },
                    onGradientApplied: (gradientColors) {
                      controller.applyGradient(gradientColors);
                    },
                  ),
                ),
                const Expanded(child: SizedBox()),
                if (MediaQuery.of(context).size.width <= 600)
                  BottomAppBar(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit,
                              color: currentTool.value == PixelTool.pencil
                                  ? Colors.blue
                                  : null),
                          onPressed: () => currentTool.value = PixelTool.pencil,
                        ),
                        IconButton(
                          icon: Icon(Icons.format_color_fill,
                              color: currentTool.value == PixelTool.fill
                                  ? Colors.blue
                                  : null),
                          onPressed: () => currentTool.value = PixelTool.fill,
                        ),
                        IconButton(
                          icon: Icon(Icons.cleaning_services,
                              color: currentTool.value == PixelTool.eraser
                                  ? Colors.blue
                                  : null),
                          onPressed: () => currentTool.value = PixelTool.eraser,
                        ),
                        IconButton(
                          icon: const Icon(Icons.color_lens),
                          onPressed: () {
                            showColorPicker(context, controller);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.grid_on),
                          onPressed: () {
                            // Implement grid size change
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showColorPicker(
    BuildContext context,
    PixelDrawingController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: MaterialPicker(
            pickerColor: controller.currentColor,
            onColorChanged: (color) {
              controller.currentColor = color;
            },
            enableLabel: true,
            portraitOnly: true,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class ToolMenu extends StatelessWidget {
  final ValueNotifier<PixelTool> currentTool;
  final Function(PixelTool) onSelectTool;
  final Function() onColorPicker;
  final Color currentColor;

  const ToolMenu({
    super.key,
    required this.currentTool,
    required this.onSelectTool,
    required this.onColorPicker,
    required this.currentColor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PixelTool>(
      valueListenable: currentTool,
      builder: (context, tool, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.edit,
                  color: tool == PixelTool.pencil ? Colors.blue : null),
              onPressed: () => onSelectTool(PixelTool.pencil),
            ),
            IconButton(
              icon: Icon(Icons.format_color_fill,
                  color: tool == PixelTool.fill ? Colors.blue : null),
              onPressed: () => onSelectTool(PixelTool.fill),
            ),
            IconButton(
              icon: Icon(
                Fontisto.eraser,
                color: tool == PixelTool.eraser ? Colors.blue : null,
              ),
              onPressed: () => onSelectTool(PixelTool.eraser),
            ),
            // selection tool
            IconButton(
              icon: Icon(Icons.crop,
                  color: tool == PixelTool.select ? Colors.blue : null),
              onPressed: () => onSelectTool(PixelTool.select),
            ),
            IconButton(
              icon: Icon(Icons.show_chart,
                  color: tool == PixelTool.line ? Colors.blue : null),
              onPressed: () => onSelectTool(PixelTool.line),
            ),
            IconButton(
              icon: Icon(Icons.crop_square,
                  color: tool == PixelTool.rectangle ? Colors.blue : null),
              onPressed: () => onSelectTool(PixelTool.rectangle),
            ),
            IconButton(
              icon: Icon(Icons.radio_button_unchecked,
                  color: tool == PixelTool.circle ? Colors.blue : null),
              onPressed: () => onSelectTool(PixelTool.circle),
            ),
            IconButton(
              icon: Icon(
                Icons.colorize,
                color: tool == PixelTool.eyedropper ? Colors.blue : null,
              ),
              onPressed: () => onSelectTool(PixelTool.eyedropper),
            ),
            IconButton(
              icon: Icon(
                Icons.color_lens,
                color: currentColor == Colors.transparent
                    ? Colors.grey
                    : currentColor,
              ),
              onPressed: () {
                onColorPicker();
              },
            ),
            IconButton(
              icon: Icon(
                Octicons.mirror,
                color: tool == PixelTool.mirror ? Colors.blue : null,
              ),
              onPressed: () => onSelectTool(PixelTool.mirror),
            ),
            IconButton(
              icon: Icon(Icons.gradient,
                  color: tool == PixelTool.gradient ? Colors.blue : null),
              onPressed: () => onSelectTool(PixelTool.gradient),
            ),
            IconButton(
              icon: Icon(
                Icons.brush,
                color: tool == PixelTool.brush ? Colors.blue : null,
              ),
              onPressed: () => onSelectTool(PixelTool.brush),
            ),
            IconButton(
              icon: const Icon(Icons.grid_on),
              onPressed: () {
                // Implement grid size change
              },
            ),
          ],
        );
      },
    );
  }
}

class GridPainter extends CustomPainter {
  final int width;
  final int height;

  GridPainter({required this.width, required this.height});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final cellWidth = size.width / width;
    final cellHeight = size.height / height;

    for (int i = 0; i <= width; i++) {
      final x = i * cellWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (int i = 0; i <= height; i++) {
      final y = i * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
