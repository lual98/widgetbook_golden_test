import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test/src/widgetbook_golden_flutter_test_renderer.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

void main() {
  group(WidgetbookGoldenFlutterTestRenderer, () {
    group("calls custom onError when there is an error during the test", () {
      var properties = WidgetbookGoldenTestsProperties(
        onTestError: (details, originalOnError) {
          if (details.exception is ProviderNotFoundException) {
            // If this is executed instead of the default onError, the test will pass.
            return;
          }
          originalOnError?.call(details);
        },
      );
      var useCase = WidgetbookUseCase(
        name: "exception test",
        builder: (_) {
          // Create on purpose a Consumer without provider to make this widget throw an exception.
          return Consumer<String>(
            builder: (context, value, child) =>
                Container(height: 20, width: 20, color: Colors.green),
          );
        },
      );

      final renderer = WidgetbookGoldenFlutterTestRenderer();
      // The generated snapshot will be an error screen but the test will pass
      renderer.renderSimpleGoldenTest(
        useCase: useCase,
        goldenPath: "./snaphots/",
        properties: properties,
        skip: false,
      );
    });
  });
}
