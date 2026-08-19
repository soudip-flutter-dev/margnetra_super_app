import 'package:flutter/material.dart';

class MgcWalletWidget extends StatelessWidget {
  const MgcWalletWidget({super.key});

  // ─────────────────────────────────────────────────────────────
  // Color palette
  // ─────────────────────────────────────────────────────────────
  static const Color backgroundColor = Color(0xFF0A0A0F);

  static const Color greenBorder = Color(0xFF245B45);
  static const Color greenBackground = Color(0xFF10231C);

  static const Color amberBorder = Color(0xFF624829);
  static const Color amberBackground = Color(0xFF21180F);

  static const Color redBorder = Color(0xFF5E2E32);
  static const Color redBackground = Color(0xFF211113);

  static const Color blueGreyBorder = Color(0xFF263B4D);
  static const Color blueGreyBackground = Color(0xFF101A24);

  static const Color tileBorder = Color(0xFF242932);
  static const Color tileBackground = Color(0xFF101318);

  static const Color accentBlue = Color(0xFF38BDF8);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─────────────────────────────────────────────────
              // Header
              // ─────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'MGC Wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),

                  // 4 x 4 application/grid icon
                  _buildGridIcon(),
                ],
              ),

              const SizedBox(height: 20),

              // ─────────────────────────────────────────────────
              // Available MGC
              // ─────────────────────────────────────────────────
              _buildBalanceCard(
                label: 'Available MGC',
                value: '1,250',
                backgroundColor: greenBackground,
                borderColor: greenBorder,
              ),

              const SizedBox(height: 12),

              // ─────────────────────────────────────────────────
              // Provisional MGC
              // ─────────────────────────────────────────────────
              _buildBalanceCard(
                label: 'Provisional MGC',
                value: '45',
                backgroundColor: amberBackground,
                borderColor: amberBorder,
                topRightText: 'Settles in 24h',
              ),

              const SizedBox(height: 12),

              // ─────────────────────────────────────────────────
              // Held MGC
              // ─────────────────────────────────────────────────
              _buildBalanceCard(
                label: 'Held MGC',
                value: '0',
                backgroundColor: redBackground,
                borderColor: redBorder,
              ),

              const SizedBox(height: 12),

              // ─────────────────────────────────────────────────
              // Civil Score
              // ─────────────────────────────────────────────────
              _buildCivilScoreCard(),

              const SizedBox(height: 28),

              // ─────────────────────────────────────────────────
              // Quick Actions section title
              // ─────────────────────────────────────────────────
              const Text(
                'Quick Actions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.1,
                ),
              ),

              const SizedBox(height: 12),

              // ─────────────────────────────────────────────────
              // Redeem FASTAG action
              // ─────────────────────────────────────────────────
              _buildQuickAction(
                icon: Icons.local_taxi_rounded,
                title: 'REDEEM FASTAG',
                subtitle: 'Recharge your FASTag',
              ),

              const SizedBox(height: 10),

              // ─────────────────────────────────────────────────
              // Buy Streak Protection action
              // ─────────────────────────────────────────────────
              _buildQuickAction(
                icon: Icons.shield_rounded,
                title: 'BUY STREAK PROTECTION',
                subtitle: '(50 MGC)',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Header grid icon
  // ─────────────────────────────────────────────────────────────
  Widget _buildGridIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 16,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.65),
              borderRadius: BorderRadius.circular(1.5),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Generic balance card
  // ─────────────────────────────────────────────────────────────
  Widget _buildBalanceCard({
    required String label,
    required String value,
    required Color backgroundColor,
    required Color borderColor,
    String? topRightText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main card content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFD5D8DC),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // Optional settlement text + info icon
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (topRightText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    topRightText,
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              _buildInfoIcon(),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Civil Score card
  // ─────────────────────────────────────────────────────────────
  Widget _buildCivilScoreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 15),
      decoration: BoxDecoration(
        color: blueGreyBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: blueGreyBorder,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Civil Score',
                  style: TextStyle(
                    color: Color(0xFFD5D8DC),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),

                // Score with dimmed /1000
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '812',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
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

          _buildInfoIcon(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Small circular information icon
  // ─────────────────────────────────────────────────────────────
  Widget _buildInfoIcon() {
    return Container(
      width: 19,
      height: 19,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF8B929B),
          width: 1.2,
        ),
      ),
      child: const Text(
        'i',
        style: TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Quick Action tile
  // ─────────────────────────────────────────────────────────────
  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
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
    );
  }
}