import 'package:flutter/material.dart';

class QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const QuickActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  static const Color tileBorder = Color(0xFF242932);
  static const Color tileBackground = Color(0xFF101318);
  static const Color accentBlue = Color(0xFF38BDF8);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: tileBackground,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: tileBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon badge
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: const Color(0xFF102C3A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF1B526A),
                  width: 0.8,
                ),
              ),
              child: Icon(
                icon,
                color: accentBlue,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // Action title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: accentBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF8E959F),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Right chevron
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF737A84),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

