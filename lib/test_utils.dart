import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mocktail_image_network/mocktail_image_network.dart';

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

Future<void> mockGoldenNetworkImage(
  WidgetTester widgetTester,
  Widget baseWidget,
  String errorImageUrl,
) async {
  await mockNetworkImages(
    () async => await widgetTester.pumpWidget(baseWidget),
    imageResolver: (uri) {
      if (uri.toString().endsWith(errorImageUrl)) {
        // Use the provided errorImageUrl
        // If the URI is the errorImageUrl, return an empty list to simulate an error.
        return <int>[];
      }
      // Otherwise, return a valid image (transparent PNG)
      return base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
      );
    },
  );
}
