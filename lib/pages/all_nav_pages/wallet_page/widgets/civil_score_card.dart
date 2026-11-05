import 'package:flutter/material.dart';

class CivilScoreCard extends StatelessWidget {
  final int civilScore;
  final String civilRating;
  final int activeStreakProtections;

  const CivilScoreCard({
    super.key,
    required this.civilScore,
    required this.civilRating,
    required this.activeStreakProtections,
  });

  static const Color blueGreyBorder = Color(0xFF263B4D);
  static const Color blueGreyBackground = Color(0xFF101A24);
  static const Color accentCyan = Color(0xFF00D9E8);

  Color get _ratingColor {
    switch (civilRating.toUpperCase()) {
      case 'EXCELLENT':
        return const Color(0xFF35D58A);
      case 'GOOD':
        return const Color(0xFF00D9E8);
      case 'FAIR':
        return const Color(0xFFFFA62B);
      case 'POOR':
        return const Color(0xFFFF5252);
      default:
        return const Color(0xFF00D9E8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (civilScore / 1000.0).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 16),
      decoration: BoxDecoration(
        color: blueGreyBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: blueGreyBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Civil Score',
                          style: TextStyle(
                            color: Color(0xFFD5D8DC),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: _ratingColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _ratingColor.withValues(alpha: 0.4),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            civilRating,
                            style: TextStyle(
                              color: _ratingColor,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Score with dimmed /1000
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$civilScore',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const TextSpan(
                            text: ' /1000',
                            style: TextStyle(
                              color: Color(0xFF8C949E),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Streak protection badge & info icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shield_rounded,
                            size: 13, color: Color(0xFF38BDF8)),
                        const SizedBox(width: 4),
                        Text(
                          '$activeStreakProtections Active',
                          style: const TextStyle(
                            color: Color(0xFF38BDF8),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Score progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: const Color(0xFF1B2936),
              valueColor: AlwaysStoppedAnimation<Color>(_ratingColor),
            ),
          ),
        ],
      ),
    );
  }
}

