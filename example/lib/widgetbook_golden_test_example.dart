import 'package:example/l10n/app_localizations.dart';
import 'package:example/widgetbook.directories.g.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';

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
      skipTag: "Default",
      testGroupName: "Widgetbook golden tests with custom properties",
      locale: Locale("es"),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      addons: [
        ViewportAddon([AndroidViewports.samsungGalaxyA50]),
        GridAddon(),
        AlignmentAddon(initialAlignment: Alignment.center),
        TextScaleAddon(initialScale: 2),
      ],
    ),
  );
}
