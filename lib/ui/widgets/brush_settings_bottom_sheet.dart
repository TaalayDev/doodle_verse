import 'package:flutter/material.dart';

void showBrushSettingsBottomSheet({
  required BuildContext context,
  required double brushSize,
  required Function(double) onBrushSizeChanged,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: 150,
        child: BrushSettingsBottomSheet(
          brushSize: brushSize,
          onBrushSizeChanged: onBrushSizeChanged,
        ),
      );
    },
  );
}

class BrushSettingsBottomSheet extends StatefulWidget {
  const BrushSettingsBottomSheet({
    super.key,
    required this.brushSize,
    required this.onBrushSizeChanged,
  });

  final double brushSize;
  final Function(double) onBrushSizeChanged;

  @override
  State<BrushSettingsBottomSheet> createState() =>
      _BrushSettingsBottomSheetState();
}

class _BrushSettingsBottomSheetState extends State<BrushSettingsBottomSheet> {
  late double _brushSize = widget.brushSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Brush Size'),
          Slider(
            value: _brushSize,
            onChanged: (value) {
              setState(() {
                _brushSize = value;
              });
              widget.onBrushSizeChanged(value);
            },
            min: 1,
            max: 50,
          ),
        ],
      ),
    );
  }
}
