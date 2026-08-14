import 'package:flutter_test/flutter_test.dart';

import 'package:margnetra_super_app/main.dart';
import 'package:margnetra_super_app/pages/splash_screen/splash_screen.dart';

void main() {
  testWidgets('MargNetra splash screen loads the app branding', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MARGNETRA'), findsOneWidget);
    expect(find.text('TRUSTED MOBILITY & REWARDS'), findsOneWidget);
    expect(find.byType(MargNetraSplash), findsOneWidget);
  });
}
