import 'package:flutter_test/flutter_test.dart';

typedef WidgetPlayCallback =
    Future<void> Function(WidgetTester tester, CommonFinders find);

typedef WidgetFinderCallback = Finder Function(CommonFinders find);

class GoldenPlayAction {
  final String name;
  final WidgetPlayCallback callback;
  final WidgetFinderCallback? targetFinder;

  const GoldenPlayAction({
    required this.name,
    required this.callback,
    this.targetFinder,
  });
}
