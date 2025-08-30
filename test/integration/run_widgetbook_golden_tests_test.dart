import 'package:widgetbook_cases/main.directories.g.dart';
import 'package:widgetbook_golden_test/src/run_widgetbook_golden_tests.dart';
import 'package:widgetbook_golden_test/src/widgetbook_golden_tests_properties.dart';

void main() {
  runWidgetbookGoldenTests(
    nodes: directories,
    properties: WidgetbookGoldenTestsProperties(),
  );
}
