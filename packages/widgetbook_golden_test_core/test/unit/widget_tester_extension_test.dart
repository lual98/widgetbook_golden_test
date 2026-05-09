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

      testWidgets('continues normally on timeout using default 10 seconds', (
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

      testWidgets('uses configurable precacheImagesTimeout', (tester) async {
        var completed = false;
        var magentaPixel = base64Decode(
          """iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAD0lEQVR4AQEEAPv/AP8A/wQAAf/2bp8NAAAAAElFTkSuQmCC""",
        );

        // Use a short timeout of 500ms to verify the configurable value is used
        final properties = WidgetbookGoldenTestsProperties(
          precacheImagesTimeout: const Duration(milliseconds: 500),
        );

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
        // Wait longer than 500ms but less than the default 10s
        await tester.pump(const Duration(milliseconds: 600));
        expect(completed, isTrue);
      });

      testWidgets('waits full configurable timeout before timing out', (
        tester,
      ) async {
        var completed = false;
        var magentaPixel = base64Decode(
          """iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAD0lEQVR4AQEEAPv/AP8A/wQAAf/2bp8NAAAAAElFTkSuQmCC""",
        );

        // Use a longer timeout of 5 seconds to verify it waits the full duration
        final properties = WidgetbookGoldenTestsProperties(
          precacheImagesTimeout: const Duration(seconds: 5),
        );

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
        // Wait 4 seconds - should NOT be complete yet (timeout is 5s)
        await tester.pump(const Duration(seconds: 4));
        expect(completed, isFalse);

        // Pump past the timeout - should now be complete
        await tester.pump(const Duration(milliseconds: 1001));
        expect(completed, isTrue);
      });

      testWidgets('handles zero duration timeout', (tester) async {
        var completed = false;
        var magentaPixel = base64Decode(
          """iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAD0lEQVR4AQEEAPv/AP8A/wQAAf/2bp8NAAAAAElFTkSuQmCC""",
        );

        final properties = WidgetbookGoldenTestsProperties(
          precacheImagesTimeout: Duration.zero,
        );

        Future<void> fakePrecache(
          ImageProvider provider, [
          BuildContext? context,
        ]) async {
          await Completer().future;
          return;
        }

        await tester.pumpWidget(Column(children: [Image.memory(magentaPixel)]));
        // With zero timeout, the future should complete immediately (or very quickly)
        tester
            .precacheImages(properties, customPrecacheImage: fakePrecache)
            .then((_) => completed = true);
        await tester.pump(Duration.zero);
        expect(completed, isTrue);
      });

      testWidgets('handles empty image list gracefully', (tester) async {
        final properties = WidgetbookGoldenTestsProperties();

        // No Image widgets in the tree - should not throw
        await tester.pumpWidget(
          MaterialApp(home: const Text("No images here")),
        );

        expect(() => tester.precacheImages(properties), returnsNormally);
      });
    });
  });
}
