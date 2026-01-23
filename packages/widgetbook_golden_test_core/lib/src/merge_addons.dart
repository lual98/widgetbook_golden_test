import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

List<WidgetbookAddon>? mergeAddons(
  List<WidgetbookAddon>? propertiesAddons,
  List<WidgetbookAddon>? builderAddons,
  AddonsMergeStrategy addonsMergeStrategy,
) {
  if (builderAddons == null) {
    return propertiesAddons;
  }

  if (addonsMergeStrategy == AddonsMergeStrategy.overrideAll) {
    return builderAddons;
  }

  final List<WidgetbookAddon> newAddons = [];
  final Map<Type, WidgetbookAddon> builderAddonsMap = {};
  for (var addon in builderAddons) {
    builderAddonsMap[addon.runtimeType] = addon;
  }
  if (propertiesAddons != null) {
    for (var addon in propertiesAddons) {
      if (builderAddonsMap.containsKey(addon.runtimeType)) {
        newAddons.add(builderAddonsMap[addon.runtimeType]!);
        builderAddonsMap.remove(addon.runtimeType);
      } else {
        newAddons.add(addon);
      }
    }
  }
  if (addonsMergeStrategy == AddonsMergeStrategy.replaceAndInsertAtEnd) {
    newAddons.addAll(builderAddonsMap.values);
  }

  if (addonsMergeStrategy == AddonsMergeStrategy.replaceAndInsertAtBeginning) {
    return [...builderAddonsMap.values, ...newAddons];
  }

  return newAddons;
}
