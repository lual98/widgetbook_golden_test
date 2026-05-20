import 'package:widgetbook_golden_test_alchemist/widgetbook_golden_test_alchemist.dart';
import 'package:widgetbook_samples/main.directories.g.dart';

/// Main example with minimum customization.
/// Check out the use cases declared in the cases folder to see some common scenarios that are supported.
/// Check the test folder for more examples.
void main() {
  runAlchemistWidgetbookGoldenTests(
    nodes: directories,
    properties: WidgetbookGoldenTestsProperties(),
  );
}
