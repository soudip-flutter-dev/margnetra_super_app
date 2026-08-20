import 'package:flutter/material.dart';

/// Legal Vault (Sec 65B) page content.
///
/// Designed to be embedded inside an existing navigation shell.
/// No Scaffold, AppBar, or BottomNavigationBar is included.
class LegalVaultWidget extends StatefulWidget {
  const LegalVaultWidget({super.key});

  @override
  State<LegalVaultWidget> createState() => _LegalVaultWidgetState();
}

class _LegalVaultWidgetState extends State<LegalVaultWidget> {
  // ---------------------------------------------------------------------------
  // Theme colors
  // ---------------------------------------------------------------------------
  static const Color _background = Color(0xFF0A0A0F);
  static const Color _cardColor = Color(0xFF111118);
  static const Color _borderColor = Color(0xFF24242D);
  static const Color _primaryText = Color(0xFFF5F5F7);
  static const Color _secondaryText = Color(0xFF92929D);
  static const Color _mutedText = Color(0xFF696973);
  static const Color _cyan = Color(0xFF00D9FF);

  // ---------------------------------------------------------------------------
  // Static event data
  // ---------------------------------------------------------------------------
  static const List<Map<String, String>> _events = [
    {
      'id': 'EVT-1001',
      'type': 'Accident',
      'date': '20 Apr 2025 • 10:24 AM',
      'hash': '3f7a2c...a9d2e',
    },
    {
      'id': 'EVT-1000',
      'type': 'Harsh Braking',
      'date': '18 Apr 2025 • 08:15 AM',
      'hash': '9bfa21...d11ac',
    },
    {
      'id': 'EVT-0999',
      'type': 'Over Speeding',
      'date': '15 Apr 2025 • 09:40 AM',
      'hash': '7c2e21...b21f1',
    },
  ];

  static const List<String> _eventTypes = [
    'All Events',
    'Accident',
    'Harsh Braking',
    'Over Speeding',
  ];

  String _selectedEventType = 'All Events';

  List<Map<String, String>> get _visibleEvents {
    if (_selectedEventType == 'All Events') {
      return _events;
    }

    return _events
        .where((event) => event['type'] == _selectedEventType)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _background,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------------------------------------------------
              // Header
              // ----------------------------------------------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Legal Vault (Sec 65B)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _primaryText,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildEventFilter(),
                ],
              ),

              const SizedBox(height: 18),

              // ----------------------------------------------------------------
              // Event cards
              // ----------------------------------------------------------------
              ..._visibleEvents.map(
                (event) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildEventCard(event),
                ),
              ),

              const SizedBox(height: 6),

              // ----------------------------------------------------------------
              // Bottom action buttons
              // ----------------------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      label: 'EXPORT SEC 65B AFFIDAVIT',
                      icon: Icons.file_download_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionButton(
                      label: 'DISPUTE PENALTY',
                      icon: Icons.gavel_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // "All Events" dropdown pill
  // ---------------------------------------------------------------------------
  Widget _buildEventFilter() {
    return PopupMenuButton<String>(
      tooltip: 'Filter events',
      onSelected: (eventType) {
        setState(() {
          _selectedEventType = eventType;
        });
      },
      itemBuilder: (context) => _eventTypes
          .map(
            (eventType) =>
                PopupMenuItem<String>(value: eventType, child: Text(eventType)),
          )
          .toList(),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF111117),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF303039), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedEventType,
              style: const TextStyle(
                color: Color(0xFFD1D1D7),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 17,
              color: _secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Individual event card
  // ---------------------------------------------------------------------------
  Widget _buildEventCard(Map<String, String> event) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          _buildVideoThumbnail(),

          const SizedBox(width: 12),

          // Event information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event ID
                Text(
                  'Event #${event['id']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                // Event type
                Text(
                  event['type']!,
                  style: const TextStyle(
                    color: _secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 3),

                // Date and time
                Text(
                  event['date']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _mutedText,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 7),

                // SHA-256 hash
                Row(
                  children: [
                    const Text(
                      'SHA-256',
                      style: TextStyle(
                        color: _mutedText,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        event['hash']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _cyan,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Dashcam/video thumbnail placeholder
  //
  // Replace this Container with Image.asset(...) or Image.network(...)
  // when the actual dashcam images are available.
  // ---------------------------------------------------------------------------
  Widget _buildVideoThumbnail() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFF2B2B34), width: 1),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF202832), Color(0xFF0D141B), Color(0xFF07090D)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Simple road-like visual placeholder
          Positioned(
            bottom: -5,
            left: 17,
            right: 17,
            child: Transform.rotate(
              angle: 0.15,
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.04),
                      Colors.white.withOpacity(0.11),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Video camera indicator
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.42),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.videocam_outlined,
              size: 15,
              color: Color(0xFFBFC6CB),
            ),
          ),

          // Small recording indicator
          Positioned(
            top: 7,
            right: 7,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xFFFF4545),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom outlined action button
  // ---------------------------------------------------------------------------
  Widget _buildActionButton({required String label, required IconData icon}) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1115),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _cyan.withOpacity(0.75), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: _cyan.withOpacity(0.08),
          highlightColor: _cyan.withOpacity(0.04),
          onTap: () {
            // TODO: Implement the corresponding action.
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: _cyan, size: 16),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _cyan,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
