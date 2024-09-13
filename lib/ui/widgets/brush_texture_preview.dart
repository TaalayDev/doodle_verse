import 'package:doodle_verse/ui/widgets/drawing_painter.dart';
import 'package:flutter/material.dart';

import '../../data/models/drawing_path.dart';
import '../../data.dart';

class BrushTexturePreview extends StatelessWidget {
  final BrushData brush;
  final Color color;
  final bool isSelected;

  const BrushTexturePreview({
    super.key,
    required this.brush,
    required this.color,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          width: 2,
        ),
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CustomPaint(
          painter: _BrushTexturePainter(brush: brush, color: color),
        ),
      ),
    );
  }
}

class _BrushTexturePainter extends CustomPainter {
  final BrushData brush;
  final Color color;

  _BrushTexturePainter({required this.brush, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final drawingPath = DrawingPath(
      brush: brush,
      color: color,
      width: 4,
      points: [
        (
          offset: Offset(10, size.height / 2),
          randomOffset: null,
          randomSize: null
        ),
        (
          offset: Offset(size.width - 10, size.height / 2),
          randomOffset: null,
          randomSize: null
        ),
        (
          offset: Offset(size.width / 2, 10),
          randomOffset: null,
          randomSize: null
        ),
        (
          offset: Offset(size.width / 2, size.height - 10),
          randomOffset: null,
          randomSize: null
        ),
      ],
    );

    DrawingPainter([], drawingPath).paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
