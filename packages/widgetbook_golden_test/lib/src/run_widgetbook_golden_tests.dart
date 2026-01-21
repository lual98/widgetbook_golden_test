import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test/src/create_golden_test.dart';
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
  var finalProperties = properties.copyWith(
    networkImageResolver:
        properties.networkImageResolver ?? _defaultImageResolver,
  );
  group(properties.testGroupName, () {
    _traverse(nodes, goldenSnapshotsOutputPath, finalProperties);
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

NetworkImageResolver _defaultImageResolver = (uri) {
  final extension = uri.path.split('.').last;
  return _mockedResponses[extension] ?? _transparentPixelPng;
};

final _mockedResponses = <String, List<int>>{
  'png': _transparentPixelPng,
  'svg': _emptySvg,
};

final _emptySvg = '<svg viewBox="0 0 10 10" />'.codeUnits;
final _transparentPixelPng = base64Decode(
  '''iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==''',
);
