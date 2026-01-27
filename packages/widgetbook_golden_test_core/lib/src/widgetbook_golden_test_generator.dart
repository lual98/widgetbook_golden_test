import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

class _BuildContextMock extends Mock implements BuildContext {}

/// A generator that traverses [WidgetbookNode]s to create golden tests.
class WidgetbookGoldenTestGenerator {
  /// Creates a [WidgetbookGoldenTestGenerator].
  WidgetbookGoldenTestGenerator({
    required this.properties,
    required this.renderer,
  });

  /// The properties used to configure the golden tests.
  final WidgetbookGoldenTestsProperties properties;

  /// The renderer used to execute the golden tests.
  final WidgetbookGoldenRenderer renderer;

  /// Recursively generates golden tests for all [WidgetbookUseCase]s
  /// inside the provided [nodes].
  ///
  /// Example:
  /// ```dart
  /// generate(nodes: directories);
  /// ```
  void generate({
    required List<WidgetbookNode> nodes,
    String goldenSnapshotsOutputPath = ".",
  }) {
    group(properties.testGroupName, () {
      _traverse(nodes, goldenSnapshotsOutputPath);
    });
  }

  /// Executes a recursive traversal of the [nodes] and calls [createGoldenTest]
  /// when the node is a [WidgetbookUseCase].
  void _traverse(List<WidgetbookNode> nodes, String path) {
    for (var node in nodes) {
      if (node is WidgetbookUseCase) {
        createGoldenTests(
          useCase: node,
          goldenPath: path,
          properties: properties,
        );
      } else if (node.children != null) {
        group(node.name, () {
          _traverse(node.children!, "$path/${node.name}");
        });
      }
    }
  }

  /// Creates golden tests for a single [WidgetbookUseCase].
  ///
  /// This method identifies if the [useCase] is wrapped in a [WidgetbookGoldenTestBuilder]
  /// and triggers both simple and play action golden tests based on the builder's configuration.
  void createGoldenTests({
    required WidgetbookUseCase useCase,
    required String goldenPath,
    required WidgetbookGoldenTestsProperties properties,
  }) {
    WidgetbookGoldenTestBuilder? goldenTestBuilder;
    final mockContext = _BuildContextMock();
    try {
      final widget = useCase.build(mockContext);
      if (widget is WidgetbookGoldenTestBuilder) {
        goldenTestBuilder = widget;
      }
    } catch (e) {
      // Not a WidgetbookGoldenTestBuilder.
    }

    // Skip the golden test case if it contains the [skip-golden] tag just as a fallback.
    bool shouldSkip =
        (goldenTestBuilder?.skip ?? false) ||
        // ignore: deprecated_member_use_from_same_package
        useCase.name.contains(properties.skipTag);

    // Golden test case of the story.
    renderer.renderSimpleGoldenTest(
      goldenPath: goldenPath,
      properties: properties,
      useCase: useCase,
      skip: shouldSkip,
      goldenTestBuilder: goldenTestBuilder,
    );

    if (goldenTestBuilder?.goldenActions != null) {
      for (final play in goldenTestBuilder!.goldenActions!) {
        renderer.renderGoldenPlayActionTest(
          goldenPath: goldenPath,
          properties: properties,
          useCase: useCase,
          action: play,
          skip: shouldSkip,
          goldenTestBuilder: goldenTestBuilder,
        );
      }
    }
  }
}
