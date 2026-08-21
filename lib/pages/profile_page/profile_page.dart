import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/app_page_route/app_page_route.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  // Theme colors
  static const Color backgroundColor = Color(0xFF0A0A0F);
  static const Color cardColor = Color(0xFF111116);
  static const Color borderColor = Color(0xFF25252D);
  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color mutedText = Color(0xFF8A8A95);
  static const Color whiteText = Color(0xFFF5F5F5);
  static const Color destructiveRed = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // HEADER
              // ============================================================
              const Text(
                'Profile',
                style: TextStyle(
                  color: whiteText,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 20),

              // ============================================================
              // USER INFORMATION CARD
              // ============================================================
              _buildUserInfoCard(),

              const SizedBox(height: 14),

              // ============================================================
              // CIVIL SCORE CARD
              // ============================================================
              _buildCivilScoreCard(),

              const SizedBox(height: 20),

              // ============================================================
              // SETTINGS / MENU LIST
              // ============================================================
              _buildMenuItem(
                icon: Icons.directions_car_outlined,
                title: 'My Vehicles',
                trailingText: '2 Vehicles',
              ),

              const SizedBox(height: 10),

              _buildMenuItem(
                icon: Icons.payment_outlined,
                title: 'Payment Methods',
                trailingText: 'UPI, Cards',
              ),

              const SizedBox(height: 10),

              _buildMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Notification Settings',
              ),

              const SizedBox(height: 10),

              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'App Settings',
                onTap: () {
                  Navigator.pushNamed(context, AppPageRoute.settingsPage);
                },
              ),

              const SizedBox(height: 10),

              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
              ),

              const SizedBox(height: 10),

              // ============================================================
              // LOGOUT / DESTRUCTIVE ACTION
              // ============================================================
              _buildLogoutItem(),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------------
  // User information card
  // ------------------------------------------------------------------------
  Widget _buildUserInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Profile avatar.
          //
          // Replace this CircleAvatar with a NetworkImage or AssetImage
          // when a real profile photo is available.
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF173B2A),
            child: Icon(
              Icons.person,
              size: 32,
              color: primaryGreen.withOpacity(0.9),
            ),

            // Example:
            // backgroundImage: NetworkImage('https://example.com/photo.jpg'),
          ),

          const SizedBox(width: 14),

          // User details.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Amit Sharma',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: whiteText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '+91 98765 43210',
                  style: TextStyle(
                    color: mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'amit@example.com',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Profile navigation arrow.
          const Icon(
            Icons.chevron_right,
            color: Color(0xFF777780),
            size: 23,
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------------
  // Civil Score card
  // ------------------------------------------------------------------------
  Widget _buildCivilScoreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 17),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score title and verification badge.
          Row(
            children: [
              const Text(
                'Civil Score',
                style: TextStyle(
                  color: whiteText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),

              // Cyan verification badge.
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFF164E63),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: Color(0xFF67E8F9),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Score number.
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                '812',
                style: TextStyle(
                  color: primaryGreen,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              SizedBox(width: 5),
              Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Text(
                  '/1000',
                  style: TextStyle(
                    color: mutedText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          // Score description.
          const Text(
            'Great Driver! Keep it up.',
            style: TextStyle(
              color: primaryGreen,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          // Progress bar.
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  height: 6,
                  width: double.infinity,
                  color: const Color(0xFF252A2A),
                ),
                FractionallySizedBox(
                  widthFactor: 0.812,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------------
  // Generic settings menu item
  // ------------------------------------------------------------------------
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Leading icon.
            Icon(
              icon,
              size: 22,
              color: const Color(0xFFB0B0B8),
            ),
      
            const SizedBox(width: 14),
      
            // Menu title.
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: whiteText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
      
            // Optional trailing value.
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: const TextStyle(
                  color: mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 7),
            ],
      
            // Navigation arrow.
            const Icon(
              Icons.chevron_right,
              size: 22,
              color: Color(0xFF777780),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------------
  // Logout item
  // ------------------------------------------------------------------------
  Widget _buildLogoutItem() {
    return Container(
      width: double.infinity,
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1012),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF3A1D21),
          width: 1,
        ),
      ),
      child: Row(
        children: const [
          Icon(
            Icons.logout,
            size: 22,
            color: destructiveRed,
          ),
          SizedBox(width: 14),
          Text(
            'Logout',
            style: TextStyle(
              color: destructiveRed,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}