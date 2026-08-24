import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:margnetra_super_app/main.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/family_circle_page/family_circle_page.dart';
import 'package:margnetra_super_app/pages/splash_screen/splash_screen.dart';

void main() {
  testWidgets('MargNetra splash screen loads the app branding', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MARGNETRA'), findsOneWidget);
    expect(find.text('TRUSTED MOBILITY & REWARDS'), findsOneWidget);
    expect(find.byType(MargNetraSplash), findsOneWidget);
  });

  testWidgets('Family Circle switches between map and list views', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: FamilyCirclePage()));

    expect(find.text('FAMILY ZONE'), findsOneWidget);
    expect(find.text('Map View'), findsOneWidget);

    await tester.tap(find.text('List View'));
    await tester.pump();

    expect(find.text('FAMILY ZONE'), findsNothing);
    expect(find.text("Father's Car"), findsOneWidget);

    await tester.tap(find.text('Map View'));
    await tester.pump();

    expect(find.text('FAMILY ZONE'), findsOneWidget);
  });
}
