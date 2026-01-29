import 'package:flutter/material.dart';
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
    _runTest(
      testName: useCase.name,
      useCase: useCase,
      properties: properties,
      skip: skip,
      goldenTestBuilder: goldenTestBuilder,
      testBody: (widgetTester, widgetToTest) async {
        await expectLater(
          find.byType(widgetToTest.runtimeType).first,
          matchesGoldenFile("$goldenPath/${useCase.name}.png"),
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
    _runTest(
      testName: "${useCase.name} - ${action.name}",
      useCase: useCase,
      properties: properties,
      skip: skip,
      goldenTestBuilder: goldenTestBuilder,
      testBody: (widgetTester, widgetToTest) async {
        await action.callback(widgetTester, find);
        await widgetTester.pumpAndSettle();
        Finder goldenFinder = action.goldenFinder == null
            ? find.byType(widgetToTest.runtimeType).first
            : action.goldenFinder!.call(find);
        await expectLater(
          goldenFinder,
          matchesGoldenFile("$goldenPath/${useCase.name} - ${action.name}.png"),
        );
      },
    );
  }

  void _runTest({
    required String testName,
    required WidgetbookUseCase useCase,
    required WidgetbookGoldenTestsProperties properties,
    required bool skip,
    required WidgetbookGoldenTestBuilder? goldenTestBuilder,
    required Future<void> Function(WidgetTester tester, Widget widgetToTest)
    testBody,
  }) {
    testWidgets(testName, (widgetTester) async {
      await goldenTestZoneRunner(
        testBody: () async {
          final widget = MockedWidgetbookCase(
            properties: properties,
            builderAddons: goldenTestBuilder?.addons,
            useCase: useCase,
            constraints: goldenTestBuilder?.constraints,
          );
          await widgetTester.pumpWidgetbookCase(widget, properties);
          final state = widgetTester.state<MockedWidgetbookCaseState>(
            find.byType(MockedWidgetbookCase),
          );
          var widgetToTest = state.widgetToTest!;

          await testBody(widgetTester, widgetToTest);
        },
        properties: properties,
      );
    }, skip: skip);
  }
}
