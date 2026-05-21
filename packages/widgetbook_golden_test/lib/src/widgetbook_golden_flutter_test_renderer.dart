import 'dart:async';

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
      goldenFileFullPath: "$goldenPath/${useCase.name}.png",
      getGoldenFinder: (find, widgetToTest) =>
          find.byType(widgetToTest.runtimeType).first,
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
      goldenFileFullPath: "$goldenPath/${useCase.name} - ${action.name}.png",
      getGoldenFinder: (find, widgetToTest) => action.goldenFinder == null
          ? find.byType(widgetToTest.runtimeType).first
          : action.goldenFinder!.call(find),
      interaction: (widgetTester) async {
        await action.callback(widgetTester, find);
        if (action.customPump != null) {
          await action.customPump!(widgetTester);
        } else {
          await widgetTester.pumpAndSettle();
        }
      },
    );
  }

  void _runTest({
    required String testName,
    required WidgetbookUseCase useCase,
    required WidgetbookGoldenTestsProperties properties,
    required bool skip,
    required WidgetbookGoldenTestBuilder? goldenTestBuilder,
    required Finder Function(CommonFinders find, Widget widgetToTest)
    getGoldenFinder,
    required String goldenFileFullPath,
    Future<void> Function(WidgetTester tester)? interaction,
  }) {
    testWidgets(
      testName,
      tags: WidgetbookGoldenRenderer.resolveTags(
        goldenTestBuilder: goldenTestBuilder,
        properties: properties,
      ),
      (widgetTester) async {
        final ignorePendingTimers =
            goldenTestBuilder?.ignorePendingTimers ?? false;

        late Widget widgetToTest;

        await goldenTestZoneRunner(
          testBody: () async {
            final widget = MockedWidgetbookCase(
              properties: properties,
              builderAddons: goldenTestBuilder?.addons,
              useCase: useCase,
              constraints: goldenTestBuilder?.constraints,
            );

            Future<void> run() async {
              await widgetTester.pumpWidgetbookCase(
                widget,
                properties,
                pumpBefore: goldenTestBuilder?.pumpBeforeImagePrecache,
                pumpAfter: goldenTestBuilder?.pumpAfterImagePrecache,
              );
              final state = widgetTester.state<MockedWidgetbookCaseState>(
                find.byType(MockedWidgetbookCase),
              );
              widgetToTest = state.widgetToTest!;

              if (interaction != null) {
                await interaction(widgetTester);
              }
            }

            if (ignorePendingTimers) {
              await widgetTester.runAsync(() async {
                await runZoned(run, zoneValues: {#inRunAsync: true});
              });
            } else {
              await run();
            }

            final goldenFinder = getGoldenFinder(find, widgetToTest);
            await expectLater(
              goldenFinder,
              matchesGoldenFile(goldenFileFullPath),
            );
          },
          properties: properties,
        );
      },
      skip: skip,
    );
  }
}
