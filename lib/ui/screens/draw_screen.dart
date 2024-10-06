import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../core/canvas/drawing_controller.dart';
import '../../core/canvas/image_saver.dart';
import '../../providers/projects.dart';
import '../../providers/common.dart';
import '../../data.dart';
import '../../core.dart';
import '../widgets/brush_settings_bottom_sheet.dart';
import '../widgets/color_picker_bottom_sheet.dart';
import '../widgets/color_palette_panel.dart';
import '../widgets/shortcut_wrapper.dart';
import '../widgets/drawing_painter.dart';
import '../widgets/layers_panel.dart';
import '../widgets/tool_menu.dart';
import '../widgets.dart';

class DrawScreen extends HookConsumerWidget {
  const DrawScreen({
    super.key,
    required this.id,
  });

  final int id;

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
  late BrushData _brush = widget.tools.defaultBrush;
  Color _currentColor = const Color(0xFF333333);
  double _brushSize = 4.0;

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
    _drawingController = DrawingController(context, project: widget.project);
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

  final focusNode = FocusNode();

  Future<void> _saveAsImage() async {
    final renderObject =
        _canvasKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await renderObject.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null && mounted) {
      final bytes = byteData.buffer.asUint8List();
      ImageSaver(context).save(bytes);
    }
  }

  double _calculateSize(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final width = screenSize.width;
    final height = screenSize.height;

    return width > height ? height : width;
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.sizeOf(context).width <= 600;

    return ShortcutsWrapper(
      onUndo: _undo,
      onRedo: _redo,
      focusNode: focusNode,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MenuButton(
                onPressed: _undo,
                child: Icon(
                  Icons.undo,
                  color: !_drawingController.canUndo ? Colors.grey : null,
                ),
              ),
              const SizedBox(width: 10),
              MenuButton(
                onPressed: _redo,
                child: Icon(
                  Icons.redo,
                  color: !_drawingController.canRedo ? Colors.grey : null,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Feather.save),
              onPressed: () {
                _saveAsImage();
              },
            ),
            IconButton(
              icon: const Icon(Feather.layers),
              onPressed: () {},
            ),
          ],
        ),
        body: Row(
          children: [
            if (!isSmallScreen)
              Container(
                color: Colors.grey[100],
                width: 60,
                child: ToolMenu(
                  currentTool: _brush.id,
                  onSelectTool: (value) {
                    if (value == 0) {
                      _showBrushPicker();
                    } else if (value == 2) {
                      _setBrush(widget.tools.eraser);
                    }
                  },
                  onColorPicker: () {
                    _showColorPicker();
                  },
                  currentColor: _currentColor,
                ),
              ),
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: Stack(
                  children: [
                    // Drawing Canvas
                    Center(
                      child: SizedBox(
                        width: _calculateSize(context),
                        height: _calculateSize(context),
                        child: GestureDetector(
                          onScaleStart: _onScaleStart,
                          onScaleUpdate: _onScaleUpdate,
                          onScaleEnd: _onScaleEnd,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(_offset.dx, _offset.dy)
                              ..scale(_scale),
                            child: RepaintBoundary(
                              key: _canvasKey,
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
              ),
            ),
            if (!isSmallScreen)
              Container(
                color: Colors.grey[100],
                width: 250,
                child: Column(
                  children: [
                    Expanded(
                      child: LayersPanel(
                        layers: widget.project.layers,
                        activeLayerIndex: _drawingController.currentLayerIndex,
                        onLayerSelected: (index) {
                          _drawingController.setActiveLayer(index);
                          _projectNotifier.setActiveLayerByIndex(index);
                          setState(() {});
                        },
                        onLayerVisibilityChanged: (index) {
                          _drawingController.setLayerVisibility(
                            index,
                            !widget.project.layers[index].isVisible,
                          );
                          _projectNotifier.setLayerVisibility(
                            widget.project.layers[index].id,
                            !widget.project.layers[index].isVisible,
                          );
                        },
                        onLayerAdded: (name) {
                          _projectNotifier
                              .addLayer(
                                LayerModel(
                                  id: 0,
                                  name: name,
                                  isVisible: true,
                                  states: [],
                                ),
                              )
                              .then(
                                (layer) => _drawingController.addLayer(layer),
                              );
                        },
                        onLayerDeleted: (index) {
                          _projectNotifier.deleteLayer(
                            widget.project.layers[index].id,
                          );
                          _drawingController.deleteLayer(index);
                        },
                        onLayerLockedChanged: (index) {},
                        onLayerNameChanged: (index, name) {
                          _projectNotifier.updateLayer(
                            widget.project.layers[index].copyWith(name: name),
                          );
                        },
                        onLayerReordered: (oldIndex, newIndex) {},
                        onLayerOpacityChanged: (index, opacity) {},
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ColorPalettePanel(
                        currentColor: _currentColor,
                        onColorSelected: (color) {
                          setState(() {
                            _currentColor = color;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        bottomNavigationBar: isSmallScreen
            ? BottomAppBar(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    ? Theme.of(context)
                                                        .primaryColor
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
              )
            : null,
      ),
    );
  }

  IconData _getBrushIcon(BrushData brush) {
    switch (brush.name) {
      case 'rectangle':
        return Feather.square;
      case 'circle':
        return Feather.circle;
      case 'line':
        return Feather.minus;
      case 'triangle':
        return Feather.triangle;
      case 'arrow':
        return Feather.arrow_up;
      case 'ellipse':
        return Fontisto.ellipse;
      case 'polygon':
        return MaterialCommunityIcons.polymer;
      case 'spiral':
        return Feather.rotate_cw;
      case 'star':
        return Feather.star;
      case 'cloud':
        return Feather.cloud;
      case 'heart':
        return Feather.heart;
      case 'lightning':
        return MaterialCommunityIcons.lightning_bolt;
      case 'pentagon':
        return MaterialCommunityIcons.pentagon;
      case 'hexagon':
        return MaterialCommunityIcons.hexagon;
      case 'parallelogram':
        return Icons.paragliding;
      case 'trapezoid':
        return Icons.paragliding;
      default:
        return Feather.edit_2;
    }
  }

  void _showBrushPicker() {
    final brushes = widget.tools.brushes;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.sizeOf(context).adaptiveValue(
                3,
                {
                  ScreenSize.md: 3,
                  ScreenSize.lg: 3,
                  ScreenSize.xl: 3,
                },
              ),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 90,
            ),
            itemCount: brushes.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final brush = brushes[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    _brush = brush;
                  });
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
        _projectNotifier
            .addNewState(
              _drawingController.currentLayer.id,
              state,
            )
            .then(
              (_) => _saveProjectThumbnail(),
            );
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

    final currentLayer = _drawingController.currentLayer;
    _projectNotifier.updateLayers(
      widget.project.layers.map((layer) {
        if (layer.id == currentLayer.id) {
          return layer.copyWith(states: List.of(layer.states)..removeLast());
        }
        return layer;
      }).toList(),
    );
  }

  void _redo() {
    final drawingPath = _drawingController.redo();
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
