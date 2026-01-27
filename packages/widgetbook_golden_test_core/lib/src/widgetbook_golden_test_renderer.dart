import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

/// An interface for rendering golden tests.
///
/// Implementations of this interface define how to execute and verify
/// golden tests for Widgetbook use cases.
abstract class WidgetbookGoldenRenderer {
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
