import 'package:flutter/material.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/helping_widgets/hud_gauge_painter.dart';

class SpeedometerWidget extends StatefulWidget {
  final double width;
  const SpeedometerWidget({super.key, required this.width});

  @override
  State<SpeedometerWidget> createState() => _SpeedometerWidgetState();
}

class _SpeedometerWidgetState extends State<SpeedometerWidget> {
  double _speed = 68;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Column(
        children: [
          SizedBox(
            height: widget.width * 0.67,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(widget.width, widget.width * 0.67),
                  painter: HudGaugePainter(speed: _speed),
                ),

                // Speed value
                Positioned(
                  top: widget.width * 0.205,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        _speed.toStringAsFixed(0),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w300,
                          height: 1,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'km/h',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.width * 0.08),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFF00D9FF),
                inactiveTrackColor: const Color(0xFF1A4B57),
                thumbColor: Colors.yellow,
                overlayColor: const Color(0x3300D9FF),
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              ),
              child: Slider(
                min: 1,
                max: 160,
                divisions: 159,
                value: _speed,
                label: '${_speed.toStringAsFixed(0)} km/h',
                onChanged: (value) {
                  setState(() {
                    _speed = value;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.width * 0.09),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1',
                  style: TextStyle(color: Color(0xFF608A95), fontSize: 9),
                ),
                Text(
                  '160 km/h',
                  style: TextStyle(color: Color(0xFF608A95), fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
