import 'dart:collection';

/// Helper to smooth speed readings and suppress stationary jitter.
class SpeedFilter {
  final int windowSize;
  final double jitterThresholdKmh;
  final Queue<double> _window = Queue<double>();

  SpeedFilter({
    this.windowSize = 3,
    this.jitterThresholdKmh = 1.5,
  });

  /// Processes raw speed in m/s and returns smoothed speed in m/s.
  /// 1. Clamps negative speed to 0.0.
  /// 2. Maintains a moving average of the last [windowSize] readings.
  /// 3. If the smoothed speed in km/h is below [jitterThresholdKmh], returns 0.0 to prevent stationary jitter.
  double process(double rawSpeedInMps) {
    final double sanitized = rawSpeedInMps < 0 ? 0.0 : rawSpeedInMps;

    _window.addLast(sanitized);
    if (_window.length > windowSize) {
      _window.removeFirst();
    }

    final double sum = _window.fold(0.0, (prev, val) => prev + val);
    final double smoothed = _window.isEmpty ? 0.0 : sum / _window.length;

    // Check jitter threshold (1.5 km/h converted to m/s)
    final double speedInKmh = smoothed * 3.6;
    if (speedInKmh < jitterThresholdKmh) {
      return 0.0;
    }

    return smoothed;
  }

  /// Clears the smoothing window.
  void reset() {
    _window.clear();
  }
}
