import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

void main() {
  group(MockedWidgetbookCase, () {
    testWidgets('builds correctly and exposes widgetToTest', (tester) async {
      const widgetKey = Key('target-widget');
      final useCase = WidgetbookUseCase(
        name: 'Default',
        builder: (context) => const SizedBox(key: widgetKey),
      );

      final properties = WidgetbookGoldenTestsProperties(addons: []);

      await tester.pumpWidget(
        MockedWidgetbookCase(
          properties: properties,
          builderAddons: null,
          useCase: useCase,
        ),
      );

      // Verify basic structure
      expect(find.byType(WidgetbookScope), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsNothing);
      expect(find.byType(Material), findsOneWidget);
      expect(find.byKey(widgetKey), findsOneWidget);

      // Verify state access
      final state = tester.state<MockedWidgetbookCaseState>(
        find.byType(MockedWidgetbookCase),
      );
      expect(state.widgetToTest, isNotNull);
      expect(state.widgetToTest, isA<SizedBox>());
    });

    testWidgets('applies LocalizationAddon correctly', (tester) async {
      final properties = WidgetbookGoldenTestsProperties(
        // Verify we can pass delegates directly to the properties
        addons: [
          LocalizationAddon(
            locales: [const Locale('en'), const Locale('es')],
            localizationsDelegates: [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            initialLocale: const Locale('en'),
          ),
        ],
      );

      final useCase = WidgetbookUseCase(
        name: 'Default',
        builder: (context) {
          // Verify that MaterialLocalizations are available
          return Text(MaterialLocalizations.of(context).okButtonLabel);
        },
      );

      // default is en
      await tester.pumpWidget(
        MockedWidgetbookCase(
          properties: properties,
          builderAddons: null,
          useCase: useCase,
        ),
      );

      // 'OK' is the default English text for okButtonLabel
      expect(find.text('OK'), findsOneWidget);
    });
  });
}
