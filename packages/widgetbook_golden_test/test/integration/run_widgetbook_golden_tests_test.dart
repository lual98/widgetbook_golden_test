import 'package:widgetbook_golden_test/src/run_widgetbook_golden_tests.dart';
import 'package:widgetbook_golden_test_core/src/widgetbook_golden_tests_properties.dart';
import 'package:widgetbook_samples/main.directories.g.dart';

void main() {
  runWidgetbookGoldenTests(
    nodes: directories,
    properties: WidgetbookGoldenTestsProperties(),
  );
}
