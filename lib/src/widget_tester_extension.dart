import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// ignore: implementation_imports
import 'package:widgetbook/src/addons/addons.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test/src/widgetbook_golden_tests_properties.dart';

class _WidgetbookStateMock extends Mock implements WidgetbookState {}

/// Extension to add custom functionality to [WidgetTester] required by the widgetbook golden tests.
extension WidgetTesterExtension on WidgetTester {
  /// Pumps the builder in the [useCase] and returns the pumped widget.
  /// The built widget is wrapped with the necessary parents to be pumped properly
  /// like a [WidgetbookScope], a [MaterialApp] and a [Scaffold].
  Future<Widget> pumpWidgetbookCase(
    WidgetbookGoldenTestsProperties properties,
    WidgetbookUseCase useCase,
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
        locale: properties.locale,
        localizationsDelegates: properties.localizationsDelegates,
        supportedLocales: properties.supportedLocales,
        theme: properties.theme,
        home: Material(
          child: MultiAddonBuilder(
            addons: properties.addons,
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
