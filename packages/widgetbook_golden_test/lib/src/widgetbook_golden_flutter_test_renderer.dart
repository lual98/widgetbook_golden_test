import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

/// A renderer that uses `flutter_test` to execute golden tests.
///
/// This implementation uses [testWidgets] to run each test case and
/// [expectLater] with [matchesGoldenFile] to verify the visual output.
class WidgetbookGoldenFlutterTestRenderer implements WidgetbookGoldenRenderer {
  @override
  void renderSimpleGoldenTest({
    required WidgetbookUseCase useCase,
    required String goldenPath,
    required WidgetbookGoldenTestsProperties properties,
    required bool skip,
    WidgetbookGoldenTestBuilder? goldenTestBuilder,
  }) {
    testWidgets(useCase.name, (widgetTester) async {
      await goldenTestZoneRunner(
        testBody: () async {
          final widget = MockedWidgetbookCase(
            properties: properties,
            builderAddons: goldenTestBuilder?.addons,
            useCase: useCase,
          );
          await widgetTester.pumpWidgetbookCase(widget, properties);
          final state = widgetTester.state<MockedWidgetbookCaseState>(
            find.byType(MockedWidgetbookCase),
          );
          var widgetToTest = state.widgetToTest!;

          await expectLater(
            find.byType(widgetToTest.runtimeType).first,
            matchesGoldenFile("$goldenPath/${useCase.name}.png"),
          );
        },
        properties: properties,
      );
    }, skip: skip);
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
    testWidgets(useCase.name, (widgetTester) async {
      await goldenTestZoneRunner(
        testBody: () async {
          final widget = MockedWidgetbookCase(
            properties: properties,
            builderAddons: goldenTestBuilder?.addons,
            useCase: useCase,
          );
          await widgetTester.pumpWidgetbookCase(widget, properties);
          final state = widgetTester.state<MockedWidgetbookCaseState>(
            find.byType(MockedWidgetbookCase),
          );
          var widgetToTest = state.widgetToTest!;

          await action.callback(widgetTester, find);
          await widgetTester.pumpAndSettle();
          Finder goldenFinder = action.goldenFinder == null
              ? find.byType(widgetToTest.runtimeType).first
              : action.goldenFinder!.call(find);
          await expectLater(
            goldenFinder,
            matchesGoldenFile(
              "$goldenPath/${useCase.name} - ${action.name}.png",
            ),
          );
        },
        properties: properties,
      );
    }, skip: skip);
  }
}
