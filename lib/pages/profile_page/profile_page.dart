import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_page_route/app_page_route.dart';
import 'package:margnetra_super_app/core/utils/custom_snack_bar.dart';
import 'package:margnetra_super_app/pages/auth_page/logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/profile_models.dart';
import 'package:margnetra_super_app/pages/profile_page/logic/blocs/profile_bloc/profile_bloc.dart';
import 'package:margnetra_super_app/pages/profile_page/logic/blocs/vehicle_bloc/vehicle_bloc.dart';
import 'package:margnetra_super_app/pages/profile_page/widgets/avatar_picker_sheet.dart';
import 'package:margnetra_super_app/pages/profile_page/widgets/edit_profile_dialog.dart';
import 'package:margnetra_super_app/pages/profile_page/widgets/payment_method_sheet.dart';
import 'package:margnetra_super_app/pages/profile_page/widgets/vehicle_garage_sheet.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  static const Color backgroundColor = Color(0xFF0A0A0F);
  static const Color cardColor = Color(0xFF111116);
  static const Color borderColor = Color(0xFF25252D);
  static const Color cyan = Color(0xFF16D9E3);
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
            style: TextStyle(color: mutedText, fontSize: 14),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel', style: TextStyle(color: mutedText, fontWeight: FontWeight.w500)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: destructiveRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthBloc>().add(const LogoutEvent());
              },
              child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthUnauthenticated) {
          CustomSnackBar.showSuccess(context, 'Logged out successfully');
          Navigator.pushNamedAndRemoveUntil(context, AppPageRoute.loginPage, (route) => false);
        } else if (authState is AuthError) {
          CustomSnackBar.showError(context, authState.message);
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: RefreshIndicator(
            color: cyan,
            backgroundColor: cardColor,
            onRefresh: () async {
              context.read<ProfileBloc>().add(const LoadProfileEvent(forceRefresh: true));
              context.read<VehicleBloc>().add(const LoadVehiclesEvent(forceRefresh: true));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Bar
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: whiteText,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // User Info Card
                  BlocConsumer<ProfileBloc, ProfileState>(
                    listener: (context, state) {
                      if (state is ProfileError) {
                        CustomSnackBar.showError(context, state.message);
                      } else if (state is ProfileUpdateSuccess) {
                        CustomSnackBar.showSuccess(context, state.message);
                      }
                    },
                    builder: (context, state) {
                      final UserProfileModel? profile = (state is ProfileLoaded)
                          ? state.profile
                          : (state is ProfileLoading)
                              ? state.cachedProfile
                              : null;

                      return _buildUserInfoCard(context, profile, (state is ProfileLoaded) && state.isUpdating);
                    },
                  ),
                  const SizedBox(height: 14),

                  // Civil Score Card
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      final profile = (state is ProfileLoaded) ? state.profile : null;
                      final civilScore = (state is ProfileLoaded) ? state.civilScore : null;

                      return _buildCivilScoreCard(profile, civilScore);
                    },
                  ),
                  const SizedBox(height: 20),

                  // My Vehicles Menu Item
                  BlocBuilder<VehicleBloc, VehicleState>(
                    builder: (context, state) {
                      int count = 0;
                      if (state is VehicleLoaded) {
                        count = state.vehicles.length;
                      } else if (state is VehicleLoading && state.cachedVehicles != null) {
                        count = state.cachedVehicles!.length;
                      }

                      return _buildMenuItem(
                        icon: Icons.directions_car_outlined,
                        title: 'My Vehicles',
                        trailingText: '$count Registered',
                        onTap: () => VehicleGarageSheet.show(context),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // Payment Methods Menu Item
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      final count = (state is ProfileLoaded) ? state.paymentMethods.length : 0;
                      return _buildMenuItem(
                        icon: Icons.payment_outlined,
                        title: 'Payment Methods',
                        trailingText: count > 0 ? '$count Saved' : 'Add Method',
                        onTap: () => PaymentMethodSheet.show(context),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // App Settings Menu Item
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'App Settings',
                    onTap: () {
                      Navigator.pushNamed(context, AppPageRoute.settingsPage);
                    },
                  ),
                  const SizedBox(height: 10),

                  // Help & Support
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      CustomSnackBar.showSuccess(context, 'MargNetra Helpdesk: support@margnetra.in');
                    },
                  ),
                  const SizedBox(height: 18),

                  // Logout Item
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      return _buildLogoutItem(
                        context: context,
                        isLoading: authState is AuthLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context, UserProfileModel? profile, bool isUpdating) {
    final displayName = (profile != null && profile.fullName.trim().isNotEmpty)
        ? profile.fullName
        : 'MargNetra Driver';
    final displayPhone = (profile != null && profile.phone.trim().isNotEmpty)
        ? profile.phone
        : 'Not Registered';
    final displayEmail = (profile != null && profile.email != null && profile.email!.trim().isNotEmpty)
        ? profile.email!
        : 'Add email address';
    final avatarUrl = profile?.avatarUrl;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          // Avatar with Camera Tap Target
          GestureDetector(
            onTap: () => AvatarPickerSheet.show(context),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xFF162520),
                  backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: (avatarUrl == null || avatarUrl.isEmpty)
                      ? const Icon(Icons.person, size: 34, color: primaryGreen)
                      : null,
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: cyan,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 12, color: Colors.black),
                  ),
                ),
                if (isUpdating)
                  const Positioned.fill(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: cyan,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // User Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: whiteText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (profile?.isVerified ?? false) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: cyan, size: 16),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  displayPhone,
                  style: const TextStyle(color: mutedText, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  displayEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: mutedText, fontSize: 12.5),
                ),
              ],
            ),
          ),

          // Edit Profile Button
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: cyan, size: 20),
            onPressed: () {
              if (profile != null) {
                EditProfileDialog.show(context, profile);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCivilScoreCard(UserProfileModel? profile, CivilScoreModel? civilScore) {
    final double score = civilScore?.currentScore ?? profile?.civilScore ?? 750.0;
    final int streak = civilScore?.streakDays ?? profile?.drivingStreakDays ?? 0;
    final double balance = profile?.mgcBalance ?? 0.0;
    final double factor = (score / 1000.0).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              // Driving Streak Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF163220),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryGreen.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: primaryGreen, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '$streak day streak',
                      style: const TextStyle(color: primaryGreen, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // MGC Balance Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF162530),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cyan.withAlpha(80)),
                ),
                child: Text(
                  '${balance.toStringAsFixed(1)} MGC',
                  style: const TextStyle(color: cyan, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Score Value
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score.toStringAsFixed(0),
                style: const TextStyle(
                  color: primaryGreen,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(width: 5),
              const Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Text(
                  '/1000',
                  style: TextStyle(color: mutedText, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            score >= 800 ? 'Exceptional Driver! Top reward tier unlocked.' : 'Good Driver! Maintain speed limits to earn MGC coins.',
            style: const TextStyle(color: primaryGreen, fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(height: 6, width: double.infinity, color: const Color(0xFF252A2A)),
                FractionallySizedBox(
                  widthFactor: factor,
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
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xFFB0B0B8)),
            const SizedBox(width: 14),
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
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: const TextStyle(color: mutedText, fontSize: 12, fontWeight: FontWeight.w400),
              ),
              const SizedBox(width: 7),
            ],
            const Icon(Icons.chevron_right, size: 22, color: Color(0xFF777780)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutItem({required BuildContext context, required bool isLoading}) {
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
          border: Border.all(color: const Color(0xFF3A1D21), width: 1),
        ),
        child: Row(
          children: [
            if (isLoading)
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.2, color: destructiveRed),
              )
            else
              const Icon(Icons.logout, size: 22, color: destructiveRed),
            const SizedBox(width: 14),
            Text(
              isLoading ? 'Logging out...' : 'Logout',
              style: const TextStyle(color: destructiveRed, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}