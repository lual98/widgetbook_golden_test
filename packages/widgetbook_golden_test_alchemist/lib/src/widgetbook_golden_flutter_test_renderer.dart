import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

/// A renderer that uses `flutter_test` to execute golden tests.
///
/// This implementation uses [testWidgets] to run each test case and
/// [expectLater] with [matchesGoldenFile] to verify the visual output.
class WidgetbookGoldenAlchemistRenderer implements WidgetbookGoldenRenderer {
  @override
  void renderSimpleGoldenTest({
    required WidgetbookUseCase useCase,
    required String goldenPath,
    required WidgetbookGoldenTestsProperties properties,
    required bool skip,
    WidgetbookGoldenTestBuilder? goldenTestBuilder,
  }) {
    goldenTest(
      useCase.name,
      fileName: "$goldenPath/${useCase.name}",
      skip: skip,
      pumpWidget: (tester, widget) async {
        return goldenTestZoneRunner(
          testBody: () async {
            await tester.pumpWidgetbookCase(widget, properties);
          },
          properties: properties,
        );
      },
      builder: () {
        return GoldenTestScenario(
          name: useCase.name,
          child: MockedWidgetbookCase(
            properties: properties,
            builderAddons: goldenTestBuilder?.addons,
            useCase: useCase,
          ),
        );
      },
    );
  }

  @override
  void renderGoldenPlayActionTest({
    required WidgetbookUseCase useCase,
    required String goldenPath,
    required WidgetbookGoldenTestsProperties properties,
    required GoldenPlayAction action,
    required bool skip,
    WidgetbookGoldenTestBuilder? goldenTestBuilder,
  }) {
    goldenTest(
      useCase.name,
      fileName: "$goldenPath/${useCase.name} - ${action.name}",
      skip: skip,
      pumpWidget: (tester, widget) async {
        return goldenTestZoneRunner(
          testBody: () async {
            await tester.pumpWidgetbookCase(widget, properties);
            await action.callback(tester, find);
            await tester.pumpAndSettle();
          },
          properties: properties,
        );
      },
      builder: () {
        return GoldenTestScenario(
          name: useCase.name,
          child: MockedWidgetbookCase(
            properties: properties,
            builderAddons: goldenTestBuilder?.addons,
            useCase: useCase,
          ),
        );
      },
    );
  }
}
