// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loginwizard/main.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('App renders main navigation and default tabs smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // Verify app bar title
    expect(find.text('LoginWizard'), findsOneWidget);

    // Verify navigation destinations
    expect(find.widgetWithText(NavigationDestination, 'Username'), findsOneWidget);
    expect(find.widgetWithText(NavigationDestination, 'Password'), findsOneWidget);
    expect(find.widgetWithText(NavigationDestination, 'PIN'), findsOneWidget);

    // Verify Settings button exists in AppBar
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });
}
