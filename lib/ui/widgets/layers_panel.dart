import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:doodle_verse/core/canvas/drawing_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data.dart';
import 'drawing_painter.dart';

class LayersPanel extends HookConsumerWidget {
  final List<LayerModel> layers;
  final int activeLayerIndex;
  final Function(String name) onLayerAdded;
  final Function(int) onLayerSelected;
  final Function(int) onLayerDeleted;
  final Function(int) onLayerVisibilityChanged;
  final Function(int) onLayerLockedChanged;
  final Function(int, String) onLayerNameChanged;
  final Function(int oldIndex, int newIndex) onLayerReordered;
  final Function(int, double) onLayerOpacityChanged;

  const LayersPanel({
    super.key,
    required this.layers,
    required this.onLayerAdded,
    required this.activeLayerIndex,
    required this.onLayerSelected,
    required this.onLayerDeleted,
    required this.onLayerVisibilityChanged,
    required this.onLayerLockedChanged,
    required this.onLayerNameChanged,
    required this.onLayerReordered,
    required this.onLayerOpacityChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Divider(),
        _buildLayersPanelHeader(),
        Expanded(
          child: ReorderableListView.builder(
            itemCount: layers.length,
            onReorder: (oldIndex, newIndex) {
              onLayerReordered(newIndex, oldIndex);
            },
            itemBuilder: (context, index) {
              final layer = layers[index];
              return _buildLayerTile(
                context,
                layer,
                index,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLayersPanelHeader() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Layers',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              onLayerAdded('Layer ${layers.length + 1}');
            },
            tooltip: 'Add new layer',
          ),
        ],
      ),
    );
  }

  Widget _buildLayerTile(BuildContext context, LayerModel layer, int index) {
    final contentColor =
        index == activeLayerIndex ? Colors.white : Colors.black;
    return Card(
      key: ValueKey(layer.id),
      color: index == activeLayerIndex ? Colors.blue.withOpacity(0.5) : null,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: _buildLayerPreview(layer),
        ),
        title: Text(
          layer.name,
          style: TextStyle(
            color: contentColor,
            fontSize: 12,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  layer.isVisible ? Icons.visibility : Icons.visibility_off,
                  color: contentColor,
                  size: 15,
                ),
              ),
              onTap: () {
                onLayerVisibilityChanged(index);
              },
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: contentColor,
                  size: 15,
                ),
              ),
              onTap: () => _showDeleteConfirmation(context, index),
            ),
            const SizedBox(width: 8),
          ],
        ),
        onTap: () {
          onLayerSelected(index);
        },
        selected: index == activeLayerIndex,
      ),
    );
  }

  Widget _buildLayerPreview(LayerModel layer) {
    return LayerPreview(layer: layer);
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Layer'),
          content: const Text('Are you sure you want to delete this layer?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                onLayerDeleted(index);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showRenameDialog(BuildContext context, String? name) async {
    final TextEditingController controller = TextEditingController(text: name);
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name == null ? 'Create New Layer' : 'Rename Layer'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Layer Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: name == null ? const Text('Create') : const Text('Rename'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
        );
      },
    );
  }
}

class LayerPreview extends StatefulWidget {
  const LayerPreview({
    super.key,
    required this.layer,
  });

  final LayerModel layer;

  @override
  State<LayerPreview> createState() => _LayerPreviewState();
}

class _LayerPreviewState extends State<LayerPreview> {
  Uint8List? _imageData;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _capture();
    });
  }

  @override
  void didUpdateWidget(covariant LayerPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.layer != widget.layer) {
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 500), _capture);
    }
  }

  Future<void> _capture() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(40, 40);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.white.withOpacity(0.8),
      ),
      child: _imageData != null
          ? Image.memory(
              _imageData!,
              fit: BoxFit.cover,
            )
          : Container(
              alignment: Alignment.center,
              child: const Icon(Icons.image, size: 24),
            ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
