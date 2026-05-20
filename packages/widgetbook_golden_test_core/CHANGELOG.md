## Unreleased

### Added
- Added [precacheImagesTimeout] property to [WidgetbookGoldenTestsProperties] to configure the timeout for precaching images.
- Added [tags] property to [WidgetbookGoldenTestsProperties] to configure the tags for the golden tests. Also added a [tags] property to [WidgetbookGoldenTestBuilder] to configure the tags per use-case.
- [GoldenPlayAction] now has a [skip] property to configure the skip per golden play action instead of relying on the [skip] property of [WidgetbookGoldenTestBuilder].
- [GoldenPlayAction] now has a [customPump] property to execute a custom pump function after the action instead of hard-coded `pumpAndSettle()`.
- [WidgetbookGoldenTestBuilder] now has [pumpBeforeImagePrecache] and [pumpAfterImagePrecache] properties to configure custom pump functions before and after image precaching.
- Added `MockTestCacheManager` as a mock implementation of `BaseCacheManager` for testing widgets that use `CachedNetworkImage`. Configurable via `WidgetbookGoldenTestsProperties` to return success, error, or loading responses based on URL patterns.

### Fixed
- Use runZonedGuarded instead of simple try catch when trying to extract [WidgetbookGoldenTestBuilder] metadata. This solves an issue where no test were being executed when there was an error during the metadata extraction.
- Named first parameter of [onTestError] in [WidgetbookGoldenTestsProperties] to be `error` instead of being unnamed.

### Changed
- **Breaking Change**: Golden play actions no longer inherit the builder's skip flag by default, each action must set its own skip property if desired.

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