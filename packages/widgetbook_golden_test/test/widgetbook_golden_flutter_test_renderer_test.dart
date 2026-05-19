import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test/src/widgetbook_golden_flutter_test_renderer.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

void main() {
  group(WidgetbookGoldenFlutterTestRenderer, () {
    group("executes action custom pump", () {
      bool customPumpExecuted = false;
      final action = GoldenPlayAction(
        name: "validate custom pump execution",
        callback: (tester, find) async {},
        customPump: (tester) async {
          await tester.pump();
          customPumpExecuted = true;
        },
      );
      final properties = WidgetbookGoldenTestsProperties();
      final useCase = WidgetbookUseCase(
        name: "custom pump test",
        builder: (_) => SizedBox.shrink(),
      );

      final renderer = WidgetbookGoldenFlutterTestRenderer();
      renderer.renderGoldenPlayActionTest(
        action: action,
        useCase: useCase,
        goldenPath: "./snaphots/",
        properties: properties,
        skip: false,
      );

      tearDownAll(() {
        expect(customPumpExecuted, true);
      });
    });
  });
}
