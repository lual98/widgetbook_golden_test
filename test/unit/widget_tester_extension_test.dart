import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:widgetbook/widgetbook.dart' show WidgetbookUseCase;
import 'package:widgetbook_golden_test/src/widget_tester_extension.dart';
import 'package:widgetbook_golden_test/src/widgetbook_golden_tests_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("pumpWidgetbookCase", () {
    testWidgets('should return the widgetToTest', (tester) async {
      final properties = WidgetbookGoldenTestsProperties();
      final useCase = WidgetbookUseCase(
        name: "Test use case",
        builder: (context) => Container(),
      );

      var widgetToTest = await tester.pumpWidgetbookCase(properties, useCase);

      expect(widgetToTest, isA<Container>());
    });
  });

  testWidgets('pumps given widget', (tester) async {
    final properties = WidgetbookGoldenTestsProperties();
    final useCase = WidgetbookUseCase(
      name: "Test use case",
      builder: (context) => Text("Hello world"),
    );

    await tester.pumpWidgetbookCase(properties, useCase);

    expect(find.text("Hello world"), findsOneWidget);
  });

  group("precacheImagesAndWait", () {
    testWidgets('precacheImagesAndWait precaches all but excluded images', (
      tester,
    ) async {
      final properties = WidgetbookGoldenTestsProperties(
        loadingImageUrl: 'https://example.com/loading.png',
      );
      var magentaPixel = base64Decode(
        """iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAD0lEQVR4AQEEAPv/AP8A/wQAAf/2bp8NAAAAAElFTkSuQmCC""",
      );

      await mockNetworkImages(
        () async => tester.pumpWidget(
          Column(
            children: [
              Image.network('https://example.com/image1.png'),
              Image.memory(magentaPixel),
              Image.network(properties.loadingImageUrl), // should be skipped
            ],
          ),
        ),
      );
      int precacheCalls = 0;
      Future<void> fakePrecache(
        ImageProvider provider, [
        BuildContext? context,
      ]) async {
        precacheCalls++;
        return;
      }

      await tester.precacheImagesAndWait(
        properties,
        customPrecacheImage: fakePrecache,
      );

      // Assert it tried to precache correct images
      expect(precacheCalls, equals(2)); // Only two should be precached
    });
  });
}
