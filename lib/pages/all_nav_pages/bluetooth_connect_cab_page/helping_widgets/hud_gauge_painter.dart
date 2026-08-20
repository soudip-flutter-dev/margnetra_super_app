
import 'dart:math' as math;

import 'package:flutter/material.dart';

class HudGaugePainter extends CustomPainter {
  final double speed;

  HudGaugePainter({
    required this.speed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height * .51,
    );

    final radius = math.min(
          size.width,
          size.height,
        ) *
        .39;

    const startAngle = math.pi * .75;
    const sweepAngle = math.pi * 1.5;

    // -------------------------------------------------------------------------
    // Outer cyan glow
    // -------------------------------------------------------------------------

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF00D9FF).withOpacity(.20)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        10,
      );

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      startAngle,
      sweepAngle,
      false,
      glowPaint,
    );

    // -------------------------------------------------------------------------
    // Main gradient arc
    // -------------------------------------------------------------------------

    final gaugeRect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [
          Color(0xFF006C8B),
          Color(0xFF00BFE7),
          Color(0xFF00F1FF),
          Color(0xFF00BFE7),
          Color(0xFF006C8B),
        ],
      ).createShader(gaugeRect);

    canvas.drawArc(
      gaugeRect,
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // -------------------------------------------------------------------------
    // Second thin inner arc
    // -------------------------------------------------------------------------

    final innerArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .7
      ..color = const Color(0xFF008AA4).withOpacity(.65);

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius - 13,
      ),
      startAngle + .01,
      sweepAngle - .02,
      false,
      innerArcPaint,
    );

    // -------------------------------------------------------------------------
    // Tick marks
    // -------------------------------------------------------------------------

    const int totalTicks = 40;

    for (int i = 0; i <= totalTicks; i++) {
      final progress = i / totalTicks;
      final angle = startAngle + sweepAngle * progress;

      final major = i % 5 == 0;

      final outerRadius = radius - 2;
      final innerRadius = major ? radius - 13 : radius - 8;

      final start = Offset(
        center.dx + math.cos(angle) * outerRadius,
        center.dy + math.sin(angle) * outerRadius,
      );

      final end = Offset(
        center.dx + math.cos(angle) * innerRadius,
        center.dy + math.sin(angle) * innerRadius,
      );

      final tickPaint = Paint()
        ..color = major
            ? const Color(0xFF4CD8EB)
            : const Color(0xFF23798A).withOpacity(.65)
        ..strokeWidth = major ? 1.1 : .6;

      canvas.drawLine(
        start,
        end,
        tickPaint,
      );
    }

    // -------------------------------------------------------------------------
    // Speed marker
    // -------------------------------------------------------------------------

    const maxSpeed = 160.0;

    final speedProgress =
        (speed / maxSpeed).clamp(0.0, 1.0);

    final markerAngle =
        startAngle + sweepAngle * speedProgress;

    final markerStart = Offset(
      center.dx + math.cos(markerAngle) * (radius + 3),
      center.dy + math.sin(markerAngle) * (radius + 3),
    );

    final markerEnd = Offset(
      center.dx + math.cos(markerAngle) * (radius - 11),
      center.dy + math.sin(markerAngle) * (radius - 11),
    );

    // Glow
    final markerGlow = Paint()
      ..color = const Color(0xFF00E8FF).withOpacity(.65)
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        5,
      );

    canvas.drawLine(
      markerStart,
      markerEnd,
      markerGlow,
    );

    // Sharp marker
    final markerPaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2;

    canvas.drawLine(
      markerStart,
      markerEnd,
      markerPaint,
    );

    // -------------------------------------------------------------------------
    // Speed scale numbers
    // -------------------------------------------------------------------------

    const values = [
      '0',
      '20',
      '40',
      '60',
      '80',
      '100',
      '120',
      '140',
      '160',
    ];

    for (int i = 0; i < values.length; i++) {
      final progress = i / (values.length - 1);

      final angle =
          startAngle + sweepAngle * progress;

      final numberRadius = radius - 26;

      final position = Offset(
        center.dx + math.cos(angle) * numberRadius,
        center.dy + math.sin(angle) * numberRadius,
      );

      final painter = TextPainter(
        text: TextSpan(
          text: values[i],
          style: const TextStyle(
            color: Color(0xFF608A95),
            fontSize: 5.5,
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      painter.layout();

      painter.paint(
        canvas,
        Offset(
          position.dx - painter.width / 2,
          position.dy - painter.height / 2,
        ),
      );
    }

    // -------------------------------------------------------------------------
    // Decorative circles
    // -------------------------------------------------------------------------

    final decorativePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .5
      ..color = const Color(0xFF00748B).withOpacity(.35);

    canvas.drawCircle(
      center,
      radius * .72,
      decorativePaint,
    );

    canvas.drawCircle(
      center,
      radius * .53,
      decorativePaint,
    );

    // -------------------------------------------------------------------------
    // Center vertical guide
    // -------------------------------------------------------------------------

    final guidePaint = Paint()
      ..color = const Color(0xFF0B5565).withOpacity(.35)
      ..strokeWidth = .5;

    canvas.drawLine(
      Offset(
        center.dx,
        center.dy - radius * .50,
      ),
      Offset(
        center.dx,
        center.dy + radius * .50,
      ),
      guidePaint,
    );
  }

  @override
  bool shouldRepaint(covariant HudGaugePainter oldDelegate) {
    return oldDelegate.speed != speed;
  }
}

