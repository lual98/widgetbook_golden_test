import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';

@widgetbook.UseCase(name: 'Long list with a button', type: ListView)
Widget buildListViewUseCase(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
    goldenActions: [
      GoldenPlayAction(
        name: "scrolled",
        callback: (tester, find) async => tester.dragUntilVisible(
          find.byType(ElevatedButton),
          find.byType(ListView),
          const Offset(0, -100),
        ),
      ),
    ],
    builder: (context) => ListView(
      children: [
        ...List.generate(20, (index) => ListTile(title: Text("Tile #$index"))),
        ElevatedButton(onPressed: () {}, child: Text("Hello World")),
      ],
    ),
  );
}
