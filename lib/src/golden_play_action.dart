import 'package:flutter_test/flutter_test.dart';

typedef WidgetPlayCallback = Future<void> Function(WidgetTester tester);

class GoldenPlayAction {
  final String name;
  final WidgetPlayCallback callback;

  const GoldenPlayAction({required this.name, required this.callback});
}
