import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/src/merge_addons.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

void main() {
  group("mergeAddons", () {
    test("should merge addons with replaceAndInsertAtEnd strategy", () {
      final propertyThemeAddon = MaterialThemeAddon(
        themes: [WidgetbookTheme(name: "property", data: ThemeData())],
      );
      final builderThemeAddon = MaterialThemeAddon(
        themes: [WidgetbookTheme(name: "builder", data: ThemeData())],
      );
      final gridAddon = GridAddon();
      final textScaleAddon = TextScaleAddon();
      final viewportAddon = ViewportAddon([]);
      final List<WidgetbookAddon> propertiesAddons = [
        viewportAddon,
        propertyThemeAddon,
      ];
      final List<WidgetbookAddon> builderAddons = [
        textScaleAddon,
        builderThemeAddon,
        gridAddon,
      ];
      final result = mergeAddons(
        propertiesAddons,
        builderAddons,
        AddonsMergeStrategy.replaceAndInsertAtEnd,
      );
      expect(result, [
        viewportAddon,
        builderThemeAddon,
        textScaleAddon,
        gridAddon,
      ]);
    });

    test("should merge addons with replaceAndInsertAtBeginning strategy", () {
      final propertyThemeAddon = MaterialThemeAddon(
        themes: [WidgetbookTheme(name: "property", data: ThemeData())],
      );
      final builderThemeAddon = MaterialThemeAddon(
        themes: [WidgetbookTheme(name: "builder", data: ThemeData())],
      );
      final gridAddon = GridAddon();
      final textScaleAddon = TextScaleAddon();
      final viewportAddon = ViewportAddon([]);
      final List<WidgetbookAddon> propertiesAddons = [
        viewportAddon,
        propertyThemeAddon,
      ];
      final List<WidgetbookAddon> builderAddons = [
        textScaleAddon,
        builderThemeAddon,
        gridAddon,
      ];
      final result = mergeAddons(
        propertiesAddons,
        builderAddons,
        AddonsMergeStrategy.replaceAndInsertAtBeginning,
      );
      expect(result, [
        textScaleAddon,
        gridAddon,
        viewportAddon,
        builderThemeAddon,
      ]);
    });

    test("should merge addons with overrideAll strategy", () {
      final propertyThemeAddon = MaterialThemeAddon(
        themes: [WidgetbookTheme(name: "property", data: ThemeData())],
      );
      final builderThemeAddon = MaterialThemeAddon(
        themes: [WidgetbookTheme(name: "builder", data: ThemeData())],
      );
      final gridAddon = GridAddon();
      final textScaleAddon = TextScaleAddon();
      final viewportAddon = ViewportAddon([]);
      final List<WidgetbookAddon> propertiesAddons = [
        viewportAddon,
        propertyThemeAddon,
      ];
      final List<WidgetbookAddon> builderAddons = [
        textScaleAddon,
        builderThemeAddon,
        gridAddon,
      ];
      final result = mergeAddons(
        propertiesAddons,
        builderAddons,
        AddonsMergeStrategy.overrideAll,
      );
      expect(result, [textScaleAddon, builderThemeAddon, gridAddon]);
    });
  });
}
