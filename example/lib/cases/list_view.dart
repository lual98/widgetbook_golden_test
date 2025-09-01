import 'package:flutter/material.dart';
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Long list with a button', type: ListView)
Widget buildListViewUseCase(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    goldenActions: [
      GoldenPlayAction(
        name: "scrolled",
        callback:
            (tester, find) async => tester.dragUntilVisible(
              find.byType(ElevatedButton),
              find.byType(ListView),
              const Offset(0, -100),
            ),
      ),
    ],
    child: ListView(
      children: [
        ...List.generate(20, (index) => ListTile(title: Text("Tile #$index"))),
        ElevatedButton(onPressed: () {}, child: Text("Hello World")),
      ],
    ),
  );
}
