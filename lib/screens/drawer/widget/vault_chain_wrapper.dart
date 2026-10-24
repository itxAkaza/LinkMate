import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Wraps the "Private Vault" drawer row in a 3D interlocking blue security chain
/// that weaves BEHIND and IN FRONT of the widget when the Drawer opens,
/// then settles into a locked position.
class VaultChainWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const VaultChainWrapper({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<VaultChainWrapper> createState() => _VaultChainWrapperState();
}

class _VaultChainWrapperState extends State<VaultChainWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Start the one-shot slither & lock-in animation as the drawer opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward(from: 0.0);
      }
    });
  }

  /// Optional: replay a quick chain rattle if needed
  void replayChainMotion() {
    _controller.forward(from: 0.25);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          // 1. BACK LAYER: Chain segments weaving BEHIND the Private Vault row
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _VaultChain3DPainter(
                    animation: _controller,
                    isForeground: false,
                  ),
                ),
              ),
            ),
          ),

          // 2. MIDDLE LAYER: The Private Vault Drawer Card (with subtle frost card backing
          //    so the back-layer chain clearly tucks underneath it)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFF).withOpacity(0.88),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF3B82F6).withOpacity(0.18),
                width: 1,
              ),
            ),
            child: widget.child,
          ),

          // 3. FRONT LAYER: Chain segments weaving OVER the Private Vault row
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _VaultChain3DPainter(
                    animation: _controller,
                    isForeground: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VaultChain3DPainter extends CustomPainter {
  final Animation<double> animation;
  final bool isForeground;

  _VaultChain3DPainter({
    required this.animation,
    required this.isForeground,
  }) : super(repaint: animation);

  // Exact Figma Gradient Colors (#60A5FA -> #3B82F6 -> #2563EB)
  static const Color _lightBlue = Color(0xFF60A5FA);
  static const Color _midBlue = Color(0xFF3B82F6);
  static const Color _deepBlue = Color(0xFF2563EB);
  static const Color _darkRim = Color(0xFF1D4ED8);
  static const Color _inkShadow = Color(0xFF111111);

  // Wave geometry: 1.85 cycles matches your blue sketch across the row
  static const double _cycles = 1.85;
  static const double _phaseOffset = -0.35; // Positions front crossings cleanly over icon-gap & right side

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 20 || size.height <= 16) return;

    final double rawT = animation.value;
    // Smooth slither-in during first 75%, settling lock-in until 100%
    final double headReveal = Curves.easeOutCubic.transform((rawT / 0.72).clamp(0.0, 1.0));
    final double slideMotion = Curves.easeOutQuart.transform(rawT);

    // Chain starts slightly looser and tightens onto the row as it stops
    final double tightenFactor = ui.lerpDouble(1.22, 1.0, Curves.easeOutBack.transform(rawT))!;
    final double baseAmplitude = (size.height * 0.42).clamp(14.0, 24.0) * tightenFactor;
    final double centerY = size.height * 0.50;

    // Chain links travel along the wave for ~42px before locking in place
    final double chainTravelOffset = (1.0 - slideMotion) * 44.0;

    // 1. Build the continuous sine-wave spine path
    final Path wavePath = Path();
    const int samples = 110;
    final double startX = 6.0;
    final double endX = size.width - 6.0;
    final double totalWidth = endX - startX;

    for (int i = 0; i <= samples; i++) {
      final double u = i / samples;
      final double x = startX + u * totalWidth;
      final double theta = u * _cycles * 2 * math.pi + _phaseOffset;
      final double y = centerY - baseAmplitude * math.sin(theta);

      if (i == 0) {
        wavePath.moveTo(x, y);
      } else {
        wavePath.lineTo(x, y);
      }
    }

    final ui.PathMetrics metrics = wavePath.computeMetrics();
    final Iterator<ui.PathMetric> iterator = metrics.iterator;
    if (!iterator.moveNext()) return;

    final ui.PathMetric metric = iterator.current;
    final double totalLength = metric.length;
    final double visibleLength = totalLength * headReveal;

    // Responsive link dimensions based on row height
    final double scale = (size.height / 54.0).clamp(0.82, 1.18);
    final double stepDistance = 9.2 * scale; // Distance between interlocking links
    final double flatLinkW = 15.5 * scale;
    final double flatLinkH = 8.2 * scale;
    final double sideLinkW = 11.5 * scale;
    final double sideLinkH = 4.4 * scale;

    final int maxLinks = (visibleLength / stepDistance).floor();

    // Two-pass rendering per layer:
    // Pass 0 = Flat open chain rings, Pass 1 = 90-degree interlocking bridge links on top
    for (int pass = 0; pass < 2; pass++) {
      for (int i = 0; i <= maxLinks; i++) {
        // Shift sample distance during animation so links physically crawl along the curve
        final double dist = i * stepDistance - (chainTravelOffset % (stepDistance * 2));
        if (dist < 0 || dist > visibleLength) continue;

        final ui.Tangent? tangent = metric.getTangentForOffset(dist);
        if (tangent == null) continue;

        final Offset pos = tangent.position;
        final double angle = -tangent.angle; // Canvas rotation angle

        // Determine if this link belongs to the FRONT weave or BACK weave:
        // Using the wave's cosine slope creates continuous front/back half-loops
        final double u = ((pos.dx - startX) / totalWidth).clamp(0.0, 1.0);
        final double theta = u * _cycles * 2 * math.pi + _phaseOffset;
        final double depthZ = math.cos(theta - 0.25); // > 0 is weaving in front, <= 0 is behind

        final bool linkIsFront = depthZ > -0.05;
        if (linkIsFront != isForeground) continue;

        final bool isSideConnector = i.isOdd;
        if ((pass == 0 && isSideConnector) || (pass == 1 && !isSideConnector)) {
          continue;
        }

        canvas.save();
        canvas.translate(pos.dx, pos.dy);
        canvas.rotate(angle);

        if (!isSideConnector) {
          _drawOpenChainRing(
            canvas,
            width: flatLinkW,
            height: flatLinkH,
            scale: scale,
            isFront: isForeground,
          );
        } else {
          _drawConnectorLink(
            canvas,
            width: sideLinkW,
            height: sideLinkH,
            scale: scale,
            isFront: isForeground,
          );
        }

        canvas.restore();
      }
    }
  }

  /// Draws a hollow stadium-shaped metallic blue chain ring
  void _drawOpenChainRing(
      Canvas canvas, {
        required double width,
        required double height,
        required double scale,
        required bool isFront,
      }) {
    final Rect rect = Rect.fromCenter(
      center: Offset.zero,
      width: width,
      height: height,
    );
    final RRect ringRRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(height / 2),
    );

    // 1. Soft drop shadow onto the Private Vault tile (stronger on foreground weave)
    final Paint shadowPaint = Paint()
      ..color = _inkShadow.withOpacity(isFront ? 0.18 : 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (isFront ? 3.2 : 2.4) * scale
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.2);

    canvas.save();
    canvas.translate(0, isFront ? 1.8 * scale : 1.0 * scale);
    canvas.drawRRect(ringRRect, shadowPaint);
    canvas.restore();

    // 2. Dark metallic outer rim for crisp contrast against white background
    final Paint outerRimPaint = Paint()
      ..color = isFront ? _darkRim : _deepBlue.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (isFront ? 3.4 : 2.6) * scale
      ..isAntiAlias = true;
    canvas.drawRRect(ringRRect, outerRimPaint);

    // 3. Figma Blue Gradient Body (#60A5FA -> #3B82F6 -> #2563EB)
    final Paint gradientBodyPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(-width / 2, -height / 2),
        Offset(width / 2, height / 2),
        isFront
            ? const [_lightBlue, _midBlue, _deepBlue]
            : [
          _lightBlue.withOpacity(0.55),
          _midBlue.withOpacity(0.55),
          _deepBlue.withOpacity(0.55),
        ],
        const [0.0, 0.5, 1.0],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = (isFront ? 2.3 : 1.8) * scale
      ..isAntiAlias = true;
    canvas.drawRRect(ringRRect, gradientBodyPaint);

    // 4. Specular top edge highlight for 3D cylindrical shine
    if (isFront) {
      final RRect highlightRRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(0, -0.35 * scale),
          width: width - 1.6 * scale,
          height: height - 1.6 * scale,
        ),
        Radius.circular((height - 1.6 * scale) / 2),
      );
      final Paint highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.65 * scale
        ..isAntiAlias = true;
      canvas.drawRRect(highlightRRect, highlightPaint);
    }
  }

  /// Draws the 90-degree rotated link that locks two open rings together
  void _drawConnectorLink(
      Canvas canvas, {
        required double width,
        required double height,
        required double scale,
        required bool isFront,
      }) {
    final Rect rect = Rect.fromCenter(
      center: Offset.zero,
      width: width,
      height: height,
    );
    final RRect pill = RRect.fromRectAndRadius(
      rect,
      Radius.circular(height / 2),
    );

    // Shadow
    if (isFront) {
      final Paint shadow = Paint()
        ..color = _inkShadow.withOpacity(0.20)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.8);
      canvas.drawRRect(pill.shift(Offset(0, 1.3 * scale)), shadow);
    }

    // Metallic Gradient Fill
    final Paint fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, -height / 2),
        Offset(0, height / 2),
        isFront
            ? const [_lightBlue, _midBlue, _deepBlue]
            : [
          _lightBlue.withOpacity(0.6),
          _midBlue.withOpacity(0.6),
          _deepBlue.withOpacity(0.6),
        ],
        const [0.0, 0.5, 1.0],
      )
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Dark border
    final Paint borderPaint = Paint()
      ..color = isFront ? _darkRim : _deepBlue.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * scale
      ..isAntiAlias = true;

    canvas.drawRRect(pill, fillPaint);
    canvas.drawRRect(pill, borderPaint);

    // Center shine line
    if (isFront) {
      final Paint shine = Paint()
        ..color = Colors.white.withOpacity(0.75)
        ..strokeWidth = 0.8 * scale
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(-width * 0.28, -height * 0.18),
        Offset(width * 0.28, -height * 0.18),
        shine,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VaultChain3DPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.isForeground != isForeground;
  }
}