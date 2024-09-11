import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../widgets.dart';
import 'color_picker.dart';

Future<Color> showColorPickerBottomSheet({
  required BuildContext context,
  required Color initialColor,
}) async {
  final controller = ColorPickerController(color: initialColor);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return ColorPickerBottomSheetBody(
        initialColor: initialColor,
        colorPickerController: controller,
      );
    },
  );

  return controller.color;
}

class ColorPickerBottomSheetBody extends StatefulWidget {
  const ColorPickerBottomSheetBody({
    super.key,
    required this.initialColor,
    required this.colorPickerController,
  });

  final Color initialColor;
  final ColorPickerController colorPickerController;

  @override
  State<ColorPickerBottomSheetBody> createState() =>
      _ColorPickerBottomSheetBodyState();
}

class _ColorPickerBottomSheetBodyState
    extends State<ColorPickerBottomSheetBody> {
  late Color _currentColor = widget.initialColor;
  late ColorPickerController colorPickerController =
      widget.colorPickerController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              IconButton(
                icon: const Icon(Feather.x),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          ColorPicker(
            controller: colorPickerController,
            onColorChanged: (color) {
              setState(() {
                _currentColor = color;
              });
            },
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Samples:'),
              IconButton(
                icon: const Icon(Feather.plus),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: 40,
            ),
            itemCount: 16,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final color = Colors.primaries[index % Colors.primaries.length];

              return InkWell(
                onTap: () {
                  setState(() {
                    _currentColor = color;
                  });
                  colorPickerController.color = color;
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
