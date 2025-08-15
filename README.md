# golden_widgetbook_tests

Automatically generate Flutter golden tests from Widgetbook use cases that were generated using the [widgetbook_generator](https://pub.dev/packages/widgetbook_generator).

## Overview
This library automates the creation of golden tests for Flutter widgets using Widgetbook use cases auto-generated in the directories file, which is created using the `widgetbook_generator` package by running `dart run build_runner build -d`. The `runWidgetbookGoldenTests` function traverses these use cases to produce golden files for visual regression testing.

> **Note:** Only auto-generated directories files are supported. Manually editing or creating `*.directories.g.dart` is not intended or supported.

## Features
- **Automatic Golden Test Generation:** All Widgetbook use cases are discovered and tested.
- **Network Image Mocking:** Handles network images for reliable golden tests. You can simulate a network image loading error by using the special URL `"error-network-image"` in your use case. This will trigger the errorBuilder in your widget, allowing you to test error states. (Still work in progress with images with loading builders).
- **Easy Integration:** Just add your Widgetbook use cases and run the tests.
- **Skippable Cases:** Add `[skip-golden]` to a use case name to skip its golden test.
- **Custom Properties:** Customize properties with a custom `WidgetbookGoldenTestsProperties`.

## How It Works
- Widgetbook use cases are defined and auto-generated in the directories file.
- The directories file is generated using the `widgetbook_generator` package:
  ```bash
  dart run build_runner build -d
  ```
- The The `runWidgetbookGoldenTests` function traverses all use cases and generates golden files for each use case.
- Network images are mocked, based on how `mocktail_image_network` does it, for consistent results.
- To test error handling for network images, use the URL `error-network-image` in your `Image.network` widget. The test runner will mock this URL as a failed image load, so your `errorBuilder` will be triggered. This is useful for verifying error UI in golden tests.

## Customization
- To skip a golden test for a specific use case, add `[skip-golden]` to its name. You can customize this tag in `WidgetbookGoldenTestsProperties`.
- Update your Widgetbook use cases as needed; the test runner will pick them up automatically.

## Customizing the Test Runner
If your app uses a custom theme or localization, you can pass them to the `WidgetbookGoldenTestsProperties` to ensure golden snapshots reflect your actual UI:

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)
