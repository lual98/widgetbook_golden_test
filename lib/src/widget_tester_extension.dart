import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test/src/widgetbook_golden_tests_properties.dart';

class _WidgetbookStateMock extends Mock implements WidgetbookState {}

extension WidgetTesterExtension on WidgetTester {
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
    Widget baseWidget = WidgetbookScope(
      state: widgetbookStateMock,
      child: MaterialApp(
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

  Future<void> precacheImagesAndWait(
    WidgetbookGoldenTestsProperties properties,
  ) async {
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
        await precacheImage(provider, element);
      }

      await Future.delayed(const Duration(milliseconds: 100));
    });
  }
}
