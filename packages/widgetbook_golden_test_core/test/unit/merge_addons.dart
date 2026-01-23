import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/src/merge_addons.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

void main() {
  group(mergeAddons, () {
    test("should merge addons with replaceAndInsertAtEnd strategy", () {
      final propertyThemeAddon = MaterialThemeAddon(
        themes: [WidgetbookTheme(name: "property", data: ThemeData())],
      );
      final builderThemeAddon = MaterialThemeAddon(
        themes: [WidgetbookTheme(name: "builder", data: ThemeData())],
      );
      final gridAddon = GridAddon();
      final textScaleAddon = TextScaleAddon();
      final List<WidgetbookAddon> propertiesAddons = [propertyThemeAddon];
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
      expect(result, hasLength(3));
      expect(result, isNot(contains(propertyThemeAddon)));
      expect(result, contains(builderThemeAddon));
      expect(result?[1], textScaleAddon);
      expect(result?[2], gridAddon);
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
      final List<WidgetbookAddon> propertiesAddons = [propertyThemeAddon];
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
      expect(result, hasLength(3));
      expect(result, isNot(contains(propertyThemeAddon)));
      expect(result, contains(builderThemeAddon));
      expect(result?[0], textScaleAddon);
      expect(result?[1], gridAddon);
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
      final List<WidgetbookAddon> propertiesAddons = [propertyThemeAddon];
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
      expect(result, hasLength(3));
      expect(result, [textScaleAddon, builderThemeAddon, gridAddon]);
    });
  });
}
