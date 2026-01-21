import 'package:example/widgetbook.directories.g.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

/// Example with all the custom properties.
void main() {
  runWidgetbookGoldenTests(
    nodes: directories,
    goldenSnapshotsOutputPath: "./customized/",
    properties: WidgetbookGoldenTestsProperties(
      theme: ThemeData.dark(),
      // Swap un purpose error and loading URLs for testing purposes
      errorImageUrl: "loading-network-image",
      loadingImageUrl: "error-network-image",
      testGroupName: "Widgetbook golden tests with custom properties",
      addons: [
        ViewportAddon([AndroidViewports.samsungGalaxyA50]),
        GridAddon(),
        AlignmentAddon(initialAlignment: Alignment.center),
        TextScaleAddon(initialScale: 2),
      ],
    ),
  );
}
