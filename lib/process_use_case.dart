import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test/ignore_network_image_exception.dart';
import 'package:widgetbook_golden_test/test_utils.dart';
import 'package:widgetbook_golden_test/widgetbook_golden_tests_properties.dart';

void processUseCase(
  WidgetbookUseCase node,
  String path,
  WidgetbookGoldenTestsProperties properties,
) {
  // Skip the golden test case if it contains the [skip-golden] tag.
  bool shouldSkip = node.name.contains(properties.skipTag);

  // Golden test case of the story.
  testWidgets(node.name, (widgetTester) async {
    late Widget widgetToTest;
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      // Ignore image loading errors for 'error-network-image' URLs
      if (details.exception is IgnoreNetworkImageException) {
        return;
      }
      previousOnError?.call(details);
    };

    Widget baseWidget = MaterialApp(
      locale: properties.locale,
      localizationsDelegates: properties.localizationsDelegates,
      theme: properties.theme,
      home: Scaffold(
        body: Builder(
          builder: (context) {
            widgetToTest = node.builder(context);
            return widgetToTest;
          },
        ),
      ),
    );

    await widgetTester.pumpWidget(baseWidget);
    await widgetTester.pumpAndSettle();
    await precacheImagesAndWait(widgetTester);
    await widgetTester.pumpAndSettle();

    await expectLater(
      find.byType(widgetToTest.runtimeType).first,
      matchesGoldenFile("$path/${node.name}.png"),
    );

    // Restore the previous error handler
    FlutterError.onError = previousOnError;
  }, skip: shouldSkip);
}
