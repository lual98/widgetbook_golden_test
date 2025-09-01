import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';

@widgetbook.UseCase(name: 'Menu Button', type: PopupMenuButton)
Widget buildPopupMenuButtonUseCase(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    goldenActions: [
      GoldenPlayAction(
        name: "clicked",
        callback:
            (tester, find) async => tester.tap(find.byType(PopupMenuButton)),
        goldenFinder: (find) => find.byType(MaterialApp).first,
      ),
    ],
    child: PopupMenuButton(
      itemBuilder:
          (context) => [
            PopupMenuItem(child: Text("First option")),
            PopupMenuItem(child: Icon(Icons.share)),
          ],
    ),
  );
}
