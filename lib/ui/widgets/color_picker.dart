import 'package:flutter/material.dart';

class ColorPickerController {
  late Color _color;

  ColorPickerController({required Color color}) : _color = color;

  Color get color => _color;

  set color(Color color) {
    _color = color;
    _onColorChanged(color);
  }

  Function(Color) _onColorChanged = (color) {};
}

class ColorPicker extends StatefulWidget {
  final ValueChanged<Color> onColorChanged;
  final ColorPickerController controller;

  const ColorPicker({
    super.key,
    required this.onColorChanged,
    required this.controller,
  });

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late double _hue;
  late double _saturation;
  late double _value;
  late double _alpha;

  @override
  void initState() {
    super.initState();
    final hsv = HSVColor.fromColor(widget.controller.color);
    _hue = hsv.hue;
    _saturation = hsv.saturation;
    _value = hsv.value;
    _alpha = hsv.alpha;

    widget.controller._onColorChanged = (color) {
      final hsv = HSVColor.fromColor(color);
      _hue = hsv.hue;
      _saturation = hsv.saturation;
      _value = hsv.value;
      _alpha = hsv.alpha;
      widget.onColorChanged(color);
    };
  }

  void _updateColor() {
    final color = HSVColor.fromAHSV(
      _alpha,
      _hue,
      _saturation,
      _value,
    ).toColor();
    widget.controller.color = color;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200,
          child: SatValPanel(
            hue: _hue,
            saturation: _saturation,
            value: _value,
            onChanged: (sat, val) {
              setState(() {
                _saturation = sat;
                _value = val;
                _updateColor();
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 20,
          child: HueBar(
            hue: _hue,
            onChanged: (hue) {
              setState(() {
                _hue = hue;
                _updateColor();
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 20,
          child: AlphaBar(
            color: HSVColor.fromAHSV(1, _hue, _saturation, _value).toColor(),
            alpha: _alpha,
            onChanged: (alpha) {
              setState(() {
                _alpha = alpha;
                _updateColor();
              });
            },
          ),
        ),
      ],
    );
  }
}

class SatValPanel extends StatelessWidget {
  final double hue;
  final double saturation;
  final double value;
  final Function(double, double) onChanged;

  const SatValPanel({
    Key? key,
    required this.hue,
    required this.saturation,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final size = renderBox.size;
        final position = renderBox.globalToLocal(details.globalPosition);
        final double saturation = (position.dx / size.width).clamp(0.0, 1.0);
        final double value = 1 - (position.dy / size.height).clamp(0.0, 1.0);
        onChanged(saturation, value);
      },
      child: CustomPaint(
        painter:
            _SatValPanelPainter(hue: hue, saturation: saturation, value: value),
        size: Size.infinite,
      ),
    );
  }
}

class _SatValPanelPainter extends CustomPainter {
  final double hue;
  final double saturation;
  final double value;

  _SatValPanelPainter(
      {required this.hue, required this.saturation, required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    final saturatedColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();

    final horizontalGradient = LinearGradient(
      colors: [Colors.white, saturatedColor],
    ).createShader(rect);

    final verticalGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.black],
    ).createShader(rect);

    canvas.drawRect(rect, Paint()..shader = horizontalGradient);
    canvas.drawRect(rect, Paint()..shader = verticalGradient);

    final thumbPosition =
        Offset(saturation * size.width, (1 - value) * size.height);
    canvas.drawCircle(
        thumbPosition,
        8,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    canvas.drawCircle(
        thumbPosition,
        6,
        Paint()
          ..color = HSVColor.fromAHSV(1, hue, saturation, value).toColor());
  }

  @override
  bool shouldRepaint(_SatValPanelPainter oldDelegate) =>
      oldDelegate.hue != hue ||
      oldDelegate.saturation != saturation ||
      oldDelegate.value != value;
}

class HueBar extends StatelessWidget {
  final double hue;
  final ValueChanged<double> onChanged;

  const HueBar({Key? key, required this.hue, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.globalToLocal(details.globalPosition);
        final double hue =
            (position.dx / renderBox.size.width * 360).clamp(0.0, 360.0);
        onChanged(hue);
      },
      child: CustomPaint(
        painter: _HueBarPainter(hue: hue),
        size: Size.infinite,
      ),
    );
  }
}

class _HueBarPainter extends CustomPainter {
  final double hue;

  _HueBarPainter({required this.hue});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    final gradient = LinearGradient(
      colors: [
        for (int i = 0; i <= 360; i += 60)
          HSVColor.fromAHSV(1, i.toDouble(), 1, 1).toColor(),
      ],
    ).createShader(rect);

    canvas.drawRect(rect, Paint()..shader = gradient);

    final thumbPosition = Offset(hue / 360 * size.width, size.height / 2);
    canvas.drawCircle(
        thumbPosition,
        size.height / 2,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(_HueBarPainter oldDelegate) => oldDelegate.hue != hue;
}

class AlphaBar extends StatelessWidget {
  final Color color;
  final double alpha;
  final ValueChanged<double> onChanged;

  const AlphaBar(
      {Key? key,
      required this.color,
      required this.alpha,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.globalToLocal(details.globalPosition);
        final double alpha =
            (position.dx / renderBox.size.width).clamp(0.0, 1.0);
        onChanged(alpha);
      },
      child: CustomPaint(
        painter: _AlphaBarPainter(color: color, alpha: alpha),
        size: Size.infinite,
      ),
    );
  }
}

class _AlphaBarPainter extends CustomPainter {
  final Color color;
  final double alpha;

  _AlphaBarPainter({required this.color, required this.alpha});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    // Draw checkerboard pattern
    final Paint checkerPaint = Paint()..color = Colors.grey.shade300;
    final double cellSize = size.height / 2;
    for (int i = 0; i < size.width / cellSize; i++) {
      for (int j = 0; j < 2; j++) {
        if ((i + j) % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(i * cellSize, j * cellSize, cellSize, cellSize),
            checkerPaint,
          );
        }
      }
    }

    // Draw alpha gradient
    final gradient = LinearGradient(
      colors: [color.withOpacity(0), color],
    ).createShader(rect);

    canvas.drawRect(rect, Paint()..shader = gradient);

    final thumbPosition = Offset(alpha * size.width, size.height / 2);
    canvas.drawCircle(
        thumbPosition,
        size.height / 2,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(_AlphaBarPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.alpha != alpha;
}
