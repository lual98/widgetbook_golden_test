import 'package:example/widgetbook.directories.g.dart';
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';

// Main example with minimum customization.
void main() {
  runWidgetbookGoldenTests(
    nodes: directories,
    properties: WidgetbookGoldenTestsProperties(),
  );
}
