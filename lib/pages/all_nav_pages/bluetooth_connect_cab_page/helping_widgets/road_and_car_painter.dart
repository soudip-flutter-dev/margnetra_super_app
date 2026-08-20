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
      ..moveTo(centerX - size.width * .045, horizonY)
      ..lineTo(centerX + size.width * .045, horizonY)
      ..lineTo(size.width * .80, bottomY)
      ..lineTo(size.width * .20, bottomY)
      ..close();

    final roadPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x00070D11), Color(0xFF071117), Color(0xFF04080B)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(roadPath, roadPaint);

    // -------------------------------------------------------------------------
    // Perspective road edges
    // -------------------------------------------------------------------------

    final edgePaint = Paint()
      ..color = const Color(0xFF00B8D4).withOpacity(.17)
      ..strokeWidth = .8;

    canvas.drawLine(
      Offset(centerX - size.width * .045, horizonY),
      Offset(size.width * .20, bottomY),
      edgePaint,
    );

    canvas.drawLine(
      Offset(centerX + size.width * .045, horizonY),
      Offset(size.width * .80, bottomY),
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

    _drawCar(canvas, Offset(centerX, size.height * .69));
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

      final x1 = centerX + (baseX - centerX) * startProgress;

      final y1 = horizonY + (size.height - horizonY) * startProgress;

      final x2 = centerX + (baseX - centerX) * endProgress;

      final y2 = horizonY + (size.height - horizonY) * endProgress;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  // ===========================================================================
  // CAR
  // ===========================================================================

  void _drawCar(Canvas canvas, Offset center) {
    const width = 54.0;

    // Ground glow and wheels sit behind the front body.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 13),
        width: width + 8,
        height: 13,
      ),
      Paint()
        ..color = const Color(0xFF00D9FF).withOpacity(.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );

    final wheelPaint = Paint()..color = const Color(0xFF020609);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - 22, center.dy + 5),
        width: 7,
        height: 15,
      ),
      wheelPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + 22, center.dy + 5),
        width: 7,
        height: 15,
      ),
      wheelPaint,
    );

    // Symmetrical front body: narrow roof, broad shoulders, rounded bumper.
    final bodyPath = Path()
      ..moveTo(center.dx - 18, center.dy - 14)
      ..quadraticBezierTo(
        center.dx - 24,
        center.dy - 7,
        center.dx - 25,
        center.dy + 2,
      )
      ..lineTo(center.dx - 27, center.dy + 9)
      ..quadraticBezierTo(
        center.dx - 26,
        center.dy + 14,
        center.dx - 20,
        center.dy + 15,
      )
      ..lineTo(center.dx + 20, center.dy + 15)
      ..quadraticBezierTo(
        center.dx + 26,
        center.dy + 14,
        center.dx + 27,
        center.dy + 9,
      )
      ..lineTo(center.dx + 25, center.dy + 2)
      ..quadraticBezierTo(
        center.dx + 24,
        center.dy - 7,
        center.dx + 18,
        center.dy - 14,
      )
      ..close();

    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF183944), Color(0xFF071218), Color(0xFF02080C)],
      ).createShader(Rect.fromCenter(center: center, width: width, height: 32));

    canvas.drawPath(bodyPath, bodyPaint);
    canvas.drawPath(
      bodyPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..color = const Color(0xFF20DDF4).withOpacity(.9),
    );

    // Split windshield and roof glass show which side is the front of the car.
    final glassPath = Path()
      ..moveTo(center.dx - 15, center.dy - 11)
      ..quadraticBezierTo(
        center.dx,
        center.dy - 16,
        center.dx + 15,
        center.dy - 11,
      )
      ..lineTo(center.dx + 12, center.dy - 2)
      ..lineTo(center.dx - 12, center.dy - 2)
      ..close();

    canvas.drawPath(
      glassPath,
      Paint()..color = const Color(0xFF0A2D38).withOpacity(.95),
    );
    canvas.drawPath(
      glassPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = .8
        ..color = const Color(0xFF55E9F8).withOpacity(.65),
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - 12),
      Offset(center.dx, center.dy - 3),
      Paint()
        ..color = const Color(0xFF55E9F8).withOpacity(.4)
        ..strokeWidth = .7,
    );

    // Side mirrors add a recognizable car silhouette.
    final mirrorPaint = Paint()
      ..color = const Color(0xFF35E7FA).withOpacity(.8);
    canvas.drawCircle(Offset(center.dx - 26, center.dy - 2), 2, mirrorPaint);
    canvas.drawCircle(Offset(center.dx + 26, center.dy - 2), 2, mirrorPaint);

    // Hood crease and front grille.
    final detailPaint = Paint()
      ..color = const Color(0xFF35E7FA).withOpacity(.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8;
    canvas.drawLine(
      Offset(center.dx - 15, center.dy + 1),
      Offset(center.dx + 15, center.dy + 1),
      detailPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + 9),
          width: 16,
          height: 4,
        ),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF35E7FA).withOpacity(.58),
    );

    // Bright front headlights and a thin lower bumper complete the face.
    final headlightGlow = Paint()
      ..color = const Color(0xFF00D9FF).withOpacity(.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    final headlightCore = Paint()..color = Colors.white;

    for (final x in [-17.0, 17.0]) {
      final lightCenter = Offset(center.dx + x, center.dy + 6);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: lightCenter, width: 6, height: 3.5),
          const Radius.circular(1.5),
        ),
        headlightGlow,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: lightCenter, width: 3.5, height: 1.5),
          const Radius.circular(.75),
        ),
        headlightCore,
      );
    }

    canvas.drawLine(
      Offset(center.dx - 20, center.dy + 14),
      Offset(center.dx + 20, center.dy + 14),
      Paint()
        ..color = const Color(0xFF20DDF4).withOpacity(.85)
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant RoadAndCarPainter oldDelegate) {
    return false;
  }
}
