
import 'package:flutter/material.dart';

class RoadAndCarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    final horizonY = size.height * .03;
    final bottomY = size.height;

    // -------------------------------------------------------------------------
    // Perspective road
    // -------------------------------------------------------------------------

    final roadPath = Path()
      ..moveTo(
        centerX - size.width * .045,
        horizonY,
      )
      ..lineTo(
        centerX + size.width * .045,
        horizonY,
      )
      ..lineTo(
        size.width * .80,
        bottomY,
      )
      ..lineTo(
        size.width * .20,
        bottomY,
      )
      ..close();

    final roadPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x00070D11),
          Color(0xFF071117),
          Color(0xFF04080B),
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
      );

    canvas.drawPath(
      roadPath,
      roadPaint,
    );

    // -------------------------------------------------------------------------
    // Perspective road edges
    // -------------------------------------------------------------------------

    final edgePaint = Paint()
      ..color = const Color(0xFF00B8D4).withOpacity(.17)
      ..strokeWidth = .8;

    canvas.drawLine(
      Offset(
        centerX - size.width * .045,
        horizonY,
      ),
      Offset(
        size.width * .20,
        bottomY,
      ),
      edgePaint,
    );

    canvas.drawLine(
      Offset(
        centerX + size.width * .045,
        horizonY,
      ),
      Offset(
        size.width * .80,
        bottomY,
      ),
      edgePaint,
    );

    // -------------------------------------------------------------------------
    // Cyan lane lines
    // -------------------------------------------------------------------------

    _drawDashedPerspectiveLine(
      canvas,
      size,
      left: true,
      color: const Color(0xFF00D9FF),
    );

    _drawDashedPerspectiveLine(
      canvas,
      size,
      left: false,
      color: const Color(0xFF00D9FF),
    );

    // -------------------------------------------------------------------------
    // Yellow/orange secondary road lines
    // -------------------------------------------------------------------------

    _drawDashedPerspectiveLine(
      canvas,
      size,
      left: true,
      color: const Color(0xFFFFA726),
      offset: .055,
    );

    _drawDashedPerspectiveLine(
      canvas,
      size,
      left: false,
      color: const Color(0xFFFFA726),
      offset: .055,
    );

    // -------------------------------------------------------------------------
    // Car
    // -------------------------------------------------------------------------

    _drawCar(
      canvas,
      Offset(
        centerX,
        size.height * .69,
      ),
    );
  }

  // ===========================================================================
  // DASHED PERSPECTIVE LINE
  // ===========================================================================

  void _drawDashedPerspectiveLine(
    Canvas canvas,
    Size size, {
    required bool left,
    required Color color,
    double offset = 0,
  }) {
    final centerX = size.width / 2;

    final horizonY = size.height * .04;

    final baseX = left
        ? size.width * (.31 - offset)
        : size.width * (.69 + offset);

    final paint = Paint()
      ..color = color.withOpacity(.72)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 5; i++) {
      final startProgress = .20 + i * .17;
      final endProgress = startProgress + .065;

      final x1 = centerX +
          (baseX - centerX) * startProgress;

      final y1 = horizonY +
          (size.height - horizonY) * startProgress;

      final x2 = centerX +
          (baseX - centerX) * endProgress;

      final y2 = horizonY +
          (size.height - horizonY) * endProgress;

      canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        paint,
      );
    }
  }

  // ===========================================================================
  // CAR
  // ===========================================================================

  void _drawCar(
    Canvas canvas,
    Offset center,
  ) {
    const width = 48.0;
    const height = 26.0;

    // Car glow
    final glowPaint = Paint()
      ..color = const Color(0xFF00D9FF).withOpacity(.30)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        9,
      );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + 8,
        ),
        width: width,
        height: 13,
      ),
      glowPaint,
    );

    // -------------------------------------------------------------------------
    // Car body
    // -------------------------------------------------------------------------

    final bodyPath = Path()
      ..moveTo(
        center.dx - width * .48,
        center.dy + 7,
      )
      ..lineTo(
        center.dx - width * .36,
        center.dy - 5,
      )
      ..lineTo(
        center.dx - width * .20,
        center.dy - 11,
      )
      ..lineTo(
        center.dx + width * .20,
        center.dy - 11,
      )
      ..lineTo(
        center.dx + width * .36,
        center.dy - 5,
      )
      ..lineTo(
        center.dx + width * .48,
        center.dy + 7,
      )
      ..close();

    final bodyPaint = Paint()
      ..color = const Color(0xFF071218);

    canvas.drawPath(
      bodyPath,
      bodyPaint,
    );

    // Body outline
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFF20DDF4).withOpacity(.9);

    canvas.drawPath(
      bodyPath,
      outlinePaint,
    );

    // -------------------------------------------------------------------------
    // Windshield
    // -------------------------------------------------------------------------

    final windshieldPath = Path()
      ..moveTo(
        center.dx - 9,
        center.dy - 8,
      )
      ..lineTo(
        center.dx + 9,
        center.dy - 8,
      )
      ..lineTo(
        center.dx + 13,
        center.dy - 2,
      )
      ..lineTo(
        center.dx - 13,
        center.dy - 2,
      )
      ..close();

    canvas.drawPath(
      windshieldPath,
      Paint()..color = const Color(0xFF0A2A34),
    );

    canvas.drawPath(
      windshieldPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = .6
        ..color = const Color(0xFF35E7FA).withOpacity(.55),
    );

    // -------------------------------------------------------------------------
    // Headlights
    // -------------------------------------------------------------------------

    final headlightGlow = Paint()
      ..color = const Color(0xFF00D9FF).withOpacity(.9)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        5,
      );

    canvas.drawCircle(
      Offset(
        center.dx - 17,
        center.dy + 5,
      ),
      2.2,
      headlightGlow,
    );

    canvas.drawCircle(
      Offset(
        center.dx + 17,
        center.dy + 5,
      ),
      2.2,
      headlightGlow,
    );

    // Bright headlight core
    final headlightCore = Paint()
      ..color = Colors.white;

    canvas.drawCircle(
      Offset(
        center.dx - 17,
        center.dy + 5,
      ),
      1,
      headlightCore,
    );

    canvas.drawCircle(
      Offset(
        center.dx + 17,
        center.dy + 5,
      ),
      1,
      headlightCore,
    );
  }

  @override
  bool shouldRepaint(covariant RoadAndCarPainter oldDelegate) {
    return false;
  }
}