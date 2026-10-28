import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/utils/custom_snack_bar.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/app_settings_model.dart';
import 'package:margnetra_super_app/pages/profile_page/logic/blocs/settings_bloc/settings_bloc.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  static const Color backgroundColor = Color(0xFF0A0A0F);
  static const Color cardColor = Color(0xFF111116);
  static const Color borderColor = Color(0xFF202128);
  static const Color cyan = Color(0xFF16D9E3);
  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color amber = Color(0xFFF59E0B);
  static const Color mutedText = Color(0xFF858994);

  void _showLanguageDialog(BuildContext context, String currentLanguage) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: borderColor),
          ),
          title: const Text('Select Language', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  currentLanguage == 'en' ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: currentLanguage == 'en' ? cyan : mutedText,
                ),
                title: const Text('English', style: TextStyle(color: Colors.white)),
                onTap: () {
                  context.read<SettingsBloc>().add(const UpdateSettingToggleEvent(language: 'en'));
                  Navigator.of(dialogContext).pop();
                },
              ),
              ListTile(
                leading: Icon(
                  currentLanguage == 'hi' ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: currentLanguage == 'hi' ? cyan : mutedText,
                ),
                title: const Text('Hindi (हिंदी)', style: TextStyle(color: Colors.white)),
                onTap: () {
                  context.read<SettingsBloc>().add(const UpdateSettingToggleEvent(language: 'hi'));
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsLoaded && state.syncError != null) {
              CustomSnackBar.showError(context, state.syncError!);
            }
          },
          builder: (context, state) {
            final AppSettingsModel settings = (state is SettingsLoaded)
                ? state.settings
                : const AppSettingsModel();

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button + Page title
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const Spacer(),
                      if (state is SettingsLoaded && state.isSyncing)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: cyan),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // PREFERENCES SECTION
                  _buildSectionHeader('Preferences'),
                  _buildSwitchRow(
                    icon: Icons.palette_outlined,
                    iconColor: primaryGreen,
                    title: 'Dark Mode',
                    subtitle: settings.darkMode ? 'Apex Dark theme active' : 'Light theme active',
                    value: settings.darkMode,
                    onChanged: (val) {
                      context.read<SettingsBloc>().add(UpdateSettingToggleEvent(darkMode: val));
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildActionRow(
                    icon: Icons.language,
                    iconColor: const Color(0xFFFB4F73),
                    title: 'Language',
                    value: settings.language == 'hi' ? 'Hindi (हिंदी)' : 'English',
                    onTap: () => _showLanguageDialog(context, settings.language),
                  ),
                  const SizedBox(height: 10),

                  _buildSwitchRow(
                    icon: Icons.speed,
                    iconColor: cyan,
                    title: 'HUD Speedometer Overlay',
                    subtitle: 'Display floating telemetry widget over navigation maps',
                    value: settings.hudOverlay,
                    onChanged: (val) {
                      context.read<SettingsBloc>().add(UpdateSettingToggleEvent(hudOverlay: val));
                    },
                  ),
                  const SizedBox(height: 26),

                  // ALERTS & NOTIFICATIONS SECTION
                  _buildSectionHeader('Alerts & Notifications'),
                  _buildSwitchRow(
                    icon: Icons.notifications_active_outlined,
                    iconColor: amber,
                    title: 'Push Notifications',
                    subtitle: 'Trip rewards, traffic challans, and document expiry notices',
                    value: settings.notificationsEnabled,
                    onChanged: (val) {
                      context.read<SettingsBloc>().add(UpdateSettingToggleEvent(notificationsEnabled: val));
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildActionRow(
                    icon: Icons.warning_amber_outlined,
                    iconColor: amber,
                    title: 'Electronic Challan Alerts',
                    value: 'Instant Push',
                    onTap: () {},
                  ),
                  const SizedBox(height: 26),

                  // DATA & PRIVACY SECTION
                  _buildSectionHeader('Data & Privacy'),
                  _buildSwitchRow(
                    icon: Icons.share_location_outlined,
                    iconColor: primaryGreen,
                    title: 'Family Location Sharing',
                    subtitle: 'Allow trusted family circle members to view your live trip route',
                    value: settings.locationSharing,
                    onChanged: (val) {
                      context.read<SettingsBloc>().add(UpdateSettingToggleEvent(locationSharing: val));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF7D818B),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: mutedText, fontSize: 11.5),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: cyan,
            activeTrackColor: cyan.withAlpha(80),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: const Color(0xFF25252D),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              value,
              style: const TextStyle(color: mutedText, fontSize: 13),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Color(0xFF686B74), size: 20),
          ],
        ),
      ),
    );
  }
}