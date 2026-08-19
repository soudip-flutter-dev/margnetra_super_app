import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'dart:math' as math;
 

class HudDashboardWidget extends StatelessWidget {
  const HudDashboardWidget({super.key});

  // ---------------------------------------------------------------------------
  // COLORS
  // ---------------------------------------------------------------------------

  static const Color bgColor = Color(0xFF050A0E);
  static const Color cyan = Color(0xFF00D9FF);
  static const Color cyanLight = Color(0xFF39E8FF);
  static const Color cyanDark = Color(0xFF006B80);
  static const Color green = Color(0xFF00E676);
  static const Color red = Color(0xFFE71919);
  static const Color grey = Color(0xFF829097);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  width * 0.055,
                  12,
                  width * 0.055,
                  20,
                ),
                child: Column(
                  children: [
                    // =========================================================
                    // 1. LIVE DRIVING / SOS
                    // =========================================================
                    _buildStatusRow(),

                    const SizedBox(height: 2),

                    // =========================================================
                    // 2. SPEEDOMETER
                    // =========================================================
                    Container(
                      // color: Colors.red,
                      width: width,
                      height: width * 0.67,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: Size(
                              width,
                              width * 0.67,
                            ),
                            painter: _HudGaugePainter(
                              speed: 68,
                            ),
                          ),

                          // Speed value
                          Positioned(
                            top: width * 0.205,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: const [
                                Text(
                                  '68',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 42,
                                    fontWeight: FontWeight.w300,
                                    height: 1,
                                    letterSpacing: 1,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'km/h',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // =========================================================
                    // 3. RPM / G-FORCE
                    // =========================================================
                    _buildStatsRow(),

                    const SizedBox(height: 2),

                    // =========================================================
                    // 4. ROAD + CAR
                    // =========================================================
                    SizedBox(
                      height: width * 0.31,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: _RoadPainter(),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // =========================================================
                    // 5. TRIP EARNINGS
                    // =========================================================
                    _buildTripEarnings(),

                    const SizedBox(height: 9),

                    // =========================================================
                    // 6. BOUNTY CAPTURE
                    // =========================================================
                    _buildBountyButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // STATUS ROW
  // ===========================================================================

  Widget _buildStatusRow() {
    return SizedBox(
      
      height: 39,
      child: Row(
        children: [
          // Live driving icon
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: cyan,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: cyan.withOpacity(.35),
                  blurRadius: 7,
                ),
              ],
            ),
            child: const Icon(
              Icons.power_settings_new_rounded,
              color: AppColors.primaryHudCyan,
              size: 13,
            ),
          ),

          const SizedBox(width: 8),

          // Live Driving text
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live Driving',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .2,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    _ConnectionDot(),
                    SizedBox(width: 4),
                    Text(
                      'Connected',
                      style: TextStyle(
                        color: green,
                        fontSize: 7.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: .4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // SOS button
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.errorDangerRed,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.errorDangerRed.withOpacity(.45),
                  blurRadius: 9,
                  spreadRadius: 1,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'SOS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // STATS
  // ===========================================================================

  Widget _buildStatsRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _HudStat(
          title: 'RPM',
          value: '2450',
          alignment: CrossAxisAlignment.start,
        ),
        _HudStat(
          title: 'G-FORCE',
          value: '0.12G',
          alignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }

  // ===========================================================================
  // TRIP EARNINGS
  // ===========================================================================

  Widget _buildTripEarnings() {
    return Container(
      width: double.infinity,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: const Color(0xFF03120D),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF00B85A),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: green.withOpacity(.08),
            blurRadius: 10,
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Trip Earnings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Text(
            '+ 12 MGC',
            style: TextStyle(
              color: green,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: .3,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // BOUNTY BUTTON
  // ===========================================================================

  Widget _buildBountyButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: red.withOpacity(.28),
              blurRadius: 9,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorDangerRed,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            'BOUNTY CAPTURE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: .2,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// CONNECTION DOT
// =============================================================================

class _ConnectionDot extends StatelessWidget {
  const _ConnectionDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: Color(0xFF00E676),
        shape: BoxShape.circle,
      ),
    );
  }
}

// =============================================================================
// STAT WIDGET
// =============================================================================

class _HudStat extends StatelessWidget {
  final String title;
  final String value;
  final CrossAxisAlignment alignment;

  const _HudStat({
    required this.title,
    required this.value,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF829097),
            fontSize: 7.5,
            fontWeight: FontWeight.w500,
            letterSpacing: .6,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: .3,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// HUD SPEEDOMETER PAINTER
// =============================================================================

class _HudGaugePainter extends CustomPainter {
  final double speed;

  _HudGaugePainter({
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
  bool shouldRepaint(covariant _HudGaugePainter oldDelegate) {
    return oldDelegate.speed != speed;
  }
}

// =============================================================================
// ROAD / CAR PAINTER
// =============================================================================

class _RoadPainter extends CustomPainter {
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
  bool shouldRepaint(covariant _RoadPainter oldDelegate) {
    return false;
  }
}