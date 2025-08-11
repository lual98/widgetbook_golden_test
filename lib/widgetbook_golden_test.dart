import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test/widgetbook_golden_tests_properties.dart';

/// Recursively generates golden tests for all [WidgetbookUseCase]s
/// inside the provided [nodes].
///
/// Example:
/// ```dart
/// runWidgetbookGoldenTests(directories);
/// ```
void runWidgetbookGoldenTests(WidgetbookGoldenTestsProperties properties) {
  group("Widgetbook golden tests", () {
    void traverse(List<WidgetbookNode> nodes, String path) {
      for (var node in nodes) {
        if (node is WidgetbookUseCase) {
          // Skip the golden test case if it contains the [skip-golden] tag.
          bool shouldSkip = node.name.contains(properties.skipTag);

          // Golden test case of the story.
          testWidgets(node.name, (widgetTester) async {
            late Widget widgetToTest;
            final previousOnError = FlutterError.onError;
            FlutterError.onError = (FlutterErrorDetails details) {
              // Ignore image loading errors for 'error-network-image' URLs
              if (details.exceptionAsString().contains(
                    'NetworkImage is an empty file',
                  ) &&
                  details.exceptionAsString().endsWith(
                    properties.errorImageUrl,
                  )) {
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

            await mockNetworkImages(
              () async => await widgetTester.pumpWidget(baseWidget),
              imageResolver: (uri) {
                if (uri.toString().endsWith(properties.errorImageUrl)) {
                  // If the URI is 'error-network-image', return an empty list to simulate an error.
                  return <int>[];
                }
                // Otherwise, return a valid image (transparent PNG)
                return base64Decode(
                  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
                );
              },
            );

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
        } else if (node.children != null) {
          group(node.name, () {
            traverse(node.children!, "$path/${node.name}");
          });
        }
      }
    }

    traverse(properties.nodes, properties.basePath);
  });
}

Future<void> precacheImagesAndWait(WidgetTester widgetTester) async {
  await widgetTester.runAsync(() async {
    // Find all Image widgets and precache their images
    final imageElements = find.byType(Image).evaluate();
    for (var element in imageElements) {
      final Image image = element.widget as Image;
      ImageProvider<Object> provider = image.image;
      if (provider is ResizeImage) {
        provider = provider.imageProvider;
      }
      await precacheImage(provider, element);
    }

    await Future.delayed(const Duration(milliseconds: 100));
  });
}
