import 'package:flutter/material.dart';

class MaterialInkWell extends StatelessWidget {
  const MaterialInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    Widget body = child;
    if (padding != null && padding != EdgeInsets.zero) {
      body = Padding(
        padding: padding!,
        child: body,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: body,
      ),
    );
  }
}
