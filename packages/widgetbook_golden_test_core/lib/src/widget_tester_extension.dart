import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

/// Extension to add custom functionality to [WidgetTester] required by the widgetbook golden tests.
extension WidgetTesterExtension on WidgetTester {
  /// Pumps the given widget.
  /// It also precaches the images detected in the currently built widget to make sure
  /// they are shown in the saved golden file.
  Future<void> pumpWidgetbookCase(
    Widget widget,
    WidgetbookGoldenTestsProperties properties,
  ) async {
    await pumpWidget(widget);
    await pumpAndSettle();
    await _precacheImagesAndWait(properties);
    await pumpAndSettle();
  }

  /// Precaches the images detected in the currently built widget to make sure
  /// they are shown in the saved golden file.
  Future<void> _precacheImagesAndWait(
    WidgetbookGoldenTestsProperties properties,
  ) async {
    await runAsync(() async {
      await precacheImages(properties);
      await Future.delayed(const Duration(milliseconds: 100));
    });
  }

  @visibleForTesting
  Future<void> precacheImages(
    WidgetbookGoldenTestsProperties properties, {
    Future<void> Function(ImageProvider<Object>, Element)?
    customPrecacheImage, // Mainly used for testing purposes
  }) async {
    // Find all Image widgets and precache their images
    final imageElements = find.byType(Image).evaluate();
    for (var element in imageElements) {
      final Image image = element.widget as Image;
      ImageProvider<Object> provider = image.image;
      if (provider is ResizeImage) {
        provider = provider.imageProvider;
      } else if (provider is NetworkImage &&
          provider.url == properties.loadingImageUrl) {
        continue;
      }

      // Use the custom precacheImage if provided, otherwise fallback to default
      var precacheFunction = customPrecacheImage ?? precacheImage;
      await precacheFunction(provider, element).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          // If timed out, perhaps there was some kind of unsupported Image Provider.
          return;
        },
      );
    }
  }
}
