import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The app's signature element: a gauge styled after an analog dial rather
/// than a generic circular percent indicator — quiet tick marks around the
/// rim, a soft arc showing budget used, and the remaining balance set in
/// mono type at the center.
class LedgerRing extends StatelessWidget {
  final double fraction; // 0..1 of budget used
  final String centerLabel;
  final String centerValue;

  const LedgerRing({
    super.key,
    required this.fraction,
    required this.centerLabel,
    required this.centerValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 176,
      height: 176,
      child: CustomPaint(
        painter: _RingPainter(fraction: fraction.clamp(0.0, 1.0)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerValue,
                style: AppText.mono.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                centerLabel,
                style: AppText.body.copyWith(fontSize: 11, color: AppColors.muted, letterSpacing: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double fraction;
  _RingPainter({required this.fraction});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Tick marks around the rim — evenly spaced, longer every 5th tick.
    const tickCount = 40;
    for (int i = 0; i < tickCount; i++) {
      final angle = (i / tickCount) * 2 * math.pi;
      final isMajor = i % 5 == 0;
      final outer = radius - 2;
      final inner = radius - (isMajor ? 10 : 5);
      final p1 = center + Offset(math.cos(angle) * outer, math.sin(angle) * outer);
      final p2 = center + Offset(math.cos(angle) * inner, math.sin(angle) * inner);
      final tickPaint = Paint()
        ..color = AppColors.line
        ..strokeWidth = isMajor ? 2 : 1;
      canvas.drawLine(p1, p2, tickPaint);
    }

    // Track
    final trackRadius = radius - 22;
    final trackPaint = Paint()
      ..color = AppColors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, trackRadius, trackPaint);

    // Progress arc, starting at the top (-90deg)
    final progressPaint = Paint()
      ..color = fraction < 0.85 ? AppColors.accent : AppColors.expense
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromCircle(center: center, radius: trackRadius);
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * fraction;
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.fraction != fraction;
}
