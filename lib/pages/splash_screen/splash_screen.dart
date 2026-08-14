import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:margnetra_super_app/pages/intro_slider_page/intro_slider_page.dart';

class MargNetraSplash extends StatefulWidget {
  const MargNetraSplash({super.key});

  @override
  State<MargNetraSplash> createState() => _MargNetraSplashState();
}

class _MargNetraSplashState extends State<MargNetraSplash>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _cabController;
  late AnimationController _roadController;
  late AnimationController _shineController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _cabHeadlightOpacity;

  Timer? _startupTimer;
  Timer? _cabStartTimer;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
     
    // ----------------------------------------------------------
    // LOGO ANIMATION
    // ----------------------------------------------------------

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    );

    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );

    // ----------------------------------------------------------
    // CAB ANIMATION
    // ----------------------------------------------------------

    _cabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    );

    _cabHeadlightOpacity = Tween<double>(begin: 1.0, end: 0.0).chain(
      CurveTween(curve: Curves.easeInOutCubic),
    ).animate(_cabController);

    // ----------------------------------------------------------
    // ROAD ANIMATION
    // ----------------------------------------------------------

    _roadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    // ----------------------------------------------------------
    // LOGO SHINE
    // ----------------------------------------------------------

    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _startAnimation();
    _pageNavigation(context);
  }

 Future <void> _pageNavigation(BuildContext context) async{
   try{
    await Future.delayed(const Duration(seconds: 10), () {
      // Navigate to login/home here.
      //
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => IntroSliderPage(),
        ),
      );
    });
   }catch(e){
    debugPrint("Error in navigation: $e");
   }
  }

  void _startAnimation() {
    _startupTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _logoController.forward();

      _cabStartTimer = Timer(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        _cabController.forward();

        _navigationTimer = Timer(const Duration(milliseconds: 4800), () {
          if (!mounted) return;

          // Navigate to login/home here.
          //
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => const LoginScreen(),
          //   ),
          // );
        });
      });
    });
  }

  @override
  void dispose() {
    _startupTimer?.cancel();
    _cabStartTimer?.cancel();
    _navigationTimer?.cancel();
    _logoController.dispose();
    _cabController.dispose();
    _roadController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              // ------------------------------------------------
              // BACKGROUND
              // ------------------------------------------------

              const Positioned.fill(
                child: _PremiumBackground(),
              ),

              // ------------------------------------------------
              // TOP BLUE GLOW
              // ------------------------------------------------

              Positioned(
                top: height * 0.08,
                left: width * 0.15,
                right: width * 0.15,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00BFFF).withOpacity(0.12),
                        blurRadius: 100,
                        spreadRadius: 25,
                      ),
                    ],
                  ),
                ),
              ),

              // ------------------------------------------------
              // LOGO
              // ------------------------------------------------

              Positioned(
                top: height * 0.13,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _logoOpacity,
                      child: Transform.scale(
                        scale: 0.75 + (_logoScale.value * 0.25),
                        child: child,
                      ),
                    );
                  },
                  child: Center(
                    child: SizedBox(
                      width: width * 0.78,
                      child: AnimatedBuilder(
                        animation: _shineController,
                        builder: (context, child) {
                          return ShaderMask(
                            shaderCallback: (bounds) {
                              final position =
                                  (_shineController.value * 2.5) - 0.75;

                              return LinearGradient(
                                begin: Alignment(-1.0 + position, 0),
                                end: Alignment(0.2 + position, 0),
                                colors: const [
                                  Colors.transparent,
                                  Colors.white10,
                                  Colors.white54,
                                  Colors.transparent,
                                ],
                                stops: const [
                                  0.0,
                                  0.45,
                                  0.52,
                                  1.0,
                                ],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.srcATop,
                            child: child,
                          );
                        },
                        child: Image.asset(
                          'assets/icon/app_logo_without_bg.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ------------------------------------------------
              // TAGLINE
              // ------------------------------------------------

              Positioned(
                top: height * 0.55,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _logoOpacity,
                  child: Column(
                    children: [
                      Text(
                        'MARGNETRA',
                        style: TextStyle(
                          fontSize: width * 0.065,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.5,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [
                                Color(0xFFFFFFFF),
                                Color(0xFF8FDFFF),
                                Color(0xFFFFFFFF),
                              ],
                            ).createShader(
                              const Rect.fromLTWH(
                                0,
                                0,
                                350,
                                60,
                              ),
                            ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'TRUSTED MOBILITY & REWARDS',
                        style: TextStyle(
                          color: Color(0xFF7FDFFF),
                          fontSize: 10,
                          letterSpacing: 2.1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ------------------------------------------------
              // ROAD
              // ------------------------------------------------

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: height * 0.28,
                child: AnimatedBuilder(
                  animation: _roadController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: RoadPainter(
                        progress: _roadController.value,
                      ),
                    );
                  },
                ),
              ),

              // ------------------------------------------------
              // ANIMATED CAB
              // ------------------------------------------------

              AnimatedBuilder(
                animation: _cabController,
                builder: (context, child) {
                  final value = Curves.easeInOutCubic.transform(
                    _cabController.value,
                  );

                  final x = width * 0.5 - 58;
                  final y = height * 0.72 + (math.sin(value * math.pi) * 10);
                  final scale = 1.0;

                  return Positioned(
                    left: 30,
                    right: 30,
                    bottom : 50,
                    child: Transform.scale(
                      scale: scale,
                      child: Image.asset("assets/img/blue_lamborghini_trans_bg.png")
                      // child: _AnimatedCab(
                      //   headlightOpacity: _cabHeadlightOpacity.value,
                      // ),
                    ),
                  );
                },
              ),

              // ------------------------------------------------
              // BOTTOM GLOW
              // ------------------------------------------------

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF00BFFF).withOpacity(0.08),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


// ============================================================
// PREMIUM BACKGROUND
// ============================================================

class _PremiumBackground extends StatelessWidget {
  const _PremiumBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.45),
          radius: 1.15,
          colors: [
            Color(0xFF10212C),
            Color(0xFF061017),
            Color(0xFF010509),
          ],
          stops: [
            0.0,
            0.52,
            1.0,
          ],
        ),
      ),
      child: CustomPaint(
        painter: BackgroundGridPainter(),
      ),
    );
  }
}


// ============================================================
// BACKGROUND GRID
// ============================================================

class BackgroundGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1B4C60).withOpacity(0.08)
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 35) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y < size.height; y += 35) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


// ============================================================
// ROAD
// ============================================================

class RoadPainter extends CustomPainter {
  final double progress;

  RoadPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // ------------------------------------------
    // ROAD OUTLINE
    // ------------------------------------------

    final roadPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF005A78),
          Color(0xFF00D9FF),
          Color(0xFF005A78),
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, width, height),
      );

    final leftRoad = Path()
      ..moveTo(width * 0.03, height)
      ..lineTo(width * 0.46, height * 0.05);

    final rightRoad = Path()
      ..moveTo(width * 0.97, height)
      ..lineTo(width * 0.54, height * 0.05);

    canvas.drawPath(leftRoad, roadPaint);
    canvas.drawPath(rightRoad, roadPaint);

    // ------------------------------------------
    // INNER ROAD LINES
    // ------------------------------------------

    final innerPaint = Paint()
      ..color = const Color(0xFF008EB7).withOpacity(0.7)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final innerLeft = Path()
      ..moveTo(width * 0.19, height)
      ..lineTo(width * 0.48, height * 0.20);

    final innerRight = Path()
      ..moveTo(width * 0.81, height)
      ..lineTo(width * 0.52, height * 0.20);

    canvas.drawPath(innerLeft, innerPaint);
    canvas.drawPath(innerRight, innerPaint);

    // ------------------------------------------
    // CENTER ROAD MARKINGS
    // ------------------------------------------

    final dashPaint = Paint()
      ..color = const Color(0xFF8EEBFF)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final raw = (i / 12 + progress) % 1.0;

      final perspective = raw * raw;

      final y = height * (0.08 + perspective * 0.92);

      final dashLength = 4 + perspective * 14;

      final x = width * 0.5;

      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + dashLength),
        dashPaint,
      );
    }

    // ------------------------------------------
    // BLUE ROAD GLOW
    // ------------------------------------------

    final glow = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF00BFFF).withOpacity(0.12),
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          width,
          height,
        ),
      );

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        height * 0.55,
        width,
        height * 0.45,
      ),
      glow,
    );
  }

  @override
  bool shouldRepaint(covariant RoadPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}


// ============================================================
// ANIMATED CAB
// ============================================================

class _AnimatedCab extends StatelessWidget {
  const _AnimatedCab({required this.headlightOpacity});

  final double headlightOpacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 105,
      height: 65,
      child: Stack(
        children: [
          // Front glow that fades out smoothly as the cab moves ahead.
          Positioned(
            left: 88,
            top: 31,
            child: Opacity(
              opacity: headlightOpacity,
              child: Container(
                width: 26,
                height: 14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00DFFF).withOpacity(0.55),
                      blurRadius: 16,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Visible front bumper and body
          Positioned(
            left: 5,
            top: 28,
            child: Container(
              width: 92,
              height: 27,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF30D7FF),
                    Color(0xFF087B9F),
                    Color(0xFF063B4D),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFF74EDFF),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00BFFF).withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
          ),

          // Strong front bumper line so the cab reads as front-facing.
          Positioned(
            right: 0,
            top: 33,
            child: Container(
              width: 13,
              height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF9AF3FF).withOpacity(0.9),
              ),
            ),
          ),

          // Visible front accent for the cab face.
          Positioned(
            right: 4,
            top: 31,
            child: Opacity(
              opacity: headlightOpacity,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFFC9F7FF),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF66EEFF).withOpacity(0.8),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Cabin
          Positioned(
            left: 26,
            top: 13,
            child: ClipPath(
              clipper: CabRoofClipper(),
              child: Container(
                width: 54,
                height: 28,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF163E4E),
                      Color(0xFF071A23),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Windows
          Positioned(
            left: 30,
            top: 16,
            child: Container(
              width: 19,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF08131A),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: const Color(0xFF65E8FF),
                  width: 0.7,
                ),
              ),
            ),
          ),

          Positioned(
            left: 51,
            top: 16,
            child: Container(
              width: 22,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF08131A),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: const Color(0xFF65E8FF),
                  width: 0.7,
                ),
              ),
            ),
          ),

          // Front headlight fades gently while the cab drives ahead.
          Positioned(
            right: 3,
            top: 35,
            child: Opacity(
              opacity: headlightOpacity,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEFFFFF),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF00E5FF),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Back light
          Positioned(
            left: 4,
            top: 36,
            child: Container(
              width: 6,
              height: 7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFF4050),
              ),
            ),
          ),

          // Wheels
          const Positioned(
            left: 18,
            bottom: 3,
            child: _Wheel(),
          ),

          const Positioned(
            right: 17,
            bottom: 3,
            child: _Wheel(),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// CAB ROOF
// ============================================================

class CabRoofClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(3, size.height)
      ..lineTo(13, 3)
      ..quadraticBezierTo(
        size.width / 2,
        0,
        size.width - 10,
        3,
      )
      ..lineTo(
        size.width - 3,
        size.height,
      )
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}


// ============================================================
// WHEEL
// ============================================================

class _Wheel extends StatelessWidget {
  const _Wheel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF020508),
        border: Border.all(
          color: const Color(0xFF76E9FF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BFFF).withOpacity(0.25),
            blurRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF4BA8BD),
          ),
        ),
      ),
    );
  }
}