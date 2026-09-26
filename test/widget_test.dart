import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_app/app/app.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/config/app_environment.dart';

void main() {
  testWidgets('language gate is the first route', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [preferencesProvider.overrideWithValue(preferences)],
        child: SoulApp(configuration: AppConfiguration.fromDartDefines()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('VI'), findsOneWidget);
    expect(find.text('EN'), findsOneWidget);
  });
}
