## Unreleased
- Updated to widgetbook_golden_test_core to 0.5.0. Check the [../../packages/widgetbook_golden_test_core/CHANGELOG.md](../../packages/widgetbook_golden_test_core/CHANGELOG.md) file for more information.

### Added
- Added `precacheImagesTimeout` property to `WidgetbookGoldenTestsProperties` to configure the timeout for precaching images.
- Added `tags` property to `WidgetbookGoldenTestsProperties` to configure the tags for the golden tests. Also added a `tags` property to `WidgetbookGoldenTestBuilder` to configure the tags per use-case.
- `GoldenPlayAction` now has a `skip` property to configure the skip per golden play action instead of relying on the `skip` property of `WidgetbookGoldenTestBuilder`.
- `GoldenPlayAction` now has a `customPump` property to execute a custom pump function after the action instead of hard-coded `pumpAndSettle()`.
- `WidgetbookGoldenTestBuilder` now has `pumpBeforeImagePrecache` and `pumpAfterImagePrecache` properties to configure custom pump functions before and after image precaching.
- Added `MockTestCacheManager` as a mock implementation of `BaseCacheManager` for testing widgets that use `CachedNetworkImage`. Configurable via `WidgetbookGoldenTestsProperties` to return success, error, or loading responses based on URL patterns.
- Added `ignorePendingTimers` to `WidgetbookGoldenTestBuilder` to ignore pending timers during golden test execution.

### Changed
- **Breaking Change**: Golden play actions no longer inherit the builder's skip flag by default, each action must set its own skip property if desired.

## 0.4.0
- Initial release.
- Automatically generate Flutter golden tests from Widgetbook use cases using [Alchemist](https://pub.dev/packages/alchemist).
- Support all features of `widgetbook_golden_test` except `WidgetFinderCallback` of `WidgetbookGoldenTestBuilder`.
