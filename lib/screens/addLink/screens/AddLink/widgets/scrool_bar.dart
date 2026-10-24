
import 'package:flutter/material.dart';

class LiquidGlassScrollbar extends StatelessWidget {
  final ScrollController controller;
  final Widget child;
  final double thickness;

  const LiquidGlassScrollbar({
    super.key,
    required this.controller,
    required this.child,
    this.thickness = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: controller,
      thumbVisibility: true,
      interactive: true,
      thickness: thickness,
      radius: const Radius.circular(20),
      child: child,
    );
  }
}
