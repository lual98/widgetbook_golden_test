import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';

@widgetbook.UseCase(name: 'Red', type: SizedBox)
Widget buildRedSizedBoxUseCase(BuildContext context) {
  return SizedBox(height: 20, width: 20, child: Container(color: Colors.red));
}

@widgetbook.UseCase(
  name: '${WidgetbookGoldenTestsProperties.defaultSkipTag}Green',
  type: SizedBox,
)
Widget buildGreenSizedBoxUseCase(BuildContext context) {
  return SizedBox(
    height: 200,
    width: 200,
    child: Container(color: Colors.green),
  );
}

@widgetbook.UseCase(name: 'Blue', type: SizedBox)
Widget buildBlueSizedBoxUseCase(BuildContext context) {
  return SizedBox(
    height: 200,
    width: 200,
    child: Container(color: Colors.blue),
  );
}

@widgetbook.UseCase(name: '[skip-other]Purple', type: SizedBox)
Widget buildPurpleSizedBoxUseCase(BuildContext context) {
  return SizedBox(
    height: 200,
    width: 200,
    child: Container(color: Colors.purple),
  );
}

@widgetbook.UseCase(name: 'Yellow', type: SizedBox)
Widget buildPurpleSizedBoxUseCaseYellow(BuildContext context) {
  return SizedBox(
    height: 200,
    width: 200,
    child: Container(color: Colors.yellow),
  );
}
