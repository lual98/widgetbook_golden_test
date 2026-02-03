## 0.4.0
Initial release.

### Added
- Provide the WidgetbookGoldenRenderer interface to allow customizing the golden test rendering.

The following files have been moved from widgetbook_golden_test to widgetbook_golden_test_core:
- golden_play_zone.dart
- widget_tester_extension.dart
- widgetbook_golden_test_builder.dart
- widgetbook_golden_tests_properties.dart
- ignore_network_image_exception.dart
- test_http_overrides.dart

The following files are new but contain parts of the previous widgetbook_golden_test:
- widgetbook_golden_test_generator.dart
- widgetbook_golden_test_renderer.dart
- mocked_widgetbook_case.dart
- merge_addons.dart