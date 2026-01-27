import 'package:flutter_test/flutter_test.dart' show expect, test;
import 'package:widgetbook_golden_test_core/src/helpers/ignore_network_image_exception.dart';

void main() {
  test("toString() returns custom message", () {
    final exception = IgnoreNetworkImageException();
    var message = exception.toString();
    expect(message, "Ignore network image exception");
  });
}
