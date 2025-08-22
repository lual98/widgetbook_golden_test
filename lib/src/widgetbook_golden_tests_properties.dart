import 'package:flutter/material.dart';

/// Properties for configuring widgetbook golden tests.
class WidgetbookGoldenTestsProperties {
  /// The theme data used to customize the appearance of widgets in the app.
  final ThemeData? theme;

  /// The locale used for localization purposes.
  final Locale? locale;

  /// Delegates that provide localized resources for the app.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Supported locales that the app supports.
  final Iterable<Locale> supportedLocales;

  /// Tag used to identify tests that should be skipped during golden testing.
  final String skipTag;

  /// URL of the image to display when a network request fails.
  final String errorImageUrl;

  /// URL of the image to display while a network request is in progress.
  final String loadingImageUrl;

  /// Name of the group of tests being run.
  final String testGroupName;

  const WidgetbookGoldenTestsProperties({
    this.theme,
    this.locale,
    this.localizationsDelegates,
    this.supportedLocales = const [Locale('en', 'US')],
    this.skipTag = "[skip-golden]",
    this.errorImageUrl = "error-network-image",
    this.loadingImageUrl = "loading-network-image",
    this.testGroupName = "Widgetbook golden tests",
  });
}
