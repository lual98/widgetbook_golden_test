import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

/// A renderer that uses `alchemist` to execute golden tests.
///
/// This implementation uses [goldenTest] to run each test case with
/// [GoldenTestScenario] to verify the visual output.
class WidgetbookGoldenAlchemistRenderer implements WidgetbookGoldenRenderer {
  @override
  void renderSimpleGoldenTest({
    required WidgetbookUseCase useCase,
    required String goldenPath,
    required WidgetbookGoldenTestsProperties properties,
    required bool skip,
    WidgetbookGoldenTestBuilder? goldenTestBuilder,
  }) {
    _runGoldenTest(
      testName: useCase.name,
      fileName: "$goldenPath/${useCase.name}",
      useCase: useCase,
      properties: properties,
      skip: skip,
      goldenTestBuilder: goldenTestBuilder,
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
    _runGoldenTest(
      testName: "${useCase.name} - ${action.name}",
      fileName: "$goldenPath/${useCase.name} - ${action.name}",
      useCase: useCase,
      properties: properties,
      skip: skip,
      goldenTestBuilder: goldenTestBuilder,
      interaction: (tester) async {
        await action.callback(tester, find);
        if (action.customPump != null) {
          await action.customPump!(tester);
        } else {
          await tester.pumpAndSettle();
        }
      },
    );
  }

  void _runGoldenTest({
    required String testName,
    required WidgetbookUseCase useCase,
    required String fileName,
    required WidgetbookGoldenTestsProperties properties,
    required bool skip,
    required WidgetbookGoldenTestBuilder? goldenTestBuilder,
    Future<void> Function(WidgetTester tester)? interaction,
  }) {
    goldenTest(
      testName,
      fileName: fileName,
      skip: skip,
      tags: WidgetbookGoldenRenderer.resolveTags(
        goldenTestBuilder: goldenTestBuilder,
        properties: properties,
      ),
      // Alchemist's default `pumpBeforeTest` is `onlyPumpAndSettle`, which calls
      // `pumpAndSettle()` after the widget is pumped but before golden capture.
      // Since `pumpWidgetbookCase` already handles settling internally, we use a
      // no-op here to avoid redundant double settling.
      pumpBeforeTest: (tester) async => {},
      pumpWidget: (tester, widget) async {
        final ignorePendingTimers =
            goldenTestBuilder?.ignorePendingTimers ?? false;
        return goldenTestZoneRunner(
          testBody: () async {
            Future<void> run() async {
              await tester.pumpWidgetbookCase(
                widget,
                properties,
                pumpBefore: goldenTestBuilder?.pumpBeforeImagePrecache,
                pumpAfter: goldenTestBuilder?.pumpAfterImagePrecache,
              );
              if (interaction != null) {
                await interaction(tester);
              }
            }

            if (ignorePendingTimers) {
              await tester.runAsync(() async {
                await runZoned(run, zoneValues: {#inRunAsync: true});
              });
            } else {
              await run();
            }
          },
          properties: properties,
        );
      },
      builder: () {
        return GoldenTestScenario(
          constraints: goldenTestBuilder?.constraints ?? const BoxConstraints(),
          name: useCase.name,
          child: MockedWidgetbookCase(
            properties: properties,
            builderAddons: goldenTestBuilder?.addons,
            useCase: useCase,
            includeScaffold: false,
          ),
        );
      },
    );
  }
}
