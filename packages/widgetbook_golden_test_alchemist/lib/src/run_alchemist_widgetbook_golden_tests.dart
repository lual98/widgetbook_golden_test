import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_alchemist/src/widgetbook_golden_flutter_test_renderer.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

/// Recursively generates golden tests for all [WidgetbookUseCase]s
/// inside the provided [nodes] using Alchemist.
///
/// Use this function in your test files to automate visual regression testing
/// based on your Widgetbook configuration.
///
/// [nodes] - The list of Widgetbook nodes (directories) to traverse.
/// [properties] - Configuration properties for the golden tests.
/// [goldenSnapshotsOutputPath] - The directory where golden snapshots will be saved.
///
/// Example:
/// ```dart
/// runAlchemistWidgetbookGoldenTests(
///   nodes: directories,
///   properties: WidgetbookGoldenTestsProperties(),
/// );
/// ```
void runAlchemistWidgetbookGoldenTests({
  required List<WidgetbookNode> nodes,
  required WidgetbookGoldenTestsProperties properties,
  String goldenSnapshotsOutputPath = ".",
}) {
  final generator = WidgetbookGoldenTestGenerator(
    properties: properties,
    renderer: WidgetbookGoldenAlchemistRenderer(),
  );

  generator.generate(
    nodes: nodes,
    goldenSnapshotsOutputPath: goldenSnapshotsOutputPath,
  );
}
