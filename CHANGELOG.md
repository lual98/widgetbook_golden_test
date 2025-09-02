## Unreleased
- Add new `WidgetbookGoldenTestBuilder` which provides additional functionality to the golden tests generated.
  * This builder has an option to provide play functions through the `goldenActions` property. Additional snapshots will be generated after the execution of each play function provided.
  * In the future, this builder may include other new features.
- A new property in `WidgetbookGoldenTestsProperties` called `addons` has been added which allows the developer to apply Widgetbook Addons to the generated snapshots. (thanks @Gustl22)
- A new property in `WidgetbookGoldenTestsProperties` called `onTestError` has been added which allows the developer to set a custom error handler that will be executed when there is an exception, allowing to ignore these errors or add additional logging.
- Caching images should no longer run for ever when they can't be cached. It will time out after 10 seconds.

## 0.0.3
- Fix property supportedLocales in WidgetbookGoldenTestsProperties not being when running the test cases.
- Improve documentation (both Readme and dart docs).

## 0.0.2
- Bump minimal widgetbook version required.

## 0.0.1
* Initial release
  - Support running all test cases in the auto generated widgetbook file as golden tests.
  - Basic handling of Image.Network.
  - Basic configuration of app theming, skip tag and custom image urls for different network states.
