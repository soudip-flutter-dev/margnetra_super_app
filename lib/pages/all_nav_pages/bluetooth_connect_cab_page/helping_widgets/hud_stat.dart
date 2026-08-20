
import 'package:flutter/material.dart';

class HudStat extends StatelessWidget {
  final String title;
  final String value;
  final CrossAxisAlignment alignment;

  const HudStat({
    required this.title,
    required this.value,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF829097),
            fontSize: 7.5,
            fontWeight: FontWeight.w500,
            letterSpacing: .6,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: .3,
          ),
        ),
      ],
    );
  }
}

