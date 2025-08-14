import 'package:widgetbook_golden_test/run_widgetbook_golden_tests.dart';
import 'package:widgetbook_golden_test/widgetbook_golden_tests_properties.dart';

import '../widgetbook/main.directories.g.dart';

void main() {
  runWidgetbookGoldenTests(
    nodes: directories,
    properties: WidgetbookGoldenTestsProperties(),
  );
}
