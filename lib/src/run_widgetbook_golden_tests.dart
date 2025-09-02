import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test/src/create_golden_test.dart';
import 'package:widgetbook_golden_test/src/widgetbook_golden_tests_properties.dart';

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
  group(properties.testGroupName, () {
    _traverse(nodes, goldenSnapshotsOutputPath, properties);
  });
}

/// Executes a recursive traversal of the [nodes] and calls [createGoldenTest]
/// when the node is a [WidgetbookUseCase].
void _traverse(
  List<WidgetbookNode> nodes,
  String path,
  WidgetbookGoldenTestsProperties properties,
) {
  for (var node in nodes) {
    if (node is WidgetbookUseCase) {
      createGoldenTest(node, path, properties);
    } else if (node.children != null) {
      group(node.name, () {
        _traverse(node.children!, "$path/${node.name}", properties);
      });
    }
  }
}
