import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class BountyCaptureWidget extends StatelessWidget {
  const BountyCaptureWidget({super.key});

  // ---------------------------------------------------------------------------
  // Colors
  // ---------------------------------------------------------------------------
  static const Color _background = Color(0xFF0A0A0F);
  static const Color _cardColor = Color(0xFF111219);
  static const Color _borderColor = Color(0xFF292B34);

  static const Color _cyan = Color(0xFF00E5FF);
  static const Color _green = Color(0xFF22C55E);

  static const Color _textPrimary = Color(0xFFF5F7FA);
  static const Color _textSecondary = Color(0xFF8B8F9A);

  static const Color _red = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: 
    Container(
      color: _background,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------------------------------------------------
              // Header
              // ----------------------------------------------------------------
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).maybePop(),
                    borderRadius: BorderRadius.circular(24),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Bounty Capture',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ----------------------------------------------------------------
              // Recording Buffer heading
              // ----------------------------------------------------------------
              const Text(
                'Recording Buffer',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Capturing last 20 seconds',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 30),

              // ----------------------------------------------------------------
              // Glowing countdown ring
              // ----------------------------------------------------------------
              Center(
                child: SizedBox(
                  width: 210,
                  height: 210,
                  child: CustomPaint(
                    painter: _BountyProgressPainter(
                      progress: 0.96,
                      progressColor: _cyan,
                      backgroundColor: const Color(0xFF20242B),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            '20',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              height: 1,
                              letterSpacing: -1.5,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            'Seconds',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // ----------------------------------------------------------------
              // Status checklist card
              // ----------------------------------------------------------------
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _borderColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // ----------------------------------------------------------
                    // Video Captured
                    // ----------------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          _buildCompletedIcon(),

                          const SizedBox(width: 13),

                          const Expanded(
                            child: Text(
                              'Video Captured',
                              style: TextStyle(
                                color: _textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const Text(
                            '20s',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(width: 5),

                          const Icon(
                            Icons.chevron_right,
                            color: _textSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),

                    _buildDivider(),

                    // ----------------------------------------------------------
                    // Signing Data
                    // ----------------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          _buildCompletedIcon(),

                          const SizedBox(width: 13),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Signing Data',
                                  style: TextStyle(
                                    color: _textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Cryptographic Signature',
                                  style: TextStyle(
                                    color: _textSecondary,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          _buildSpinner(),
                        ],
                      ),
                    ),

                    _buildDivider(),

                    // ----------------------------------------------------------
                    // Uploading
                    // ----------------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          _buildPendingIcon(),

                          const SizedBox(width: 13),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Uploading',
                                  style: TextStyle(
                                    color: _textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Please wait...',
                                  style: TextStyle(
                                    color: _textSecondary,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          _buildSpinner(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ----------------------------------------------------------------
              // Footer buttons
              // ----------------------------------------------------------------
              Row(
                children: [
                  // Cancel button
                  SizedBox(
                    height: 56,
                    width: 102,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).maybePop();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _textPrimary,
                        side: const BorderSide(
                          color: Color(0xFF3A3D46),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFFB8BBC3),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Upload & Claim button
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Upload and claim action.
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _red,
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shadowColor: _red.withOpacity(0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'UPLOAD & CLAIM',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              '+50 MGC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
,);
 
  }

  // ---------------------------------------------------------------------------
  // Completed status icon
  // ---------------------------------------------------------------------------
  static Widget _buildCompletedIcon() {
    return Container(
      width: 27,
      height: 27,
      decoration: const BoxDecoration(
        color: _green,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 17,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Pending status icon
  // ---------------------------------------------------------------------------
  static Widget _buildPendingIcon() {
    return Container(
      width: 27,
      height: 27,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF555963),
          width: 1.5,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Small cyan loading spinner
  // ---------------------------------------------------------------------------
  static Widget _buildSpinner() {
    return const SizedBox(
      width: 19,
      height: 19,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(_cyan),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Checklist divider
  // ---------------------------------------------------------------------------
  static Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFF24262D),
      ),
    );
  }
}

// =============================================================================
// Glowing circular progress painter
// =============================================================================

class _BountyProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;

  const _BountyProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final double radius = math.min(
          size.width,
          size.height,
        ) /
        2 -
        14;

    // -------------------------------------------------------------------------
    // Background ring
    // -------------------------------------------------------------------------
    final Paint backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..color = backgroundColor;

    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );

    // -------------------------------------------------------------------------
    // Outer soft glow
    // -------------------------------------------------------------------------
    final Paint outerGlowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round
      ..color = progressColor.withOpacity(0.18)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        12,
      );

    final Rect rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final double sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      sweepAngle,
      false,
      outerGlowPaint,
    );

    // -------------------------------------------------------------------------
    // Strong inner glow
    // -------------------------------------------------------------------------
    final Paint innerGlowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..color = progressColor.withOpacity(0.55)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        5,
      );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      sweepAngle,
      false,
      innerGlowPaint,
    );

    // -------------------------------------------------------------------------
    // Main cyan progress stroke
    // -------------------------------------------------------------------------
    final Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..color = progressColor;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // -------------------------------------------------------------------------
    // Bright highlight at progress end
    // -------------------------------------------------------------------------
    final double endAngle = -math.pi / 2 + sweepAngle;

    final Offset endPoint = Offset(
      center.dx + radius * math.cos(endAngle),
      center.dy + radius * math.sin(endAngle),
    );

    final Paint dotGlowPaint = Paint()
      ..color = progressColor.withOpacity(0.45)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        7,
      );

    canvas.drawCircle(
      endPoint,
      7,
      dotGlowPaint,
    );

    final Paint dotPaint = Paint()
      ..color = progressColor;

    canvas.drawCircle(
      endPoint,
      4,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _BountyProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}