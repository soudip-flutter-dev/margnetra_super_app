import 'package:flutter/material.dart';

class WalletBalanceCard extends StatelessWidget {
  final String label;
  final String value;
  final String? currency;
  final Color backgroundColor;
  final Color borderColor;
  final String? topRightText;
  final IconData? icon;

  const WalletBalanceCard({
    super.key,
    required this.label,
    required this.value,
    this.currency,
    required this.backgroundColor,
    required this.borderColor,
    this.topRightText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 15),
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
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 15, color: const Color(0xFFD5D8DC)),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFFD5D8DC),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
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
                    if (currency != null && currency!.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Text(
                        currency!,
                        style: const TextStyle(
                          color: Color(0xFF8C949E),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Optional settlement / status text + info badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (topRightText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      topRightText!,
                      style: const TextStyle(
                        color: Color(0xFFD1D5DB),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
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
}

