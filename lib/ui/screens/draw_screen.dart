import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../core/canvas/drawing_controller.dart';
import '../../data.dart';
import '../../providers/common.dart';
import '../../providers/projects.dart';
import '../widgets/brush_settings_bottom_sheet.dart';
import '../widgets/color_picker_bottom_sheet.dart';
import '../widgets.dart';
import '../widgets/shortcut_wrapper.dart';
import '../widgets/drawing_painter.dart';

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

    if (projectState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return DrawBody(
      tools: toolsState,
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
  late final DrawingController _drawingController;
  late BrushData _brush = widget.tools.pencil;
  Color _currentColor = const Color(0xFF333333);
  double _brushSize = 8.0;

  // Variables for zoom and pan
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  bool _isScaling = false;
  double _initialScale = 1.0;
  Offset _initialOffset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;

  final _canvasKey = GlobalKey();

  late final _projectNotifier = widget.projectNotifer;

  @override
  void initState() {
    super.initState();
    _drawingController = DrawingController(context);
    _loadProject();
  }

  void _loadProject() {
    for (final layer in widget.project.layers) {
      _loadLayerStates(layer);
    }
  }

  void _loadLayerStates(LayerModel layer) async {
    final undoStates = layer.prevStates;
    final redoStates = layer.redoStates;

    _drawingController.loadStates(
      undoStates.map((state) => state.drawingPath).toList(),
      redoStates.map((state) => state.drawingPath).toList(),
    );
  }

  Future<ui.Image> _loadImageFromFile(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final fi = await codec.getNextFrame();
    return fi.image;
  }

  void _saveProject() async {
    await widget.projectNotifer.saveProject();

    _saveProjectThumbnail();
  }

  Future<ui.Image> _capture() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = MediaQuery.of(context).size;

    final painter = DrawingPainter(_drawingController);
    painter.paint(canvas, size);

    final picture = recorder.endRecording();
    return picture.toImage(size.width.toInt(), size.height.toInt());
  }

  void _saveProjectThumbnail() async {
    final image = await _capture();
    final pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);

    if (pngBytes != null) {
      final uint8List = Uint8List.view(pngBytes.buffer);
      _projectNotifier.updateCachedImage(uint8List);
    }
  }

  late final FocusNode focusNode = FocusNode()
    ..addListener(() => print('Has focus: ${focusNode.hasFocus}'));

  @override
  Widget build(BuildContext context) {
    return ShortcutsWrapper(
      onUndo: _undo,
      onRedo: _redo,
      focusNode: focusNode,
      child: Scaffold(
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
                  color: !_drawingController.canUndo ? Colors.grey : null,
                ),
              ),
              const SizedBox(width: 10),
              MenuButton(
                onPressed: _redo,
                child: Icon(
                  Feather.rotate_cw,
                  color: !_drawingController.canRedo ? Colors.grey : null,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Feather.layers),
              onPressed: () {},
            ),
          ],
        ),
        body: Stack(
          children: [
            // Drawing Canvas
            RepaintBoundary(
              key: _canvasKey,
              child: GestureDetector(
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                onScaleEnd: _onScaleEnd,
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(_offset.dx, _offset.dy)
                    ..scale(_scale),
                  child: ColoredBox(
                    color: Colors.white,
                    child: CustomPaint(
                      painter: DrawingPainter(_drawingController),
                      size: Size.infinite,
                    ),
                  ),
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
                        onTap: _zoomIn,
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
                        onTap: _zoomOut,
                        child: const Icon(Feather.zoom_out, size: 28),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 60,
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
                child: const Icon(
                  Feather.square,
                  size: 26,
                ),
                onPressed: () {
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
                            for (var figure in widget.tools.figures)
                              MaterialInkWell(
                                onTap: () {
                                  _setBrush(figure);
                                  Navigator.of(context).pop();
                                },
                                padding: const EdgeInsets.all(10),
                                borderRadius: BorderRadius.circular(30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getBrushIcon(figure),
                                      size: 26,
                                      color: _brush.id == figure.id
                                          ? Theme.of(context).primaryColor
                                          : null,
                                    ),
                                    const SizedBox(height: 5),
                                    FittedBox(
                                      child: Text(
                                        figure.name,
                                        style: TextStyle(
                                          color: _brush.id == figure.id
                                              ? Theme.of(context).primaryColor
                                              : null,
                                        ),
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
                },
              ),
            ],
          ),
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
      case 'bubble':
        return MaterialCommunityIcons.chart_bubble;
      case 'glitter':
        return Feather.star;
      default:
        return Feather.edit_2;
    }
  }

  void _showBrushPicker() {
    final brushes = [
      widget.tools.pencil,
      ...widget.tools.brushes,
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: brushes.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final brush = brushes[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _brush = brush;
                  });
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    BrushTexturePreview(
                      brush: brush,
                      color: Colors.black,
                      isSelected: _brush.id == brush.id,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      brush.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: _brush.id == brush.id
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Gesture handlers for scaling and drawing
  void _onScaleStart(ScaleStartDetails details) {
    if (details.pointerCount == 1) {
      // Start drawing
      _isScaling = false;
      final position = (details.localFocalPoint - _offset) / _scale;
      _drawingController.startPath(
        _brush,
        _currentColor,
        _brushSize,
        position,
      );
    } else if (details.pointerCount == 2) {
      // Start scaling and panning
      _isScaling = true;
      _initialScale = _scale;
      _initialOffset = _offset;
      _initialFocalPoint = details.focalPoint;
    }
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (_isScaling && details.pointerCount == 2) {
      // Update scaling and panning
      setState(() {
        _scale = (_initialScale * details.scale).clamp(0.5, 5.0);
        _offset = _initialOffset + (details.focalPoint - _initialFocalPoint);
      });
    } else if (!_isScaling && details.pointerCount == 1) {
      // Continue drawing
      final position = (details.localFocalPoint - _offset) / _scale;
      _drawingController.addPoint(position, _brush, _brushSize);
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    if (!_isScaling) {
      final state = _drawingController.currentPath;
      _drawingController.endPath();

      if (state != null) {
        _projectNotifier.addNewState(widget.project.layers.last.id, state);
      }
    }
    _isScaling = false;
  }

  void _zoomIn() {
    setState(() {
      _scale = (_scale * 1.2).clamp(0.5, 5.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _scale = (_scale / 1.2).clamp(0.5, 5.0);
    });
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
    _drawingController.undo();

    final currentLayer = widget.project.layers.last;
    _projectNotifier.undoState(currentLayer.id);
  }

  void _redo() {
    _drawingController.redo();

    final currentLayer = widget.project.layers.last;
    _projectNotifier.redoState(currentLayer.id);
  }

  @override
  void dispose() {
    _drawingController.dispose();

    super.dispose();
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
