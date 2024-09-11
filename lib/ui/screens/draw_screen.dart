import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../data.dart';
import '../../providers/common.dart';
import '../../providers/projects.dart';
import '../widgets/brush_settings_bottom_sheet.dart';
import '../widgets/color_picker_bottom_sheet.dart';
import '../widgets.dart';

class DrawingPath {
  final BrushData brush;
  final Color color;
  final double width;
  final List<
      ({
        Offset offset,
        Offset? randomOffset,
        double? randomSize,
      })> points;

  DrawingPath({
    required this.brush,
    required this.color,
    required this.width,
    required this.points,
  });
}

class DrawScreen extends HookConsumerWidget {
  const DrawScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toolsState = ref.watch(toolsProvider);
    final projectState = ref.watch(projectProvider(id));

    if (toolsState.isLoading || projectState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DrawBody(
      tools: toolsState.requireValue,
      project: projectState.requireValue,
      projectNotifer: ref.watch(projectProvider(id).notifier),
    );
  }
}

class DrawBody extends StatefulWidget {
  const DrawBody({
    super.key,
    required this.tools,
    required this.project,
    required this.projectNotifer,
  });

  final ToolsData tools;
  final ProjectModel project;
  final Project projectNotifer;

  @override
  _DrawBodyState createState() => _DrawBodyState();
}

class _DrawBodyState extends State<DrawBody> {
  List<DrawingPath> _paths = [];
  List<DrawingPath> _redoPaths = [];
  DrawingPath? _currentPath;

  late BrushData _brush = widget.tools.pencil;
  Color _currentColor = const Color(0xFF333333);
  double _brushSize = 8.0;

  final _canvasKey = GlobalKey();

  late final _projectNotifier = widget.projectNotifer;

  @override
  void initState() {
    super.initState();
    _loadProject();
  }

  void _loadProject() {
    setState(() {
      _paths = [];

      _redoPaths = [];
    });
  }

  BrushData _getBrushById(String brushId) {
    switch (brushId) {
      case 'pencil':
        return widget.tools.pencil;
      case 'marker':
        return widget.tools.marker;
      case 'watercolor':
        return widget.tools.watercolor;
      // Add cases for all other brush types
      default:
        return widget.tools.defaultBrush;
    }
  }

  void _saveProject() {
    // Convert paths to layers
    final layer = LayerModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Drawing Layer',
    );

    // Update project with new layer
    final updatedLayers = [...widget.project.layers, layer];
    _projectNotifier.updateLayers(updatedLayers);

    _saveProjectThumbnail();
  }

  void _saveProjectThumbnail() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = MediaQuery.of(context).size;

    final painter = DrawingPainter(_paths, null);
    painter.paint(canvas, size);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

    if (pngBytes != null) {
      final uint8List = Uint8List.view(pngBytes.buffer);
      _projectNotifier.updateCachedImage(uint8List);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _saveProject();
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuButton(
              onPressed: _undo,
              child: Icon(
                Feather.rotate_ccw,
                color: _paths.isEmpty ? Colors.grey : null,
              ),
            ),
            const SizedBox(width: 10),
            MenuButton(
              onPressed: _redo,
              child: Icon(
                Feather.rotate_cw,
                color: _redoPaths.isEmpty ? Colors.grey : null,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Feather.layers),
            onPressed: () {
              // TODO: Implement fullscreen functionality
            },
          ),
        ],
      ),
      body: Builder(builder: (context) {
        return Stack(
          children: [
            // Drawing Canvas
            RepaintBoundary(
              key: _canvasKey,
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: CustomPaint(
                  painter: DrawingPainter(
                    _paths,
                    _currentPath,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
            // Zoom Controls
            Positioned(
              right: 10,
              bottom: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: MaterialInkWell(
                        padding: const EdgeInsets.all(10),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        onTap: () {},
                        child: const Icon(Feather.zoom_in, size: 28),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                      child: Divider(),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: MaterialInkWell(
                        padding: const EdgeInsets.all(10),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        onTap: () {},
                        child: const Icon(Feather.zoom_out, size: 28),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MenuButton(
              onPressed: _showColorPicker,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey),
                  ),
                ),
                width: 24,
                height: 24,
                child: Center(
                  child: Icon(
                    Icons.circle,
                    size: 22,
                    color: _currentColor,
                  ),
                ),
              ),
            ),
            MenuButton(
              child: Icon(
                Feather.edit_2,
                color: _brush.id == widget.tools.pencil.id
                    ? Theme.of(context).primaryColor
                    : null,
              ),
              onPressed: () {
                _setBrush(widget.tools.pencil);
              },
            ),
            MenuButton(
              child: Icon(
                Ionicons.brush_outline,
                size: 28,
                color: _brush.id != widget.tools.pencil.id &&
                        _brush.id != widget.tools.eraser.id
                    ? Theme.of(context).primaryColor
                    : null,
              ),
              onPressed: () async {
                _showBrushPicker();
              },
            ),
            MenuButton(
              child: const Icon(
                Feather.sliders,
              ),
              onPressed: () {
                showBrushSettingsBottomSheet(
                  context: context,
                  brushSize: _brushSize,
                  onBrushSizeChanged: (value) {
                    setState(() {
                      _brushSize = value;
                    });
                  },
                );
              },
            ),
            MenuButton(
              child: Icon(
                Fontisto.eraser,
                size: 26,
                color: _brush.id == widget.tools.eraser.id
                    ? Theme.of(context).primaryColor
                    : null,
              ),
              onPressed: () {
                _setBrush(widget.tools.eraser);
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getBrushIcon(BrushData brush) {
    switch (brush.name) {
      case 'pencil':
        return Feather.edit_2;
      case 'marker':
        return Feather.edit_3;
      case 'watercolor':
        return Ionicons.brush_outline;
      case 'sprayPaint':
        return FontAwesome5Solid.spray_can;
      case 'neon':
        return Ionicons.flashlight_outline;
      case 'crayon':
        return Ionicons.pencil_outline;
      case 'charcoal':
        return Ionicons.contrast_outline;
      case 'eraser':
        return Fontisto.eraser;
      case 'star':
        return Feather.star;
      case 'sketchy':
        return Feather.book_open;
      case 'heart':
        return Feather.heart;
      default:
        return Feather.edit_2;
    }
  }

  void _showBrushPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            children: [
              for (var brush in [
                widget.tools.defaultBrush,
                widget.tools.brush1,
                widget.tools.marker,
                widget.tools.watercolor,
                widget.tools.crayon,
                widget.tools.sprayPaint,
                widget.tools.neon,
                widget.tools.charcoal,
                widget.tools.sketchy,
                widget.tools.star,
                widget.tools.heart,
              ])
                MaterialInkWell(
                  onTap: () {
                    _setBrush(brush);
                    Navigator.of(context).pop();
                  },
                  padding: const EdgeInsets.all(10),
                  borderRadius: BorderRadius.circular(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getBrushIcon(brush),
                        size: 26,
                        color: _brush.id == brush.id
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        brush.name,
                        style: TextStyle(
                          color: _brush.id == brush.id
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _currentPath = DrawingPath(
        brush: _brush,
        color: _currentColor,
        width: _brushSize,
        points: [
          (
            offset: details.localPosition,
            randomOffset: null,
            randomSize: null,
          )
        ],
      );
      _paths.add(_currentPath!);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final random = Random().nextDouble() * _brush.random[1] + _brush.random[0];

    final position = details.localPosition;
    final offset = Offset(position.dx + random, position.dy + random);

    setState(() {
      _currentPath!.points.add((
        offset: offset,
        randomOffset: Offset(
          Random().nextDouble() +
              (_brush.random.isNotEmpty
                  ? _brush.random[1] + _brush.random[0]
                  : 0),
          Random().nextDouble() +
              (_brush.random.isNotEmpty
                  ? _brush.random[1] + _brush.random[0]
                  : 0),
        ),
        randomSize: _brushSize,
      ));
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _currentPath = null;
      _redoPaths.clear();
    });
  }

  Future<ui.Image?> _captureCanvasImage() async {
    try {
      RenderRepaintBoundary boundary = _canvasKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      return image;
    } catch (e) {
      print("Failed to capture canvas image: $e");
      return null;
    }
  }

  void _setBrush(BrushData brush) {
    setState(() {
      _brush = brush;
    });
  }

  void _showColorPicker() async {
    final color = await showColorPickerBottomSheet(
      context: context,
      initialColor: _currentColor,
    );

    setState(() {
      _currentColor = color;
    });
  }

  void _undo() {
    if (_paths.isNotEmpty) {
      setState(() {
        _redoPaths.add(_paths.removeLast());
      });
    }
  }

  void _redo() {
    if (_redoPaths.isNotEmpty) {
      setState(() {
        _paths.add(_redoPaths.removeLast());
      });
    }
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final Widget child;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialInkWell(
      onTap: onPressed,
      padding: const EdgeInsets.all(6.0),
      borderRadius: BorderRadius.circular(30),
      child: child,
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter(this.paths, this.currentPath);

  final List<DrawingPath> paths;
  final DrawingPath? currentPath;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    for (var path in paths) {
      _drawPath(canvas, path);
    }
    if (currentPath != null) {
      _drawPath(canvas, currentPath!);
    }
    canvas.restore();
  }

  void _drawPath(Canvas canvas, DrawingPath drawingPath) {
    final paint = Paint()
      ..color = drawingPath.color.withOpacity(1 - drawingPath.brush.opacityDiff)
      ..strokeCap = drawingPath.brush.strokeCap
      ..strokeJoin = drawingPath.brush.strokeJoin
      ..strokeWidth = drawingPath.width
      ..style = PaintingStyle.stroke
      ..blendMode = drawingPath.brush.blendMode
      ..colorFilter = drawingPath.brush.brush != null
          ? ColorFilter.mode(
              drawingPath.color,
              BlendMode.srcATop,
            )
          : null;

    var path = Path();
    if (drawingPath.points.length < 2) {
      return;
    }

    if (drawingPath.brush.pathEffect != null) {
      _drawPathEffect(canvas, drawingPath, paint);
    } else if (drawingPath.brush.brush != null) {
      _drawTexturedPath(canvas, path, paint, drawingPath);
    } else {
      _drawSimplePath(canvas, drawingPath, paint);
    }
  }

  void _drawPathEffect(Canvas canvas, DrawingPath drawingPath, Paint paint) {
    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1];
      final p1 = drawingPath.points[i];

      p0.offset.calculateDensityOffset(
        p1.offset,
        drawingPath.brush.densityOffset,
        (offset) {
          final effect = drawingPath.brush.pathEffect!(
            p1.randomSize ?? drawingPath.width,
            offset,
            p1.randomOffset ?? const Offset(0, 0),
          );

          paint.strokeWidth = p1.randomSize ?? drawingPath.width;

          canvas.drawPath(effect, paint);
        },
      );
    }
  }

  void _drawSimplePath(Canvas canvas, DrawingPath drawingPath, Paint paint) {
    final path = Path();
    path.moveTo(
      drawingPath.points.first.offset.dx,
      drawingPath.points.first.offset.dy,
    );

    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1];
      final p1 = drawingPath.points[i];

      path.quadraticBezierTo(
        p0.offset.dx,
        p0.offset.dy,
        (p0.offset.dx + p1.offset.dx) / 2,
        (p0.offset.dy + p1.offset.dy) / 2,
      );
    }

    canvas.drawPath(path, paint);
  }

  void _drawTexturedPath(
    Canvas canvas,
    Path path,
    Paint paint,
    DrawingPath drawingPath,
  ) {
    final path = Path();
    path.moveTo(
      drawingPath.points.first.offset.dx,
      drawingPath.points.first.offset.dy,
    );

    for (int i = 1; i < drawingPath.points.length; i++) {
      final p0 = drawingPath.points[i - 1];
      final p1 = drawingPath.points[i];

      path.quadraticBezierTo(
        p0.offset.dx,
        p0.offset.dy,
        (p0.offset.dx + p1.offset.dx) / 2,
        (p0.offset.dy + p1.offset.dy) / 2,
      );
    }

    final pathMetrics = path.computeMetrics();
    final brush = drawingPath.brush.brush!;
    final src = Rect.fromLTWH(
      0,
      0,
      brush.width.toDouble(),
      brush.height.toDouble(),
    );

    for (final metric in pathMetrics) {
      var distance = 0.0;

      while (distance < metric.length) {
        final tangent = metric.getTangentForOffset(distance)!;
        final point = tangent.position;

        final radius = (drawingPath.width - 2);
        final dst = Rect.fromCircle(center: point, radius: radius);

        canvas.save();
        canvas.translate(point.dx, point.dy);
        canvas.rotate(tangent.angle);
        canvas.translate(-point.dx, -point.dy);
        canvas.drawImageRect(brush, src, dst, paint);
        canvas.restore();

        distance += (drawingPath.brush.useBrushWidthDensity
            ? drawingPath.width + drawingPath.brush.densityOffset
            : drawingPath.brush.densityOffset);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

extension OffsetExtension on Offset {
  Offset operator -(Offset other) => Offset(dx - other.dx, dy - other.dy);
  Offset operator +(Offset other) => Offset(dx + other.dx, dy + other.dy);
  Offset operator /(double value) => Offset(dx / value, dy / value);
  Offset operator *(double value) => Offset(dx * value, dy * value);

  double distanceTo(Offset other) =>
      (dx - other.dx).abs() + (dy - other.dy).abs();

  void calculateDensityOffset(
    Offset other,
    double density,
    Function(Offset) callback,
  ) {
    final distance = distanceTo(other);
    final direction = (other - this) / distance;

    for (double i = 0; i < distance; i += density) {
      callback(this + direction * i);
    }
  }
}
