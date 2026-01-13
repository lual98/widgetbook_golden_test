import 'dart:io';

import 'package:example/cases/text_cases.dart';
import 'package:example/l10n/app_localizations.dart';
import 'package:example/widgetbook.directories.g.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';

void main() async {
  // Pre-load assets
  var androidSvg = await File("./test/assets/android.svg").readAsBytes();
  var sampleJpg =
      await File("./test/assets/lorem_picsum_sample.jpg").readAsBytes();
  runWidgetbookGoldenTests(
    nodes: directories,
    goldenSnapshotsOutputPath: "./customized/",
    properties: WidgetbookGoldenTestsProperties(
      theme: ThemeData.dark(),
      // Swap un purpose error and loading URLs for testing purposes
      errorImageUrl: "loading-network-image",
      loadingImageUrl: "error-network-image",
      testGroupName: "Widgetbook golden tests with custom properties",
      locale: Locale("es"),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      addons: [
        ViewportAddon([AndroidViewports.samsungGalaxyA50]),
        GridAddon(),
        AlignmentAddon(initialAlignment: Alignment.center),
        TextScaleAddon(initialScale: 2),
        ThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Dark',
              data: ThemeData.dark().copyWith(
                extensions: [MyCustomTheme.dark()],
              ),
            ),
          ],
          themeBuilder: (BuildContext context, theme, Widget child) {
            return Theme(data: theme, child: child);
          },
        ),
      ],
      networkImageResolver: (uri) {
        if (uri.path.toLowerCase().endsWith(".svg")) {
          return androidSvg;
        }
        return sampleJpg;
      },
    ),
  );
}
