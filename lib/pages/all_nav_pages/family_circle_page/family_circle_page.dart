import 'package:flutter/material.dart';

class FamilyCirclePage extends StatelessWidget {
  const FamilyCirclePage({super.key});

  // ---------------------------------------------------------------------------
  // Colors
  // ---------------------------------------------------------------------------
  static const Color backgroundColor = Color(0xFF0A0A0F);
  static const Color cardColor = Color(0xFF12151A);
  static const Color mapColor = Color(0xFF17251F);
  static const Color cyanColor = Color(0xFF00D9C6);
  static const Color borderColor = Color(0xFF252B31);
  static const Color mutedTextColor = Color(0xFF8B949E);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------------------------------------------------
              // Header
              // ----------------------------------------------------------------
              const Text(
                'Family Circle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 18),

              // ----------------------------------------------------------------
              // Map / List segmented toggle
              // ----------------------------------------------------------------
              _buildViewToggle(),

              const SizedBox(height: 16),

              // ----------------------------------------------------------------
              // Map placeholder
              //
              // Replace this section with GoogleMap when integrating:
              // GoogleMap(
              //   initialCameraPosition: ...,
              //   markers: ...,
              // )
              // ----------------------------------------------------------------
              _buildMap(),

              const SizedBox(height: 16),

              // ----------------------------------------------------------------
              // Family member cards
              // ----------------------------------------------------------------
              _buildFamilyMemberCard(
                name: 'My Car (You)',
                speed: '65 km/h',
                score: '812',
                icon: Icons.directions_car_rounded,
                isActive: true,
              ),

              const SizedBox(height: 10),

              _buildFamilyMemberCard(
                name: "Father's Car",
                speed: '48 km/h',
                score: '750',
                icon: Icons.directions_car_rounded,
              ),

              const SizedBox(height: 10),

              _buildFamilyMemberCard(
                name: "Son's Car",
                speed: '72 km/h',
                score: '690',
                icon: Icons.directions_car_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Segmented Map / List toggle
  // ---------------------------------------------------------------------------
  Widget _buildViewToggle() {
    return Container(
      height: 48,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF15191E),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Selected Map View
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cyanColor,
                borderRadius: BorderRadius.circular(21),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Map View',
                style: TextStyle(
                  color: Color(0xFF061313),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Unselected List View
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'List View',
                style: TextStyle(
                  color: Color(0xFF9AA3AB),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Map placeholder
  // ---------------------------------------------------------------------------
  Widget _buildMap() {
    return Container(
      height: 195,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: mapColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Dark map/grid background
          Positioned.fill(
            child: CustomPaint(
              painter: MapPlaceholderPainter(),
            ),
          ),

          // Small map labels / road information
          const Positioned(
            left: 18,
            top: 20,
            child: _MapLabel(
              text: 'FAMILY ZONE',
            ),
          ),

          const Positioned(
            right: 18,
            bottom: 20,
            child: _MapLabel(
              text: 'LIVE',
              showDot: true,
            ),
          ),

          // Family member map marker #1
          const Positioned(
            left: 82,
            top: 48,
            child: _MapAvatarMarker(
              icon: Icons.directions_car_rounded,
              color: cyanColor,
            ),
          ),

          // Family member map marker #2
          const Positioned(
            right: 72,
            bottom: 40,
            child: _MapAvatarMarker(
              icon: Icons.directions_car_rounded,
              color: cyanColor,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Family member card
  // ---------------------------------------------------------------------------
  Widget _buildFamilyMemberCard({
    required String name,
    required String speed,
    required String score,
    required IconData icon,
    bool isActive = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? const Color(0xFF1D4743)
              : borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // ---------------------------------------------------------------
          // Avatar
          //
          // Replace Icon with:
          // CircleAvatar(
          //   backgroundImage: NetworkImage(profileUrl),
          // )
          //
          // or AssetImage(...) for local profile images.
          // ---------------------------------------------------------------
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1B2929),
              border: Border.all(
                color: isActive
                    ? cyanColor.withOpacity(0.65)
                    : const Color(0xFF30383D),
                width: 1.2,
              ),
            ),
            child: Icon(
              icon,
              color: isActive
                  ? cyanColor
                  : const Color(0xFF9BA4AA),
              size: 24,
            ),
          ),

          const SizedBox(width: 13),

          // ---------------------------------------------------------------
          // Name + stats
          // ---------------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Speed: $speed',
                        style: const TextStyle(
                          color: mutedTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const TextSpan(
                        text: '  •  ',
                        style: TextStyle(
                          color: Color(0xFF555D64),
                          fontSize: 12,
                        ),
                      ),
                      const TextSpan(
                        text: 'Score: ',
                        style: TextStyle(
                          color: mutedTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: score,
                        style: const TextStyle(
                          color: Color(0xFFDCE4E8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ---------------------------------------------------------------
          // Arrow
          // ---------------------------------------------------------------
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF191D22),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF737C84),
              size: 21,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Map avatar marker
// =============================================================================

class _MapAvatarMarker extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _MapAvatarMarker({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.25),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF182124),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 23,
            ),
          ),
        ),

        // Small pin tail
        CustomPaint(
          size: const Size(12, 8),
          painter: MarkerTailPainter(
            color: color,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Small map label
// =============================================================================

class _MapLabel extends StatelessWidget {
  final String text;
  final bool showDot;

  const _MapLabel({
    required this.text,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF00D9C6),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF7F9992),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Map background painter
// =============================================================================

class MapPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint roadPaint = Paint()
      ..color = const Color(0xFF263C35)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final Paint minorRoadPaint = Paint()
      ..color = const Color(0xFF20342E)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint waterPaint = Paint()
      ..color = const Color(0xFF142C2C)
      ..style = PaintingStyle.fill;

    // ---------------------------------------------------------------
    // Subtle water/land area
    // ---------------------------------------------------------------
    final Path waterPath = Path()
      ..moveTo(size.width * 0.70, 0)
      ..quadraticBezierTo(
        size.width * 0.58,
        size.height * 0.30,
        size.width * 0.73,
        size.height * 0.52,
      )
      ..quadraticBezierTo(
        size.width * 0.86,
        size.height * 0.72,
        size.width,
        size.height * 0.62,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(waterPath, waterPaint);

    // ---------------------------------------------------------------
    // Major roads
    // ---------------------------------------------------------------
    final Path road1 = Path()
      ..moveTo(-20, size.height * 0.76)
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.50,
        size.width + 30,
        size.height * 0.25,
      );

    final Path road2 = Path()
      ..moveTo(size.width * 0.10, -20)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.42,
        size.width * 0.54,
        size.height + 20,
      );

    final Path road3 = Path()
      ..moveTo(size.width * 0.42, -20)
      ..quadraticBezierTo(
        size.width * 0.62,
        size.height * 0.30,
        size.width + 20,
        size.height * 0.72,
      );

    canvas.drawPath(road1, roadPaint);
    canvas.drawPath(road2, roadPaint);
    canvas.drawPath(road3, roadPaint);

    // ---------------------------------------------------------------
    // Smaller roads
    // ---------------------------------------------------------------
    final Path minor1 = Path()
      ..moveTo(0, size.height * 0.30)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.40,
        size.width,
        size.height * 0.10,
      );

    final Path minor2 = Path()
      ..moveTo(0, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.40,
        size.height * 0.70,
        size.width,
        size.height * 0.48,
      );

    final Path minor3 = Path()
      ..moveTo(size.width * 0.25, size.height)
      ..quadraticBezierTo(
        size.width * 0.40,
        size.height * 0.60,
        size.width * 0.82,
        0,
      );

    canvas.drawPath(minor1, minorRoadPaint);
    canvas.drawPath(minor2, minorRoadPaint);
    canvas.drawPath(minor3, minorRoadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// =============================================================================
// Marker tail painter
// =============================================================================

class MarkerTailPainter extends CustomPainter {
  final Color color;

  MarkerTailPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MarkerTailPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}