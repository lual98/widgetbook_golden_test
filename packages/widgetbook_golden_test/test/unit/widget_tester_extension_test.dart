import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test/src/widget_tester_extension.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

void main() {
  group("pumpWidgetbookCase", () {
    testWidgets('should return the widgetToTest', (tester) async {
      final properties = WidgetbookGoldenTestsProperties();
      final useCase = WidgetbookUseCase(
        name: "Test use case",
        builder: (context) => Container(),
      );

      var widgetToTest = await tester.pumpWidgetbookCase(
        properties,
        useCase,
        null,
      );

      expect(widgetToTest, isA<Container>());
    });
  });

  testWidgets('pumps given widget', (tester) async {
    final properties = WidgetbookGoldenTestsProperties();
    final useCase = WidgetbookUseCase(
      name: "Test use case",
      builder: (context) => Text("Hello world"),
    );

    await tester.pumpWidgetbookCase(properties, useCase, null);

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
      expect(precacheCalls, equals(2)); // Only two should be precached
    });

    testWidgets('continues normally on timeout of 10 seconds', (tester) async {
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

  group("mergeAddons", () {
    test("should merge addons with replaceAndInsertAtEnd strategy", () {
      final propertyThemeAddon = MaterialThemeAddon(
        themes: [WidgetbookTheme(name: "property", data: ThemeData())],
      );
      final builderThemeAddon = MaterialThemeAddon(
        themes: [WidgetbookTheme(name: "builder", data: ThemeData())],
      );
      final gridAddon = GridAddon();
      final textScaleAddon = TextScaleAddon();
      final List<WidgetbookAddon> propertiesAddons = [propertyThemeAddon];
      final List<WidgetbookAddon> builderAddons = [
        textScaleAddon,
        builderThemeAddon,
        gridAddon,
      ];
      final result = mergeAddons(
        propertiesAddons,
        builderAddons,
        AddonsMergeStrategy.replaceAndInsertAtEnd,
      );
      expect(result, hasLength(3));
      expect(result, isNot(contains(propertyThemeAddon)));
      expect(result, contains(builderThemeAddon));
      expect(result?[1], textScaleAddon);
      expect(result?[2], gridAddon);
    });

    test("should merge addons with replaceAndInsertAtBeginning strategy", () {
      final propertyThemeAddon = MaterialThemeAddon(
        themes: [WidgetbookTheme(name: "property", data: ThemeData())],
      );
      final builderThemeAddon = MaterialThemeAddon(
        themes: [WidgetbookTheme(name: "builder", data: ThemeData())],
      );
      final gridAddon = GridAddon();
      final textScaleAddon = TextScaleAddon();
      final List<WidgetbookAddon> propertiesAddons = [propertyThemeAddon];
      final List<WidgetbookAddon> builderAddons = [
        textScaleAddon,
        builderThemeAddon,
        gridAddon,
      ];
      final result = mergeAddons(
        propertiesAddons,
        builderAddons,
        AddonsMergeStrategy.replaceAndInsertAtBeginning,
      );
      expect(result, hasLength(3));
      expect(result, isNot(contains(propertyThemeAddon)));
      expect(result, contains(builderThemeAddon));
      expect(result?[0], textScaleAddon);
      expect(result?[1], gridAddon);
    });

    test("should merge addons with overrideAll strategy", () {
      final propertyThemeAddon = MaterialThemeAddon(
        themes: [WidgetbookTheme(name: "property", data: ThemeData())],
      );
      final builderThemeAddon = MaterialThemeAddon(
        themes: [WidgetbookTheme(name: "builder", data: ThemeData())],
      );
      final gridAddon = GridAddon();
      final textScaleAddon = TextScaleAddon();
      final List<WidgetbookAddon> propertiesAddons = [propertyThemeAddon];
      final List<WidgetbookAddon> builderAddons = [
        textScaleAddon,
        builderThemeAddon,
        gridAddon,
      ];
      final result = mergeAddons(
        propertiesAddons,
        builderAddons,
        AddonsMergeStrategy.overrideAll,
      );
      expect(result, hasLength(3));
      expect(result, [textScaleAddon, builderThemeAddon, gridAddon]);
    });
  });
}
