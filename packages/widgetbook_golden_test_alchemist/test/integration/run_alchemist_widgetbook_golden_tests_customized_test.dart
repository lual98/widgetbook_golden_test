import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_alchemist/widgetbook_golden_test_alchemist.dart';
import 'package:widgetbook_samples/cases/text_cases.dart';
import 'package:widgetbook_samples/l10n/app_localizations.dart';
import 'package:widgetbook_samples/main.directories.g.dart';

void main() async {
  // Pre-load assets
  var androidSvg = await File("../../assets/android.svg").readAsBytes();
  var sampleJpg = await File(
    "../../assets/lorem_picsum_sample.jpg",
  ).readAsBytes();
  const isRunningInCi = bool.fromEnvironment(
    'CI',
    defaultValue: true,
  ); //  We will default this to true for now because it has inconsistent behavior if it runs on all platforms
  AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(enabled: !isRunningInCi),
    ),
    run: () {
      runAlchemistWidgetbookGoldenTests(
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
            LocalizationAddon(
              locales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              initialLocale: Locale("es"),
            ),
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
    },
  );
}
