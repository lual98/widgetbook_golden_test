import 'package:flutter/material.dart';

class WidgetbookGoldenTestsProperties {
  final ThemeData? theme;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale>? supportedLocales;
  final String skipTag;
  final String errorImageUrl;
  final String loadingImageUrl;

  const WidgetbookGoldenTestsProperties({
    this.theme,
    this.locale,
    this.localizationsDelegates,
    this.supportedLocales,
    this.skipTag = "[skip-golden]",
    this.errorImageUrl = "error-network-image",
    this.loadingImageUrl = "loading-network-image",
  });
}
