import 'dart:ui' show Locale;

import 'package:flutter/material.dart' show ThemeData;
import 'package:widgetbook_cases/l10n/app_localizations.dart';
import 'package:widgetbook_cases/main.directories.g.dart';
import 'package:widgetbook_golden_test/src/run_widgetbook_golden_tests.dart';
import 'package:widgetbook_golden_test/src/widgetbook_golden_tests_properties.dart';

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
    ),
  );
}
