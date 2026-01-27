import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

void main() {
  group("pumpWidgetbookCase", () {
    testWidgets('pumps given widget', (tester) async {
      final properties = WidgetbookGoldenTestsProperties();
      final useCase = WidgetbookUseCase(
        name: "Test use case",
        builder: (context) => Text("Hello world"),
      );

      await tester.pumpWidgetbookCase(
        MockedWidgetbookCase(
          useCase: useCase,
          properties: properties,
          builderAddons: null,
        ),
        properties,
      );

      expect(find.text("Hello world"), findsOneWidget);
    });

    group("precacheImages", () {
      testWidgets('precaches all but excluded images', (tester) async {
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
                Image(
                  image: ResizeImage(
                    MemoryImage(magentaPixel),
                    width: 200,
                    height: 200,
                  ),
                ),
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

        await tester.precacheImages(
          properties,
          customPrecacheImage: fakePrecache,
        );

        // Assert it tried to precache correct images
        expect(precacheCalls, equals(3)); // Only three should be precached
      });

      testWidgets('continues normally on timeout of 10 seconds', (
        tester,
      ) async {
        var completed = false;
        var magentaPixel = base64Decode(
          """iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAD0lEQVR4AQEEAPv/AP8A/wQAAf/2bp8NAAAAAElFTkSuQmCC""",
        );
        final properties = WidgetbookGoldenTestsProperties();
        Future<void> fakePrecache(
          ImageProvider provider, [
          BuildContext? context,
        ]) async {
          await Completer().future;
          return;
        }

        await tester.pumpWidget(Column(children: [Image.memory(magentaPixel)]));
        tester
            .precacheImages(properties, customPrecacheImage: fakePrecache)
            .then((_) => completed = true);
        await tester.pump(const Duration(seconds: 11));
        expect(completed, true);
      });
    });
  });
}
