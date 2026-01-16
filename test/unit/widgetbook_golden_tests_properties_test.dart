import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';

void main() {
  test("it's created with default properties", () {
    final defaultProperties = WidgetbookGoldenTestsProperties();

    expect(defaultProperties.theme, null);
    // ignore: deprecated_member_use_from_same_package
    expect(defaultProperties.locale, null);
    // ignore: deprecated_member_use_from_same_package
    expect(defaultProperties.localizationsDelegates, null);
    // ignore: deprecated_member_use_from_same_package
    expect(defaultProperties.supportedLocales, const [Locale('en', 'US')]);
    // ignore: deprecated_member_use_from_same_package
    expect(defaultProperties.skipTag, "[skip-golden]");
    expect(defaultProperties.errorImageUrl, "error-network-image");
    expect(defaultProperties.loadingImageUrl, "loading-network-image");
    expect(defaultProperties.testGroupName, "Widgetbook golden tests");
  });

  test("it's created with custom properties", () {
    final customProperties = WidgetbookGoldenTestsProperties(
      theme: ThemeData(primaryColor: Colors.blue),
      // ignore: deprecated_member_use_from_same_package
      locale: Locale('fr', 'FR'),
      // ignore: deprecated_member_use_from_same_package
      localizationsDelegates: const [],
      // ignore: deprecated_member_use_from_same_package
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      // ignore: deprecated_member_use_from_same_package
      skipTag: "[custom-skip]",
      errorImageUrl: "custom-error-image",
      loadingImageUrl: "custom-loading-image",
      testGroupName: "Custom golden tests",
    );

    expect(customProperties.theme, isNotNull);
    // ignore: deprecated_member_use_from_same_package
    expect(customProperties.locale, isNotNull);
    // ignore: deprecated_member_use_from_same_package
    expect(customProperties.localizationsDelegates, isNotNull);
    // ignore: deprecated_member_use_from_same_package
    expect(customProperties.supportedLocales.length, 2);
    // ignore: deprecated_member_use_from_same_package
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
      // ignore: deprecated_member_use_from_same_package
      expect(copied.locale, isNull);
      // ignore: deprecated_member_use_from_same_package
      expect(copied.localizationsDelegates, isNull);
      // ignore: deprecated_member_use_from_same_package
      expect(copied.supportedLocales, const [Locale('en', 'US')]);
      // ignore: deprecated_member_use_from_same_package
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
    // ignore: deprecated_member_use_from_same_package
    expect(copied.locale, isNotNull);
    // ignore: deprecated_member_use_from_same_package
    expect(copied.localizationsDelegates, isNotNull);
    // ignore: deprecated_member_use_from_same_package
    expect(copied.supportedLocales.length, 2);
    // ignore: deprecated_member_use_from_same_package
    expect(copied.skipTag, "[custom-skip]");
    expect(copied.errorImageUrl, "custom-error-image");
    expect(copied.loadingImageUrl, "custom-loading-image");
    expect(copied.testGroupName, "Custom golden tests");
  });
}
