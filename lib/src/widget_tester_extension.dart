import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
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
    Widget baseWidget = WidgetbookScope(
      state: widgetbookStateMock,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: properties.locale,
        localizationsDelegates: properties.localizationsDelegates,
        supportedLocales: properties.supportedLocales,
        theme: properties.theme,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              widgetToTest = useCase.builder(context);
              return widgetToTest;
            },
          ),
        ),
      ),
    );

    await pumpWidget(baseWidget);
    await pumpAndSettle();
    await precacheImagesAndWait(properties);
    await pumpAndSettle();
    return widgetToTest;
  }

  /// Precaches the images detected in the currently built widget to make sure
  /// they are shown in the saved golden file.
  Future<void> precacheImagesAndWait(
    WidgetbookGoldenTestsProperties properties, {
    Future<void> Function(ImageProvider<Object>, Element)?
    customPrecacheImage, // Mainly used for testing purposes
  }) async {
    await runAsync(() async {
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
        if (customPrecacheImage != null) {
          await customPrecacheImage(provider, element);
        } else {
          await precacheImage(provider, element);
        }
      }

      await Future.delayed(const Duration(milliseconds: 100));
    });
  }
}
