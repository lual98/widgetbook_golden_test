import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';
import 'package:widgetbook_samples/main.directories.g.dart';

/// Main example with minimum customization.
/// Check out the use cases declared in the cases folder to see some common scenarios that are supported.
void main() {
  runWidgetbookGoldenTests(
    nodes: directories,
    properties: WidgetbookGoldenTestsProperties(),
  );
}
