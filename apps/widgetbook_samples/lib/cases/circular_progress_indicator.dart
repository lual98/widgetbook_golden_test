import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';

@widgetbook.UseCase(name: 'At 500ms', type: CircularProgressIndicator)
Widget widgetbookUseCase(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    pumpBeforeImagePrecache: (_) async => {},
    pumpAfterImagePrecache: (tester) async => {
      await tester.pump(const Duration(milliseconds: 500)),
    },
    builder: (context) => const CircularProgressIndicator(),
  );
}

@widgetbook.UseCase(name: 'At 800ms', type: CircularProgressIndicator)
Widget widgetbookUseCaseAt800ms(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    pumpBeforeImagePrecache: (_) async => {},
    pumpAfterImagePrecache: (tester) async => {
      await tester.pump(const Duration(milliseconds: 800)),
    },
    builder: (context) => const CircularProgressIndicator(),
  );
}
