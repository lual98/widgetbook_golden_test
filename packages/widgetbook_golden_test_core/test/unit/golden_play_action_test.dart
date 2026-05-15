import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook_golden_test_core/src/golden_play_action.dart';

void main() {
  group(GoldenPlayAction, () {
    test('initializes with required parameters', () async {
      const name = 'Tap Action';
      Future<void> callback(WidgetTester tester, CommonFinders find) async {}

      var action = GoldenPlayAction(name: name, callback: callback);

      expect(action.name, equals(name));
      expect(action.callback, equals(callback));
      expect(action.goldenFinder, isNull);
    });

    test('initializes with optional goldenFinder', () async {
      const name = 'Scroll Action';
      Future<void> callback(WidgetTester tester, CommonFinders find) async {}
      Finder goldenFinder(CommonFinders find) => find.text('Target');

      var action = GoldenPlayAction(
        name: name,
        callback: callback,
        goldenFinder: goldenFinder,
      );

      expect(action.name, equals(name));
      expect(action.callback, equals(callback));
      expect(action.goldenFinder, equals(goldenFinder));
    });

    test('defaults skip to false', () async {
      const name = 'Tap Action';
      Future<void> callback(WidgetTester tester, CommonFinders find) async {}

      var action = GoldenPlayAction(name: name, callback: callback);

      expect(action.skip, isFalse);
    });

    test('initializes with skip set to true', () async {
      const name = 'Skip Action';
      Future<void> callback(WidgetTester tester, CommonFinders find) async {}

      var action = GoldenPlayAction(name: name, callback: callback, skip: true);

      expect(action.skip, isTrue);
    });

    test('initializes with all parameters including skip', () async {
      const name = 'Complex Action';
      Future<void> callback(WidgetTester tester, CommonFinders find) async {}
      Finder goldenFinder(CommonFinders find) => find.text('Target');

      var action = GoldenPlayAction(
        name: name,
        callback: callback,
        goldenFinder: goldenFinder,
        skip: true,
      );

      expect(action.name, equals(name));
      expect(action.callback, equals(callback));
      expect(action.goldenFinder, equals(goldenFinder));
      expect(action.skip, isTrue);
    });
  });
}
