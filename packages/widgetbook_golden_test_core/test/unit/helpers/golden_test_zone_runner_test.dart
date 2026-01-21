import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

void main() {
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
