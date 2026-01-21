import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

typedef NetworkImageResolver = List<int> Function(Uri uri);

/// Properties for configuring widgetbook golden tests.
class WidgetbookGoldenTestsProperties {
  /// Default string tag to skip golden tests execution
  @Deprecated("Use 'skip' property in WidgetbookGoldenTestBuilder instead")
  static const String defaultSkipTag = "[skip-golden]";

  /// Default string url to handle network images as error images.
  static const String defaultErrorImageUrl = "error-network-image";

  /// Default string url to load network images indefinitely.
  static const String defaultLoadingImageUrl = "loading-network-image";

  /// The list of addons that are available in the Widgetbook.
  final List<WidgetbookAddon>? addons;

  /// The strategy to merge addons.
  final AddonsMergeStrategy addonsMergeStrategy;

  /// The theme data used to customize the appearance of widgets in the app.
  final ThemeData? theme;

  /// The locale used for localization purposes.
  @Deprecated("Use 'LocalizationAddon' in 'addons' property instead")
  final Locale? locale;

  /// Delegates that provide localized resources for the app.
  @Deprecated("Use 'LocalizationAddon' in 'addons' property instead")
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Supported locales that the app supports.
  @Deprecated("Use 'LocalizationAddon' in 'addons' property instead")
  final Iterable<Locale> supportedLocales;

  /// Tag used to identify tests that should be skipped during golden testing.
  @Deprecated("Use 'skip' property in WidgetbookGoldenTestBuilder instead")
  final String skipTag;

  /// URL of the image to display when a network request fails.
  final String errorImageUrl;

  /// URL of the image to display while a network request is in progress.
  final String loadingImageUrl;

  /// Name of the group of tests being run.
  final String testGroupName;

  /// Custom function that handles errors during golden tests.
  /// It has access to the original OnError function.
  final Function(
    FlutterErrorDetails,
    Function(FlutterErrorDetails)? originalOnError,
  )?
  onTestError;

  /// Custom function that resolves images from URIs for the Widgetbook golden tests.
  final NetworkImageResolver? networkImageResolver;

  /// Creates a set of properties to configure Widgetbook golden tests.
  ///
  /// This constructor allows you to customize the appearance, localization,
  /// and network image behavior for your golden test runs.
  ///
  /// * [addons] - Optional Widgetbook addons that will be applied to the golden snapshots by using their default values.
  /// * [theme] – Optional theme data applied to the widgets under test.
  /// * [locale] – Locale to use for localization; defaults to English (US) if not provided.
  /// * [localizationsDelegates] – Delegates to load localized resources.
  /// * [supportedLocales] – List of supported locales (defaults to `[Locale('en', 'US')]`).
  /// * [skipTag] – Tag used to skip tests when present (defaults to `"[skip-golden]"`).
  /// * [errorImageUrl] – Placeholder URL for failed network images (defaults to `'error-network-image'`).
  /// * [loadingImageUrl] – Placeholder URL while loading network images (defaults to `'loading-network-image'`).
  /// * [testGroupName] – Name of the golden test group (used for grouping tests) (defaults to `'Widgetbook golden tests'`).
  /// * [onTestError] - Function to be called when there is an error during the golden tests.
  /// * [networkImageResolver] - Custom function that resolves images from a given URI.
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
    this.addons,
    this.addonsMergeStrategy = AddonsMergeStrategy.replaceAndInsertAtBeginning,
    this.theme,
    @Deprecated("Use 'LocalizationAddon' in 'addons' property instead")
    this.locale,
    @Deprecated("Use 'LocalizationAddon' in 'addons' property instead")
    this.localizationsDelegates,
    @Deprecated("Use 'LocalizationAddon' in 'addons' property instead")
    this.supportedLocales = const [Locale('en', 'US')],
    @Deprecated("Use 'skip' property in WidgetbookGoldenTestBuilder instead")
    this.skipTag = defaultSkipTag,
    this.errorImageUrl = defaultErrorImageUrl,
    this.loadingImageUrl = defaultLoadingImageUrl,
    this.testGroupName = "Widgetbook golden tests",
    this.onTestError,
    this.networkImageResolver,
  });

  /// Creates a copy of this object with the specified fields overridden.
  WidgetbookGoldenTestsProperties copyWith({
    List<WidgetbookAddon>? addons,
    ThemeData? theme,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales,
    String? skipTag,
    String? errorImageUrl,
    String? loadingImageUrl,
    String? testGroupName,
    Function(FlutterErrorDetails, Function(FlutterErrorDetails)?)? onTestError,
    NetworkImageResolver? networkImageResolver,
  }) {
    return WidgetbookGoldenTestsProperties(
      addons: addons ?? this.addons,
      // ignore: deprecated_member_use_from_same_package
      theme: theme ?? this.theme,
      // ignore: deprecated_member_use_from_same_package
      locale: locale ?? this.locale,
      // ignore: deprecated_member_use_from_same_package
      localizationsDelegates:
          // ignore: deprecated_member_use_from_same_package
          localizationsDelegates ?? this.localizationsDelegates,
      // ignore: deprecated_member_use_from_same_package
      supportedLocales: supportedLocales ?? this.supportedLocales,
      // ignore: deprecated_member_use_from_same_package
      skipTag: skipTag ?? this.skipTag,
      errorImageUrl: errorImageUrl ?? this.errorImageUrl,
      loadingImageUrl: loadingImageUrl ?? this.loadingImageUrl,
      testGroupName: testGroupName ?? this.testGroupName,
      onTestError: onTestError ?? this.onTestError,
      networkImageResolver: networkImageResolver ?? this.networkImageResolver,
    );
  }
}
