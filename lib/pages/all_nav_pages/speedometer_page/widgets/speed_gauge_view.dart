import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:margnetra_super_app/core/app_services/speed_service/speed_service.dart';

/// Radial gauge displaying current speed with smooth needle animation,
/// color-coded speed zones, and a prominent digital readout.
class SpeedGaugeView extends StatelessWidget {
  final double currentSpeed;
  final SpeedUnit unit;

  const SpeedGaugeView({
    super.key,
    required this.currentSpeed,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final double maxScale = unit.maxGaugeValue;
    final double interval = unit == SpeedUnit.kmh ? 20.0 : 15.0;

    // Format speed: single decimal when under 10 and moving, otherwise integer
    final String formattedSpeed = currentSpeed <= 0.0
        ? '0'
        : currentSpeed < 10
            ? currentSpeed.toStringAsFixed(1)
            : currentSpeed.toStringAsFixed(0);

    return AspectRatio(
      aspectRatio: 1.0,
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: maxScale,
            interval: interval,
            startAngle: 140,
            endAngle: 40,
            radiusFactor: 0.95,
            axisLabelStyle: const GaugeTextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            majorTickStyle: const MajorTickStyle(
              length: 12,
              thickness: 2,
              color: Colors.white54,
            ),
            minorTickStyle: const MinorTickStyle(
              length: 6,
              thickness: 1.2,
              color: Colors.white24,
            ),
            axisLineStyle: const AxisLineStyle(
              thickness: 16,
              cornerStyle: CornerStyle.bothCurve,
              color: Color(0xFF0F1E2E),
            ),
            ranges: <GaugeRange>[
              // Safe / City zone
              GaugeRange(
                startValue: 0,
                endValue: maxScale * 0.35,
                color: const Color(0xFF00E5FF),
                startWidth: 16,
                endWidth: 16,
              ),
              // Cruising / Highway zone
              GaugeRange(
                startValue: maxScale * 0.35,
                endValue: maxScale * 0.70,
                color: const Color(0xFFFFB300),
                startWidth: 16,
                endWidth: 16,
              ),
              // High speed warning zone
              GaugeRange(
                startValue: maxScale * 0.70,
                endValue: maxScale,
                color: const Color(0xFFFF1744),
                startWidth: 16,
                endWidth: 16,
              ),
            ],
            pointers: <GaugePointer>[
              // Smooth needle pointer
              NeedlePointer(
                value: currentSpeed.clamp(0.0, maxScale),
                enableAnimation: true,
                animationDuration: 400,
                animationType: AnimationType.easeOutBack,
                needleLength: 0.75,
                needleStartWidth: 1,
                needleEndWidth: 5,
                needleColor: Colors.white,
                knobStyle: const KnobStyle(
                  knobRadius: 0.08,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: Color(0xFF00E5FF),
                  borderColor: Colors.white,
                  borderWidth: 2,
                ),
                tailStyle: const TailStyle(
                  width: 4,
                  length: 0.18,
                  color: Colors.white70,
                ),
              ),
            ],
            annotations: <GaugeAnnotation>[
              // Prominent central speed number and unit
              GaugeAnnotation(
                angle: 90,
                positionFactor: 0.72,
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formattedSpeed,
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -1.5,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      unit.label.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.cyanAccent.shade200,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
