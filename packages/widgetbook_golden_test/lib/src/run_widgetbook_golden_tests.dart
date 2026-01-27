import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test/src/widgetbook_golden_flutter_test_renderer.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

/// Recursively generates golden tests for all [WidgetbookUseCase]s
/// inside the provided [nodes].
///
/// Example:
/// ```dart
/// runWidgetbookGoldenTests(nodes: directories, properties: WidgetbookGoldenTestsProperties());
/// ```
void runWidgetbookGoldenTests({
  required List<WidgetbookNode> nodes,
  required WidgetbookGoldenTestsProperties properties,
  String goldenSnapshotsOutputPath = ".",
}) {
  final generator = WidgetbookGoldenTestGenerator(
    properties: properties,
    renderer: WidgetbookGoldenFlutterTestRenderer(),
  );

  generator.generate(
    nodes: nodes,
    goldenSnapshotsOutputPath: goldenSnapshotsOutputPath,
  );
}
