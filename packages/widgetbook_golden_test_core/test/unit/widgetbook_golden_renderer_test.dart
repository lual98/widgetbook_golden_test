import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

void main() {
  group(WidgetbookGoldenRenderer.resolveTags, () {
    test('returns properties.tags when goldenTestBuilder is null', () {
      final properties = WidgetbookGoldenTestsProperties(
        tags: ['custom-tag', 'another-tag'],
      );

      final result = WidgetbookGoldenRenderer.resolveTags(
        goldenTestBuilder: null,
        properties: properties,
      );

      expect(result, equals(['custom-tag', 'another-tag']));
    });

    test(
      'returns default tags when properties has no custom tags and builder is null',
      () {
        final properties = WidgetbookGoldenTestsProperties();

        final result = WidgetbookGoldenRenderer.resolveTags(
          goldenTestBuilder: null,
          properties: properties,
        );

        expect(result, equals(['golden']));
      },
    );

    test('returns builder.tags when provided (overrides properties)', () {
      final properties = WidgetbookGoldenTestsProperties(
        tags: ['properties-tag'],
      );
      final builder = WidgetbookGoldenTestBuilder(
        tags: ['builder-tag-1', 'builder-tag-2'],
        builder: (_) => const SizedBox(),
      );

      final result = WidgetbookGoldenRenderer.resolveTags(
        goldenTestBuilder: builder,
        properties: properties,
      );

      expect(result, equals(['builder-tag-1', 'builder-tag-2']));
    });

    test(
      'returns empty list when builder has empty tags (explicit override)',
      () {
        final properties = WidgetbookGoldenTestsProperties(
          tags: ['properties-tag'],
        );
        final builder = WidgetbookGoldenTestBuilder(
          tags: [],
          builder: (_) => const SizedBox(),
        );

        final result = WidgetbookGoldenRenderer.resolveTags(
          goldenTestBuilder: builder,
          properties: properties,
        );

        expect(result, isEmpty);
      },
    );

    test('returns single tag when builder has a single tag', () {
      final properties = WidgetbookGoldenTestsProperties(
        tags: ['properties-tag-1', 'properties-tag-2'],
      );
      final builder = WidgetbookGoldenTestBuilder(
        tags: ['single-builder-tag'],
        builder: (_) => const SizedBox(),
      );

      final result = WidgetbookGoldenRenderer.resolveTags(
        goldenTestBuilder: builder,
        properties: properties,
      );

      expect(result, equals(['single-builder-tag']));
    });
  });
}
