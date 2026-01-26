import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

void main() {
  group('goldenTestZoneRunner', () {
    testWidgets('runs the test body', (tester) async {
      var executed = false;
      await goldenTestZoneRunner(
        testBody: () async {
          executed = true;
        },
        properties: WidgetbookGoldenTestsProperties(),
      );
      expect(executed, true);
    });

    testWidgets('mocks network image', (tester) async {
      await goldenTestZoneRunner(
        testBody: () async {
          await tester.pumpWidget(
            Image.network("https://example.com/image.png"),
          );
        },
        properties: WidgetbookGoldenTestsProperties(),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('mocks network image with error', (tester) async {
      await goldenTestZoneRunner(
        testBody: () async {
          await tester.pumpWidget(
            MaterialApp(
              home: Image.network(
                WidgetbookGoldenTestsProperties.defaultErrorImageUrl,
                errorBuilder: (context, error, stackTrace) {
                  return Text("error loading");
                },
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text("error loading"), findsOneWidget);
        },
        properties: WidgetbookGoldenTestsProperties(),
      );
    });

    testWidgets('mocks network image with loading', (tester) async {
      await goldenTestZoneRunner(
        testBody: () async {
          await tester.pumpWidget(
            MaterialApp(
              home: Image.network(
                WidgetbookGoldenTestsProperties.defaultLoadingImageUrl,
                loadingBuilder: (context, child, loadingProgress) {
                  return Text("loading");
                },
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text("loading"), findsOneWidget);
        },
        properties: WidgetbookGoldenTestsProperties(),
      );
    });

    testWidgets('mocks svg network image', (tester) async {
      await goldenTestZoneRunner(
        testBody: () async {
          await tester.pumpWidget(
            SvgPicture.network("https://example.com/image.svg"),
          );
        },
        properties: WidgetbookGoldenTestsProperties(),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('mocks svg network image with error', (tester) async {
      await goldenTestZoneRunner(
        testBody: () async {
          await tester.pumpWidget(
            MaterialApp(
              home: SvgPicture.network(
                WidgetbookGoldenTestsProperties.defaultErrorImageUrl,
                errorBuilder: (context, error, stackTrace) {
                  return Text("error loading");
                },
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text("error loading"), findsOneWidget);
        },
        properties: WidgetbookGoldenTestsProperties(),
      );
    });

    testWidgets('mocks svg network image with loading', (tester) async {
      await goldenTestZoneRunner(
        testBody: () async {
          await tester.pumpWidget(
            MaterialApp(
              home: SvgPicture.network(
                WidgetbookGoldenTestsProperties.defaultLoadingImageUrl,
                placeholderBuilder: (context) {
                  return Text("loading");
                },
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text("loading"), findsOneWidget);
        },
        properties: WidgetbookGoldenTestsProperties(),
      );
    });

    testWidgets("calls custom onError when there is an error during the test", (
      tester,
    ) async {
      var executed = false;
      var properties = WidgetbookGoldenTestsProperties(
        onTestError: (details, originalOnError) {
          if (details.exception is ProviderNotFoundException) {
            executed = true;
            return;
          }
          originalOnError?.call(details);
        },
      );

      await goldenTestZoneRunner(
        testBody: () async {
          await tester.pumpWidget(
            Consumer<String>(builder: (context, value, child) => Container()),
          );

          await tester.pumpAndSettle();
        },
        properties: properties,
      );

      expect(executed, true);
    });

    testWidgets("calls custom onError when testBody throws exception", (
      tester,
    ) async {
      var executed = false;
      var properties = WidgetbookGoldenTestsProperties(
        onTestError: (details, originalOnError) {
          executed = true;
        },
      );

      await goldenTestZoneRunner(
        testBody: () async {
          throw Exception("test");
        },
        properties: properties,
      );

      expect(executed, true);
    });

    testWidgets(
      "throws when testBody throws exception and no onError is provided",
      (tester) async {
        var properties = WidgetbookGoldenTestsProperties();

        expect(
          () async => await goldenTestZoneRunner(
            testBody: () async {
              throw Exception("test");
            },
            properties: properties,
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });

  group('handleError', () {
    testWidgets('calls defaultOnError by default', (tester) async {
      final previousOnError = FlutterError.onError;
      bool calledCustomPreviousOnError = false;
      void myOnError(FlutterErrorDetails details) {
        calledCustomPreviousOnError = true;
      }

      FlutterError.onError = (FlutterErrorDetails details) {
        handleError(details, WidgetbookGoldenTestsProperties(), myOnError);
      };

      await tester.pumpWidget(
        Consumer<String>(builder: (context, value, child) => Container()),
      );
      await tester.pumpAndSettle();

      FlutterError.onError = previousOnError;
      expect(calledCustomPreviousOnError, true);
    });

    testWidgets('throws when no previousOnError is provided', (tester) async {
      expect(
        () => handleError(
          FlutterErrorDetails(
            exception: Exception("test"),
            stack: StackTrace.current,
            context: ErrorDescription("test"),
          ),
          WidgetbookGoldenTestsProperties(),
          null,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
