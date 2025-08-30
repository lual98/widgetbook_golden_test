import 'package:flutter/widgets.dart';
import 'package:widgetbook_golden_test/src/golden_play_action.dart';

class WidgetbookGoldenTestBuilder extends StatelessWidget {
  final Widget child;
  final List<GoldenPlayAction>? goldenActions;

  const WidgetbookGoldenTestBuilder({
    super.key,
    required this.child,
    this.goldenActions,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
