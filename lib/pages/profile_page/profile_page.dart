import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_page_route/app_page_route.dart';
import 'package:margnetra_super_app/core/utils/custom_snack_bar.dart';
import 'package:margnetra_super_app/pages/auth_page/data/models/user_model.dart';
import 'package:margnetra_super_app/pages/auth_page/logic/blocs/auth_bloc/auth_bloc.dart';

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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: borderColor),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout, color: destructiveRed, size: 24),
              SizedBox(width: 10),
              Text(
                'Confirm Logout',
                style: TextStyle(
                  color: whiteText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to log out of your MargNetra account?',
            style: TextStyle(
              color: mutedText,
              fontSize: 14,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: mutedText, fontWeight: FontWeight.w500),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: destructiveRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthBloc>().add(const LogoutEvent());
              },
              child: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          final message = state.message != null && state.message!.isNotEmpty
              ? state.message!
              : 'Logged out successfully';
          CustomSnackBar.showSuccess(context, message);
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppPageRoute.loginPage,
            (route) => false,
          );
        } else if (state is AuthError) {
          CustomSnackBar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final UserModel? user =
            (state is AuthAuthenticated) ? state.user : null;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: Container(
            color: backgroundColor,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
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
                    _buildUserInfoCard(user),

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
                    _buildLogoutItem(
                      context: context,
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------------------
  // User information card
  // ------------------------------------------------------------------------
  Widget _buildUserInfoCard(UserModel? user) {
    final displayName =
        (user != null && user.name.trim().isNotEmpty) ? user.name : 'Amit Sharma';
    final displayPhone =
        (user != null && user.phone != null && user.phone!.trim().isNotEmpty)
            ? user.phone!
            : '+91 98765 43210';
    final displayEmail =
        (user != null && user.email.trim().isNotEmpty) ? user.email : 'amit@example.com';
    final avatarUrl = user?.avatarUrl;

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
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF173B2A),
            backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                ? NetworkImage(avatarUrl)
                : null,
            child: (avatarUrl == null || avatarUrl.isEmpty)
                ? Icon(
                    Icons.person,
                    size: 32,
                    color: primaryGreen.withValues(alpha: 0.9),
                  )
                : null,
          ),

          const SizedBox(width: 14),

          // User details.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: whiteText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  displayPhone,
                  style: const TextStyle(
                    color: mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  displayEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
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
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
      borderRadius: BorderRadius.circular(14),
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
  Widget _buildLogoutItem({
    required BuildContext context,
    required bool isLoading,
  }) {
    return InkWell(
      onTap: isLoading ? null : () => _showLogoutDialog(context),
      borderRadius: BorderRadius.circular(14),
      child: Container(
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
          children: [
            if (isLoading)
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: destructiveRed,
                ),
              )
            else
              const Icon(
                Icons.logout,
                size: 22,
                color: destructiveRed,
              ),
            const SizedBox(width: 14),
            Text(
              isLoading ? 'Logging out...' : 'Logout',
              style: const TextStyle(
                color: destructiveRed,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}