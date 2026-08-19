import 'package:flutter/material.dart';

/// DigiLocker page content.
///
/// Designed to be embedded inside an existing navigation shell.
/// No Scaffold, BottomNavigationBar, or navigation code is included.
class DigiLockerWidget extends StatelessWidget {
  const DigiLockerWidget({super.key});

  // ---------------------------------------------------------------------------
  // Color palette
  // ---------------------------------------------------------------------------
  static const Color _background = Color(0xFF0A0A0F);
  static const Color _cardColor = Color(0xFF111219);
  static const Color _cardBorder = Color(0xFF242731);

  static const Color _white = Color(0xFFF5F7FA);
  static const Color _mutedText = Color(0xFF858A96);

  static const Color _cyan = Color(0xFF00D9E8);
  static const Color _cyanDark = Color(0xFF00AFC0);

  static const Color _validGreen = Color(0xFF35D58A);
  static const Color _warningOrange = Color(0xFFFFA62B);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _background,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------------------------------------------------
              // Header
              // ----------------------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'DigiLocker',
                    style: TextStyle(
                      color: _white,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),

                  // Notification icon without a badge.
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF12141B),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: _cardBorder,
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: _white,
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ----------------------------------------------------------------
              // Document grid
              // ----------------------------------------------------------------
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 12) / 2;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _documentCard(
                        width: cardWidth,
                        icon: Icons.description_outlined,
                        iconBackground: const Color(0xFF102A46),
                        iconColor: const Color(0xFF4CA8FF),
                        title: 'RC',
                        status: 'Valid',
                        statusColor: _validGreen,
                        expiry: 'Exp: 12 Aug 2026',
                      ),

                      _documentCard(
                        width: cardWidth,
                        icon: Icons.description_outlined,
                        iconBackground: const Color(0xFF102A46),
                        iconColor: const Color(0xFF4CA8FF),
                        title: 'Insurance',
                        status: 'Valid',
                        statusColor: _validGreen,
                        expiry: 'Exp: 20 Jan 2026',
                      ),

                      _documentCard(
                        width: cardWidth,
                        icon: Icons.warning_amber_rounded,
                        iconBackground: const Color(0xFF3A2111),
                        iconColor: _warningOrange,
                        title: 'PUCC',
                        status: 'Expires in 14 days',
                        statusColor: _warningOrange,
                        expiry: null,
                      ),

                      _documentCard(
                        width: cardWidth,
                        icon: Icons.badge_outlined,
                        iconBackground: const Color(0xFF251C46),
                        iconColor: const Color(0xFF9A7BFF),
                        title: 'Driving License',
                        status: 'Valid',
                        statusColor: _validGreen,
                        expiry: 'Exp: 19 Jul 2028',
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // ----------------------------------------------------------------
              // Upload / Scan button
              // ----------------------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        _cyanDark,
                        _cyan,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: _cyan.withOpacity(0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        // Add upload/scan functionality here.
                      },
                      child: const Center(
                        child: Text(
                          'UPLOAD / SCAN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 17),

              // ----------------------------------------------------------------
              // Add New Document link
              // ----------------------------------------------------------------
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Add new-document functionality here.
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    child: Text(
                      'Add New Document',
                      style: TextStyle(
                        color: _cyan,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Reusable document card
  // ---------------------------------------------------------------------------
  Widget _documentCard({
    required double width,
    required IconData icon,
    required Color iconBackground,
    required Color iconColor,
    required String title,
    required String status,
    required Color statusColor,
    String? expiry,
  }) {
    return Container(
      width: width,
      height: 154,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: _cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document type icon badge.
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 21,
            ),
          ),

          const Spacer(),

          // Document title.
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _white,
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.1,
            ),
          ),

          const SizedBox(height: 5),

          // Document status.
          Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: statusColor,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),

          // Expiry information.
          if (expiry != null) ...[
            const SizedBox(height: 3),
            Text(
              expiry,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _mutedText,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}