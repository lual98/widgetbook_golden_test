# widgetbook_golden_test_alchemist
[![Pub](https://img.shields.io/pub/v/widgetbook_golden_test_alchemist.svg)](https://pub.dev/packages/widgetbook_golden_test_alchemist )
[![codecov](https://codecov.io/github/lual98/widgetbook_golden_test/graph/badge.svg?token=UK9N7GQJ7H)](https://app.codecov.io/github/lual98/widgetbook_golden_test/tree/main/packages%2Fwidgetbook_golden_test_alchemist%2Flib%2Fsrc)


Automatically generate Flutter golden tests from Widgetbook use cases using [Alchemist](https://pub.dev/packages/alchemist).

## Overview

This library provides an [Alchemist](https://pub.dev/packages/alchemist) adapter for automating the creation of golden tests for Flutter widgets using Widgetbook use cases. It leverages the generated directory files from `widgetbook_generator` to discover use cases and render them into golden images using Alchemist's powerful rendering engine.

It is built upon `widgetbook_golden_test_core`, which provides the underlying engine for discovery and mocking dependencies.

## Usage

1. **Generate** your Widgetbook directories using `widgetbook_generator`:
```sh
dart run build_runner build -d
```

2. **Import** the directories file generated.
3. **Call** `runAlchemistWidgetbookGoldenTests` inside the `main` function of a test file.

```dart
import 'package:widgetbook_golden_test_alchemist/widgetbook_golden_test_alchemist.dart';
import '../widgetbook/main.directories.g.dart';

void main() {
  runAlchemistWidgetbookGoldenTests(
    nodes: directories,
    properties: WidgetbookGoldenTestsProperties(),
  );
}
```

4. **Generate** the golden files by running:
```sh
flutter test <path-to-test-file> --update-goldens
```

## Features

- **Alchemist Integration:** Leverages Alchemist for rendering, providing a robust and reliable golden testing experience.
- **Automatic Discovery:** All Widgetbook use cases are automatically discovered and tested.
- **Network Image Mocking:** Handles network images for reliable tests. You can simulate loading and error states using `WidgetbookGoldenTestsProperties`.
- **Knob Support:** Supports Widgetbook knobs by mocking the internal state.
- **Customization:** Customize properties at the group level via `WidgetbookGoldenTestsProperties` or per use-case using `WidgetbookGoldenTestBuilder`.
- **Play Actions:** Use `GoldenPlayAction` within `WidgetbookGoldenTestBuilder` to capture snapshots after interactions (e.g., scrolling, tapping).
- **Widgetbook Addons:** Apply and merge Widgetbook addons to test different themes, locales, and text scales.

## How It Works

1. **Discovery:** Use cases are defined and auto-generated in the directories file by `widgetbook_generator`.
2. **Traversal:** The `runAlchemistWidgetbookGoldenTests` function traverses the provided Widgetbook nodes.
3. **Mocking:** It sets up a mocked environment using `goldenTestZoneRunner`, which includes a mocked `HttpClient` for network images.
4. **Execution:** Each use case is pumped into a `MockedWidgetbookCase` which provides the necessary `WidgetbookScope` and theme context.
5. **Verification:** The `WidgetbookGoldenAlchemistRenderer` uses Alchemist's `goldenTest` to perform the visual comparison.

## License

[MIT](LICENSE)
