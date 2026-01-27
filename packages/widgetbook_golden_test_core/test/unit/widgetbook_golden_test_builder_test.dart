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
        builder: _dummyBuilder,
      );

      expect(builder.addons, equals(addons));
      expect(builder.addonsMergeStrategy, equals(strategy));
      expect(builder.goldenActions, equals(actions));
      expect(builder.skip, isTrue);
    });
  });
}

Widget _dummyBuilder(BuildContext context) => const SizedBox();
