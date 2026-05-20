import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';

void main() {
  group("runWidgetbookGoldenTests", () {
    bool useCaseBuilt = false;

    final nodes = [
      WidgetbookComponent(
        name: 'TestComponent',
        useCases: [
          WidgetbookUseCase(
            name: 'TestUseCase',
            builder: (context) {
              useCaseBuilt = true;
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    ];

    runWidgetbookGoldenTests(
      nodes: nodes,
      properties: WidgetbookGoldenTestsProperties(),
      goldenSnapshotsOutputPath: "./snapshots/",
    );

    tearDownAll(() {
      expect(useCaseBuilt, true);
    });
  });
}
