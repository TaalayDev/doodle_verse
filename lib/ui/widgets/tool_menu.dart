import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ToolMenu extends StatelessWidget {
  final int currentTool;
  final Function(int) onSelectTool;
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(
            Ionicons.brush_outline,
            color: Colors.blue,
          ),
          onPressed: () {
            onSelectTool(0);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.format_color_fill,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Fontisto.eraser,
          ),
          onPressed: () {
            onSelectTool(2);
          },
        ),
        // selection tool
        IconButton(
          icon: const Icon(Icons.crop),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.pencil),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Feather.move),
          onPressed: () {},
        ),
        IconButton(icon: Icon(Icons.gradient), onPressed: () {}),
      ],
    );
  }
}
