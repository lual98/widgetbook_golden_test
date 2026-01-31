# Widgetbook Golden Test

A monorepo containing tools to automatically generate Flutter golden tests from [Widgetbook](https://widgetbook.io) use cases.

## Repository Structure

This repository uses a workspace-based monorepo structure:

| Package | Description |
| --- | --- |
| [`widgetbook_golden_test`](packages/widgetbook_golden_test) | The main package for end-users. Provides easy-to-use functions for running golden tests. |
| [`widgetbook_golden_test_core`](packages/widgetbook_golden_test_core) | The core engine used by `widgetbook_golden_test`. Contains the rendering and mocking logic. |
| [`widgetbook_golden_test_alchemist`](packages/widgetbook_golden_test_alchemist) | The Alchemist package for end-users. Provides easy-to-use functions for running golden tests. |

## Getting Started

To get started with automatic golden test generation, it is recommended to use the [`widgetbook_golden_test`](packages/widgetbook_golden_test) package.

### Prerequisites

- A Flutter project using [Widgetbook](https://pub.dev/packages/widgetbook).
- [widgetbook_generator](https://pub.dev/packages/widgetbook_generator) configured in your project.

### Installation

Add `widgetbook_golden_test` to your `dev_dependencies`:

```yaml
dev_dependencies:
  widgetbook_golden_test: ^latest_version
```

## How It Works

1. **Write Use Cases**: Annotate your widgets with `@UseCase` as usual.
2. **Generate Directories**: Run `dart run build_runner build -d` to generate your Widgetbook directories.
3. **Run Golden Tests**: Create a test file that calls `runWidgetbookGoldenTests` with the generated directories.

Visual regression testing becomes zero-effort once your Widgetbook is set up!

## License

[MIT](LICENSE)
