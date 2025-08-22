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
}
