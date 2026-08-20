
import 'package:flutter/material.dart';

class ConnectionDot extends StatelessWidget {
  const ConnectionDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: Color(0xFF00E676),
        shape: BoxShape.circle,
      ),
    );
  }
}
