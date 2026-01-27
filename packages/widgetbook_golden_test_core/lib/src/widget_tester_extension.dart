import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

/// Extension to add custom functionality to [WidgetTester] required by the widgetbook golden tests.
extension WidgetTesterExtension on WidgetTester {
  /// Pumps the given [widget] and handles network images based on the [properties].
  ///
  /// This method calls [pumpWidget], [pumpAndSettle], and [precacheImages] to ensure
  /// all images are loaded before taking a golden snapshot.
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

  /// Finds all [Image] widgets in the current tree and precaches their images.
  ///
  /// This ensures that images (especially network images) are fully loaded and rendered
  /// before a golden snapshot is captured.
  ///
  /// [properties] are used to identify special URLs (like loading/error URLs).
  /// [customPrecacheImage] can be provided for testing purposes.
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
