import 'package:alchemist/alchemist.dart';
import 'package:widgetbook_golden_test_alchemist/widgetbook_golden_test_alchemist.dart';
import 'package:widgetbook_samples/main.directories.g.dart';

void main() {
  const isRunningInCi = bool.fromEnvironment('CI', defaultValue: false);
  AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(enabled: !isRunningInCi),
    ),
    run: () {
      runAlchemistWidgetbookGoldenTests(
        nodes: directories,
        properties: WidgetbookGoldenTestsProperties(),
      );
    },
  );
}
