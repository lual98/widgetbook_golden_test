import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

/// An interface for rendering golden tests.
///
/// Implementations of this interface define how to execute and verify
/// golden tests for Widgetbook use cases.
abstract class WidgetbookGoldenRenderer {
  /// Resolves the tags for a golden test.
  ///
  /// If [goldenTestBuilder] provides tags (even an empty list), those are used.
  /// Otherwise, falls back to [properties.tags].
  static List<String> resolveTags({
    required WidgetbookGoldenTestBuilder? goldenTestBuilder,
    required WidgetbookGoldenTestsProperties properties,
  }) {
    return goldenTestBuilder?.tags ?? properties.tags;
  }

  /// Renders a simple golden test for a [useCase].
  void renderSimpleGoldenTest({
    required WidgetbookUseCase useCase,
    required String goldenPath,
    required WidgetbookGoldenTestsProperties properties,
    required bool skip,
    required WidgetbookGoldenTestBuilder? goldenTestBuilder,
  });

  /// Renders a golden test for a specific [GoldenPlayAction].
  void renderGoldenPlayActionTest({
    required WidgetbookUseCase useCase,
    required String goldenPath,
    required WidgetbookGoldenTestsProperties properties,
    required GoldenPlayAction action,
    required bool skip,
    required WidgetbookGoldenTestBuilder? goldenTestBuilder,
  });
}
