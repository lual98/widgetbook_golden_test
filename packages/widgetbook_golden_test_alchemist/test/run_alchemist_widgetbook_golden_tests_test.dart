import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_alchemist/widgetbook_golden_test_alchemist.dart';

void main() {
  group("runAlchemistWidgetbookGoldenTests", () {
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

    runAlchemistWidgetbookGoldenTests(
      nodes: nodes,
      properties: WidgetbookGoldenTestsProperties(),
      goldenSnapshotsOutputPath: "./snaphots/",
    );

    tearDownAll(() {
      expect(useCaseBuilt, true);
    });
  });
}
