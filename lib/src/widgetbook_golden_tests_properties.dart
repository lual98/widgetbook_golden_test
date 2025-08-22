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

  /// Creates a set of properties to configure Widgetbook golden tests.
  ///
  /// This constructor allows you to customize the appearance, localization,
  /// and network image behavior for your golden test runs.
  ///
  /// * [theme] – Optional theme data applied to the widgets under test.
  /// * [locale] – Locale to use for localization; defaults to English (US) if not provided.
  /// * [localizationsDelegates] – Delegates to load localized resources.
  /// * [supportedLocales] – List of supported locales (defaults to `[Locale('en', 'US')]`).
  /// * [skipTag] – Tag used to skip tests when present (defaults to `"[skip-golden]"`).
  /// * [errorImageUrl] – Placeholder URL for failed network images (defaults to `'error-network-image'`).
  /// * [loadingImageUrl] – Placeholder URL while loading network images (defaults to `'loading-network-image'`).
  /// * [testGroupName] – Name of the golden test group (used for grouping tests) (defaults to `'Widgetbook golden tests'`).
  ///
  /// Example:
  /// ```dart
  /// final properties = WidgetbookGoldenTestsProperties(
  ///   theme: ThemeData.dark(),
  ///   locale: const Locale('es'),
  ///   testGroupName: 'Custom Golden Tests',
  /// );
  /// ```
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
