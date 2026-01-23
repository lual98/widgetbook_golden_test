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
                "error",
                errorBuilder: (context, error, stackTrace) {
                  return Text("error loading");
                },
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text("error loading"), findsOneWidget);
        },
        properties: WidgetbookGoldenTestsProperties(errorImageUrl: "error"),
      );
    });

    testWidgets('mocks network image with loading', (tester) async {
      await goldenTestZoneRunner(
        testBody: () async {
          await tester.pumpWidget(
            MaterialApp(
              home: Image.network(
                "loading",
                loadingBuilder: (context, child, loadingProgress) {
                  return Text("loading");
                },
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text("loading"), findsOneWidget);
        },
        properties: WidgetbookGoldenTestsProperties(loadingImageUrl: "loading"),
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
