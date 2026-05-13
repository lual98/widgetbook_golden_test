import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

void main() {
  group(WidgetbookGoldenTestBuilder, () {
    testWidgets('renders from builder', (tester) async {
      const key = Key('builder-child');
      await tester.pumpWidget(
        WidgetbookGoldenTestBuilder(
          builder: (context) => const SizedBox(key: key),
        ),
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('renders from child (deprecated)', (tester) async {
      const key = Key('child');
      await tester.pumpWidget(
        // ignore: deprecated_member_use_from_same_package
        WidgetbookGoldenTestBuilder(child: const SizedBox(key: key)),
      );

      expect(find.byKey(key), findsOneWidget);
    });

    test('throws assertion error if both builder and child are null', () {
      expect(
        () => WidgetbookGoldenTestBuilder(
          builder: null,
          // ignore: deprecated_member_use_from_same_package
          child: null,
        ),
        throwsAssertionError,
      );
    });

    test('stores properties correctly', () {
      final addons = <WidgetbookAddon>[];
      final actions = <GoldenPlayAction>[];
      const strategy = AddonsMergeStrategy.overrideAll;

      var builder = WidgetbookGoldenTestBuilder(
        addons: addons,
        addonsMergeStrategy: strategy,
        goldenActions: actions,
        skip: true,
        tags: ['custom-tag'],
        builder: _dummyBuilder,
      );

      expect(builder.addons, equals(addons));
      expect(builder.addonsMergeStrategy, equals(strategy));
      expect(builder.goldenActions, equals(actions));
      expect(builder.skip, isTrue);
      expect(builder.tags, equals(['custom-tag']));
    });

    test('tags defaults to null', () {
      final builder = WidgetbookGoldenTestBuilder(builder: _dummyBuilder);

      expect(builder.tags, isNull);
    });

    test('can be created with custom tags list', () {
      final builder = WidgetbookGoldenTestBuilder(
        tags: ['smoke', 'ci', 'golden'],
        builder: _dummyBuilder,
      );

      expect(builder.tags, equals(['smoke', 'ci', 'golden']));
    });

    test('can be created with empty tags list', () {
      final builder = WidgetbookGoldenTestBuilder(
        tags: [],
        builder: _dummyBuilder,
      );

      expect(builder.tags, isEmpty);
    });
  });
}

Widget _dummyBuilder(BuildContext context) => const SizedBox();
