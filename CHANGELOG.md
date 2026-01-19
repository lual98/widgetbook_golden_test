## Unreleased
### Added
- Parameter based skip in WidgetbookGoldenTestBuilder.
  * This will deprecate the `skipTag` property in WidgetbookGoldenTestsProperties.
- Handle golden tests with interaction as separate test cases.
- `addons` and `addonsMergeStrategy` in `WidgetbookGoldenTestBuilder` to allow overrides of Widgetbook Addons per test case.

- **IMPORTANT**: Use `builder` instead of `child` in `WidgetbookGoldenTestBuilder` to ensure that the information by the builder is obtained correctly. It is recommended to add all the logic of the case in the `builder` function.

### Fixed
- Theme extensions not properly loading. (thanks @Gustl22)
- Golden test run indefinitely when the expected image is not found.

### Deprecated
- Deprecate `locale`, `localizationsDelegates` and `supportedLocales` properties in WidgetbookGoldenTestsProperties.
  * These properties will be handled by the `LocalizationAddon`.

## 0.2.1 - 2025-09-15
- No actual changes in the library. Just a small fix to properly show example.md in the pub.dev Example tab.

## 0.2.0 - 2025-09-15
### Added
- Constant values for `'[skip-golden]'`, `'error-network-image'`, `'loading-network-image'` so they are easier to access and use.
- Custom `networkImageResolver` in WidgetbookGoldenTestsProperties that allows to show custom images for mocked network images depending on the URL.
- `copyWith` method in WidgetbookGoldenTestsProperties;

### Fixed
- Network SVG images not being properly handled during the image mocking.

## 0.1.0 - 2025-09-03
### Added
- New `WidgetbookGoldenTestBuilder` which provides additional functionality to the golden tests generated.
  * This builder has an option to provide play functions through the `goldenActions` property. Additional snapshots will be generated after the execution of each play function provided.
  * In the future, this builder may include other new features.
- New property in `WidgetbookGoldenTestsProperties` called `addons` which allows the developer to apply Widgetbook Addons to the generated snapshots. (thanks @Gustl22)
- New property in `WidgetbookGoldenTestsProperties` called `onTestError` which allows the developer to set a custom error handler that will be executed when there is an exception, allowing to ignore these errors or add additional logging.

### Fixed
- Caching images should no longer run for ever when they can't be cached. It will time out after 10 seconds.

## 0.0.3
### Fixed
- Fix property supportedLocales in WidgetbookGoldenTestsProperties not being when running the test cases.

### Others
- Improve documentation (both Readme and dart docs).

## 0.0.2
- Bump minimal widgetbook version required.

## 0.0.1
* Initial release
  - Support running all test cases in the auto generated widgetbook file as golden tests.
  - Basic handling of Image.Network.
  - Basic configuration of app theming, skip tag and custom image urls for different network states.
