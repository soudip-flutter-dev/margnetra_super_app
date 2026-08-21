import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  // Static settings data so new sections/rows can be added easily.
  static final List<SettingsSection> _sections = [
    SettingsSection(
      title: 'Preferences',
      items: [
        SettingsItem(
          icon: Icons.speed,
          title: 'Units',
          value: 'km/h',
          iconColor: const Color(0xFF22D3EE),
          iconBackground: const Color(0x1A22D3EE),
        ),
        SettingsItem(
          icon: Icons.palette_outlined,
          title: 'Theme',
          value: 'Apex Dark',
          iconColor: const Color(0xFF22C55E),
          iconBackground: const Color(0x1A22C55E),
        ),
        SettingsItem(
          icon: Icons.language,
          title: 'Language',
          value: 'English',
          iconColor: const Color(0xFFFB4F73),
          iconBackground: const Color(0x1AFB4F73),
        ),
      ],
    ),

    // Alerts & Reminders section.
    SettingsSection(
      title: 'Alerts & Reminders',
      items: [
        SettingsItem(
          icon: Icons.event_note,
          title: 'Document Expiry',
          value: '14 days before',
          iconColor: const Color(0xFFF59E0B),
          iconBackground: const Color(0x1AF59E0B),
        ),
        SettingsItem(
          icon: Icons.warning_amber_outlined,
          title: 'Challan Alerts',
          value: 'On',
          iconColor: const Color(0xFFF59E0B),
          iconBackground: const Color(0x1AF59E0B),
        ),
        SettingsItem(
          icon: Icons.shield_outlined,
          title: 'Streak Protection',
          value: 'On',
          iconColor: const Color(0xFFF59E0B),
          iconBackground: const Color(0x1AF59E0B),
        ),
      ],
    ),

    // Data & Privacy section.
    SettingsSection(
      title: 'Data & Privacy',
      items: [
        SettingsItem(
          icon: Icons.share_outlined,
          title: 'Data Sharing',
          value: 'Enabled',
          iconColor: const Color(0xFF22C55E),
          iconBackground: const Color(0x1A22C55E),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
    Container(
      color: const Color(0xFF0A0A0F),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page header.
              const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 28),

              // Render all settings sections.
              ..._sections.map(
                (section) => _SettingsSectionWidget(section: section),
              ),
            ],
          ),
        ),
      ),
    )
,
    );
 
  }
}

// Model for a settings section.
class SettingsSection {
  final String title;
  final List<SettingsItem> items;

  const SettingsSection({
    required this.title,
    required this.items,
  });
}

// Model for an individual settings row.
class SettingsItem {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;
  final Color iconBackground;

  const SettingsItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
    required this.iconBackground,
  });
}

// Builds one complete settings section.
class _SettingsSectionWidget extends StatelessWidget {
  final SettingsSection section;

  const _SettingsSectionWidget({
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title.
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 11),
            child: Text(
              section.title.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF7D818B),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                height: 1.2,
              ),
            ),
          ),

          // Settings rows.
          ...List.generate(
            section.items.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == section.items.length - 1 ? 0 : 9,
              ),
              child: _SettingsRow(item: section.items[index]),
            ),
          ),
        ],
      ),
    );
  }
}

// Individual rounded settings row.
class _SettingsRow extends StatelessWidget {
  final SettingsItem item;

  const _SettingsRow({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF111116),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFF202128),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Row(
        children: [
          // Colored icon badge.
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: item.iconBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              color: item.iconColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 13),

          // Setting name.
          Expanded(
            child: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFF1F1F3),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Current setting value.
          Flexible(
            child: Text(
              item.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF858994),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          const SizedBox(width: 7),

          // Right chevron.
          const Icon(
            Icons.chevron_right,
            color: Color(0xFF686B74),
            size: 20,
          ),
        ],
      ),
    );
  }
}