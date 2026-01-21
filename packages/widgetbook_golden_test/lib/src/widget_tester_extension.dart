import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// ignore: implementation_imports
import 'package:widgetbook/src/addons/addons.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

class _WidgetbookStateMock extends Mock implements WidgetbookState {}

/// Extension to add custom functionality to [WidgetTester] required by the widgetbook golden tests.
extension WidgetTesterExtension on WidgetTester {
  /// Pumps the builder in the [useCase] and returns the pumped widget.
  /// The built widget is wrapped with the necessary parents to be pumped properly
  /// like a [WidgetbookScope], a [MaterialApp] and a [Scaffold].
  Future<Widget> pumpWidgetbookCase(
    WidgetbookGoldenTestsProperties properties,
    WidgetbookUseCase useCase,
    List<WidgetbookAddon>? builderAddons,
  ) async {
    late Widget widgetToTest;
    var widgetbookStateMock = _WidgetbookStateMock();
    when(() => widgetbookStateMock.queryParams).thenReturn({});
    when(
      () => widgetbookStateMock.knobs,
    ).thenReturn(KnobsRegistry(onLock: () {}));
    when(() => widgetbookStateMock.addons).thenReturn(properties.addons);
    when(() => widgetbookStateMock.previewMode).thenReturn(true);
    Widget baseWidget = WidgetbookScope(
      state: widgetbookStateMock,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // ignore: deprecated_member_use
        locale: properties.locale,
        // ignore: deprecated_member_use
        localizationsDelegates: properties.localizationsDelegates,
        // ignore: deprecated_member_use
        supportedLocales: properties.supportedLocales,
        theme: properties.theme,
        home: Material(
          child: MultiAddonBuilder(
            addons: mergeAddons(
              properties.addons,
              builderAddons,
              properties.addonsMergeStrategy,
            ),
            builder: (context, addon, child) {
              final newSetting = addon.valueFromQueryGroup({});
              return addon.buildUseCase(context, child, newSetting);
            },
            child: Builder(
              builder: (context) {
                widgetToTest = useCase.builder(context);
                return widgetToTest;
              },
            ),
          ),
        ),
      ),
    );

    await pumpWidget(baseWidget);
    await pumpAndSettle();
    await _precacheImagesAndWait(properties);
    await pumpAndSettle();
    return widgetToTest;
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

@visibleForTesting
List<WidgetbookAddon>? mergeAddons(
  List<WidgetbookAddon>? propertiesAddons,
  List<WidgetbookAddon>? builderAddons,
  AddonsMergeStrategy addonsMergeStrategy,
) {
  if (builderAddons == null) {
    return propertiesAddons;
  }

  if (addonsMergeStrategy == AddonsMergeStrategy.overrideAll) {
    return builderAddons;
  }

  final List<WidgetbookAddon> newAddons = [];
  final Map<Type, WidgetbookAddon> builderAddonsMap = {};
  for (var addon in builderAddons) {
    builderAddonsMap[addon.runtimeType] = addon;
  }
  if (propertiesAddons != null) {
    for (var addon in propertiesAddons) {
      if (builderAddonsMap.containsKey(addon.runtimeType)) {
        newAddons.add(builderAddonsMap[addon.runtimeType]!);
        builderAddonsMap.remove(addon.runtimeType);
      } else {
        newAddons.add(addon);
      }
    }
  }
  if (addonsMergeStrategy == AddonsMergeStrategy.replaceAndInsertAtEnd) {
    newAddons.addAll(builderAddonsMap.values);
  }

  if (addonsMergeStrategy == AddonsMergeStrategy.replaceAndInsertAtBeginning) {
    return [...builderAddonsMap.values, ...newAddons];
  }

  return newAddons;
}
