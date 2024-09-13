import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:path_provider/path_provider.dart';

import '../../data.dart';
import '../../data/models/drawing_path.dart';
import '../../providers/common.dart';
import '../../providers/projects.dart';
import '../widgets/brush_settings_bottom_sheet.dart';
import '../widgets/color_picker_bottom_sheet.dart';
import '../widgets.dart';
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
  List<ui.Image> _redoStack = [];
  List<ui.Image> _paths = [];
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
    for (final layer in widget.project.layers) {
      _loadLayerStates(layer);
    }
  }

  void _loadLayerStates(LayerModel layer) async {
    final undoStates = layer.prevStates;
    final redoStates = layer.redoStates;

    for (final state in undoStates) {
      final image = await _loadImageFromFile(state.imagePath);
      _paths.add(image);
    }

    for (final state in redoStates) {
      final image = await _loadImageFromFile(state.imagePath);
      _redoStack.add(image);
    }
    setState(() {});
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

    final painter = DrawingPainter(_paths, null);
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
                color: _redoStack.isEmpty ? Colors.grey : null,
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
                          for (var brush in [
                            widget.tools.rectangleTool,
                            widget.tools.circleTool,
                            widget.tools.lineTool,
                            widget.tools.triangleTool,
                            widget.tools.heartTool,
                            widget.tools.starTool,
                            widget.tools.polygonTool,
                            widget.tools.spiralTool,
                            widget.tools.arrowTool,
                            widget.tools.ellipseTool,
                            widget.tools.cloudTool,
                            widget.tools.lightningTool,
                            widget.tools.pentagonTool,
                            widget.tools.hexagonTool,
                            widget.tools.parallelogramTool,
                            widget.tools.trapezoidTool,
                            widget.tools.fillTool,
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
                                  FittedBox(
                                    child: Text(
                                      brush.name,
                                      style: TextStyle(
                                        color: _brush.id == brush.id
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
                widget.tools.pencil,
                widget.tools.defaultBrush,
                widget.tools.marker,
                widget.tools.watercolor,
                widget.tools.crayon,
                widget.tools.sprayPaint,
                widget.tools.neon,
                widget.tools.charcoal,
                widget.tools.sketchy,
                widget.tools.star,
                widget.tools.heart,
                widget.tools.bubbleBrush,
                widget.tools.glitterBrush,
                widget.tools.rainbowBrush,
                widget.tools.sparkleBrush,
                widget.tools.leafBrush,
                widget.tools.grassBrush,
                widget.tools.pixelBrush,
                widget.tools.glowBrush,
                widget.tools.mosaicBrush,
                widget.tools.splatBrush,
                widget.tools.calligraphyBrush,
                widget.tools.electricBrush,
                widget.tools.furBrush,
                widget.tools.galaxyBrush,
                widget.tools.fractalBrush,
                widget.tools.fireBrush,
                widget.tools.snowflakeBrush,
                widget.tools.cloudBrush,
                widget.tools.lightningBrush,
                widget.tools.featherBrush,
                widget.tools.galaxyBrush1,
                widget.tools.confettiBrush,
                widget.tools.metallicBrush,
                widget.tools.embroideryBrush,
                widget.tools.stainedGlassBrush,
                widget.tools.ribbonBrush,
                widget.tools.particleFieldBrush,
                widget.tools.waveInterferenceBrush,
                widget.tools.voronoiBrush,
                widget.tools.chaosTheoryBrush,
                widget.tools.inkBrush,
                widget.tools.fireworksBrush,
                widget.tools.embossBrush,
                widget.tools.glassBrush
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
                      FittedBox(
                        child: Text(
                          brush.name,
                          style: TextStyle(
                            color: _brush.id == brush.id
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
            randomOffset: _brush.randoms?.call(),
            randomSize: null,
          )
        ],
      );
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final random = Random().nextDouble() * _brush.random[1] + _brush.random[0];

    final position = details.localPosition;
    final offset = Offset(position.dx + random, position.dy + random);

    setState(() {
      _currentPath!.points.add((
        offset: offset,
        randomOffset: _brush.randoms?.call() ??
            [
              Random().nextDouble() +
                  (_brush.random.isNotEmpty
                      ? _brush.random[1] + _brush.random[0]
                      : 0),
              Random().nextDouble() +
                  (_brush.random.isNotEmpty
                      ? _brush.random[1] + _brush.random[0]
                      : 0),
            ],
        randomSize: _brushSize,
      ));
    });
  }

  void _onPanEnd(DragEndDetails details) async {
    _renderPathsToImage(_currentPath);
  }

  void _renderPathsToImage(DrawingPath? drawingPath) async {
    if (drawingPath == null) return;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final size = MediaQuery.of(context).size;

    final painter = DrawingPainter([], drawingPath);

    painter.paint(canvas, size);

    final picture = recorder.endRecording();

    final image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );

    await _saveLayerState(image);

    setState(() {
      _paths.add(image);
      _currentPath = null;
      _redoStack.clear();
    });
  }

  Future<void> _saveLayerState(ui.Image image) async {
    _projectNotifier.addNewState(widget.project.layers.last.id, image);

    setState(() {
      _redoStack.clear();
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
    if (_paths.isNotEmpty) {
      setState(() {
        final image = _paths.removeLast();
        _redoStack.add(image);
      });

      final currentLayer = widget.project.layers.last;
      _projectNotifier.undoState(currentLayer.id);
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      setState(() {
        final image = _redoStack.removeLast();
        _paths.add(image);
      });

      final currentLayer = widget.project.layers.last;
      _projectNotifier.redoState(currentLayer.id);
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
