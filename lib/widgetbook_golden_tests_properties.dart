import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

class WidgetbookGoldenTestsProperties {
  final List<WidgetbookNode> nodes;
  final String basePath;
  final ThemeData? theme;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale>? supportedLocales;
  final String skipTag;
  final String errorImageUrl;

  const WidgetbookGoldenTestsProperties({
    required this.nodes,
    this.basePath = ".",
    this.theme,
    this.locale,
    this.localizationsDelegates,
    this.supportedLocales,
    this.skipTag = "[skip-golden]",
    this.errorImageUrl = "error-network-image",
  });
}
