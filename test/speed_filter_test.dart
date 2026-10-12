import 'package:flutter_test/flutter_test.dart';
import 'package:margnetra_super_app/core/app_services/speed_service/speed_filter.dart';
import 'package:margnetra_super_app/core/app_services/speed_service/speed_service.dart';

void main() {
  group('SpeedFilter Tests', () {
    test('Negative speed is clamped to 0.0', () {
      final filter = SpeedFilter();
      expect(filter.process(-5.0), equals(0.0));
      expect(filter.process(-0.1), equals(0.0));
    });

    test('Speed below 1.5 km/h returns 0.0 to prevent stationary jitter', () {
      final filter = SpeedFilter();
      // 1.0 km/h in m/s = 1.0 / 3.6 ≈ 0.277 m/s
      const lowSpeed = 1.0 / 3.6;
      expect(filter.process(lowSpeed), equals(0.0));

      // 1.4 km/h in m/s ≈ 0.388 m/s
      const jitterSpeed = 1.4 / 3.6;
      expect(filter.process(jitterSpeed), equals(0.0));
    });

    test('Speed at or above 1.5 km/h is returned accurately', () {
      final filter = SpeedFilter();
      // 10 km/h in m/s = 10 / 3.6
      const speed = 10.0 / 3.6;
      final result = filter.process(speed);
      expect(result * 3.6, closeTo(10.0, 0.01));
    });

    test('Moving average smooths over last 3 readings', () {
      final filter = SpeedFilter(windowSize: 3);

      // reading 1: 10 m/s -> avg = 10
      expect(filter.process(10.0), closeTo(10.0, 0.001));

      // reading 2: 20 m/s -> avg = (10 + 20) / 2 = 15.0
      expect(filter.process(20.0), closeTo(15.0, 0.001));

      // reading 3: 30 m/s -> avg = (10 + 20 + 30) / 3 = 20.0
      expect(filter.process(30.0), closeTo(20.0, 0.001));

      // reading 4: 40 m/s -> window drops 10 -> (20 + 30 + 40) / 3 = 30.0
      expect(filter.process(40.0), closeTo(30.0, 0.001));
    });

    test('Reset clears the window', () {
      final filter = SpeedFilter(windowSize: 3);
      filter.process(30.0);
      filter.process(30.0);
      filter.reset();

      // After reset, single reading 10.0 should have average = 10.0
      expect(filter.process(10.0), closeTo(10.0, 0.001));
    });
  });

  group('SpeedUnit Conversion Tests', () {
    test('km/h conversion is mps * 3.6', () {
      expect(SpeedUnit.kmh.convertFromMps(10.0), closeTo(36.0, 0.001));
      expect(SpeedUnit.kmh.label, equals('km/h'));
    });

    test('mph conversion is mps * 2.237', () {
      expect(SpeedUnit.mph.convertFromMps(10.0), closeTo(22.37, 0.001));
      expect(SpeedUnit.mph.label, equals('mph'));
    });
  });
}
