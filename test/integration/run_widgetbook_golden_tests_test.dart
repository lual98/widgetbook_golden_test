import 'package:flutter/material.dart' show ThemeData;
import 'package:widgetbook_golden_test/src/run_widgetbook_golden_tests.dart';
import 'package:widgetbook_golden_test/src/widgetbook_golden_tests_properties.dart';

import '../../widgetbook/main.directories.g.dart';

void main() {
  runWidgetbookGoldenTests(
    nodes: directories,
    properties: WidgetbookGoldenTestsProperties(),
  );

  runWidgetbookGoldenTests(
    nodes: directories,
    goldenSnapshotsOutputPath: "./customized/",
    properties: WidgetbookGoldenTestsProperties(
      theme: ThemeData.dark(),
      // errorImageUrl: "loading-network-image",
      // loadingImageUrl: "error-network-image",
      skipTag: "Default",
      testGroupName: "Widgetbook golden tests with custom properties",
    ),
  );
}
