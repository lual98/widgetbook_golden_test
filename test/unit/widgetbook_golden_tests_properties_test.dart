import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';

void main() {
  test("it's created with default properties", () {
    final defaultProperties = WidgetbookGoldenTestsProperties();

    expect(defaultProperties.theme, null);
    expect(defaultProperties.locale, null);
    expect(defaultProperties.localizationsDelegates, null);
    expect(defaultProperties.supportedLocales, const [Locale('en', 'US')]);
    expect(defaultProperties.skipTag, "[skip-golden]");
    expect(defaultProperties.errorImageUrl, "error-network-image");
    expect(defaultProperties.loadingImageUrl, "loading-network-image");
    expect(defaultProperties.testGroupName, "Widgetbook golden tests");
  });

  test("it's created with custom properties", () {
    final customProperties = WidgetbookGoldenTestsProperties(
      theme: ThemeData(primaryColor: Colors.blue),
      locale: Locale('fr', 'FR'),
      localizationsDelegates: const [],
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      skipTag: "[custom-skip]",
      errorImageUrl: "custom-error-image",
      loadingImageUrl: "custom-loading-image",
      testGroupName: "Custom golden tests",
    );

    expect(customProperties.theme, isNotNull);
    expect(customProperties.locale, isNotNull);
    expect(customProperties.localizationsDelegates, isNotNull);
    expect(customProperties.supportedLocales.length, 2);
    expect(customProperties.skipTag, "[custom-skip]");
    expect(customProperties.errorImageUrl, "custom-error-image");
    expect(customProperties.loadingImageUrl, "custom-loading-image");
    expect(customProperties.testGroupName, "Custom golden tests");
  });

  test(
    "copyWith creates a copy with no changes when no parameters are passed",
    () {
      final original = WidgetbookGoldenTestsProperties();
      final copied = original.copyWith();

      expect(copied.theme, isNull);
      expect(copied.locale, isNull);
      expect(copied.localizationsDelegates, isNull);
      expect(copied.supportedLocales, const [Locale('en', 'US')]);
      expect(copied.skipTag, "[skip-golden]");
      expect(copied.errorImageUrl, "error-network-image");
      expect(copied.loadingImageUrl, "loading-network-image");
      expect(copied.testGroupName, "Widgetbook golden tests");
    },
  );

  test("copyWith creates a new object with updated properties", () {
    final original = WidgetbookGoldenTestsProperties();
    final copied = original.copyWith(
      theme: ThemeData(primaryColor: Colors.blue),
      locale: Locale('fr', 'FR'),
      localizationsDelegates: const [],
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      skipTag: "[custom-skip]",
      errorImageUrl: "custom-error-image",
      loadingImageUrl: "custom-loading-image",
      testGroupName: "Custom golden tests",
    );

    expect(copied.theme, isNotNull);
    expect(copied.locale, isNotNull);
    expect(copied.localizationsDelegates, isNotNull);
    expect(copied.supportedLocales.length, 2);
    expect(copied.skipTag, "[custom-skip]");
    expect(copied.errorImageUrl, "custom-error-image");
    expect(copied.loadingImageUrl, "custom-loading-image");
    expect(copied.testGroupName, "Custom golden tests");
  });
}
