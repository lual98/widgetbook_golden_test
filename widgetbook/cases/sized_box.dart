import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Red', type: SizedBox)
Widget buildRedSizedBoxUseCase(BuildContext context) {
  return SizedBox(height: 20, width: 20, child: Container(color: Colors.red));
}

@widgetbook.UseCase(name: 'Blue', type: SizedBox)
Widget buildBlueSizedBoxUseCase(BuildContext context) {
  return SizedBox(
    height: 200,
    width: 200,
    child: Container(color: Colors.blue),
  );
}
