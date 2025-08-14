import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

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
