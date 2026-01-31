import 'package:alchemist/alchemist.dart';
import 'package:widgetbook_golden_test_alchemist/widgetbook_golden_test_alchemist.dart';
import 'package:widgetbook_samples/main.directories.g.dart';

void main() {
  const isRunningInCi = bool.fromEnvironment(
    'CI',
    defaultValue: true,
  ); // We will default this to true for now because it has inconsistent behavior if it runs on all platforms
  // TODO: Investigate further if this issue is related to widgetbook_golden_test or alchemist
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
