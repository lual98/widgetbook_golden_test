# widgetbook_golden_test_core

Core engine for generating Flutter golden tests from Widgetbook use cases.

## Overview

This package provides the fundamental building blocks for automating golden tests in Flutter projects that use Widgetbook. It is designed to be used as a dependency for higher-level packages like `widgetbook_golden_test`, but can also be used directly if you need a custom test runner.

## Key Components

### `WidgetbookGoldenTestGenerator`
The engine that traverses Widgetbook directory nodes and identifies use cases to be tested.

### `MockedWidgetbookCase`
A wrapper widget that provides a mocked environment for use cases, including:
- `WidgetbookScope` with mocked state (knobs, query params).
- `MaterialApp` with theme, locale, and localization support.
- `MultiAddonBuilder` to apply and merge Widgetbook addons.

### `WidgetbookGoldenTestsProperties`
A configuration class to define global settings for golden tests, such as:
- Default addons.
- Global theme and localization delegates.
- Custom network image resolution.
- Error handling strategies.

### `WidgetbookGoldenTestBuilder`
A widget used in Widgetbook use cases to provide per-case configuration:
- `skip`: Flag to skip golden test generation.
- `addons`: Per-case addon overrides.
- `goldenActions`: A sequence of interactions and snapshots.

### `GoldenPlayAction`
Defines an interaction (callback) and an optional finder to capture a specific snapshot during a "play" sequence.

### `WidgetTesterExtension`
Adds `pumpWidgetbookCase` and `precacheImages` to `WidgetTester` to ensure images are fully loaded before capturing snapshots.

## Network Image Mocking

The package includes a built-in `goldenTestZoneRunner` that sets up a mocked `HttpClient`. This allows you to:
- Provide custom image data for any URL via `networkImageResolver`.
- Simulate loading states for specific URLs.
- Simulate and ignore network errors.

## License

[MIT](LICENSE)
