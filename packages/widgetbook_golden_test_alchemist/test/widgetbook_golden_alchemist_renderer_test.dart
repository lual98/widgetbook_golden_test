import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_alchemist/src/widgetbook_golden_alchemist_renderer.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

void main() {
  group(WidgetbookGoldenAlchemistRenderer, () {
    group("renderSimpleGoldenTest", () {
      group("executes the widgetbuild", () {
        bool widgetBuildExecuted = false;
        final properties = WidgetbookGoldenTestsProperties();
        final useCase = WidgetbookUseCase(
          name: "widget build test",
          builder: (_) {
            widgetBuildExecuted = true;
            return SizedBox.shrink();
          },
        );

        final renderer = WidgetbookGoldenAlchemistRenderer();
        renderer.renderSimpleGoldenTest(
          goldenPath: "./snaphots/",
          properties: properties,
          useCase: useCase,
          skip: false,
        );

        tearDownAll(() {
          expect(widgetBuildExecuted, true);
        });
      });

      group("executes pumpBeforeImagePrecache and pumpAfterImagePrecache", () {
        bool pumpBeforeExecuted = false;
        bool pumpAfterExecuted = false;
        final properties = WidgetbookGoldenTestsProperties();
        final useCase = WidgetbookUseCase(
          name: "pump hooks test",
          builder: (_) => SizedBox.shrink(),
        );

        final renderer = WidgetbookGoldenAlchemistRenderer();
        renderer.renderSimpleGoldenTest(
          goldenPath: "./snaphots/",
          properties: properties,
          useCase: useCase,
          skip: false,
          goldenTestBuilder: WidgetbookGoldenTestBuilder(
            builder: (context) => SizedBox.shrink(),
            pumpBeforeImagePrecache: (tester) async {
              pumpBeforeExecuted = true;
            },
            pumpAfterImagePrecache: (tester) async {
              pumpAfterExecuted = true;
            },
          ),
        );

        tearDownAll(() {
          expect(pumpBeforeExecuted, true);
          expect(pumpAfterExecuted, true);
        });
      });

      group("executes with addons and constraints without error", () {
        bool addonBuilderExecuted = false;
        final properties = WidgetbookGoldenTestsProperties();
        final useCase = WidgetbookUseCase(
          name: "addons and constraints test",
          builder: (_) => SizedBox.shrink(),
        );

        final renderer = WidgetbookGoldenAlchemistRenderer();
        renderer.renderSimpleGoldenTest(
          goldenPath: "./snaphots/",
          properties: properties,
          useCase: useCase,
          skip: false,
          goldenTestBuilder: WidgetbookGoldenTestBuilder(
            builder: (context) => SizedBox.shrink(),
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
            addons: [
              ThemeAddon(
                themes: [
                  WidgetbookTheme(name: 'Dark', data: ThemeData.dark()),
                ],
                initialTheme: WidgetbookTheme(
                  name: 'Dark',
                  data: ThemeData.dark(),
                ),
                themeBuilder: (context, theme, child) {
                  addonBuilderExecuted = true;
                  return Theme(data: theme, child: child);
                },
              ),
            ],
          ),
        );

        tearDownAll(() {
          expect(addonBuilderExecuted, true);
        });
      });
    });

    group("renderGoldenPlayActionTest", () {
      group("executes action custom pump", () {
        bool customPumpExecuted = false;
        final action = GoldenPlayAction(
          name: "validate custom pump execution",
          callback: (tester, find) async {},
          customPump: (tester) async {
            await tester.pump();
            customPumpExecuted = true;
          },
        );
        final properties = WidgetbookGoldenTestsProperties();
        final useCase = WidgetbookUseCase(
          name: "custom pump test",
          builder: (_) => SizedBox.shrink(),
        );

        final renderer = WidgetbookGoldenAlchemistRenderer();
        renderer.renderGoldenPlayActionTest(
          action: action,
          useCase: useCase,
          goldenPath: "./snaphots/",
          properties: properties,
          skip: false,
        );

        tearDownAll(() {
          expect(customPumpExecuted, true);
        });
      });

      group("executes pumpAndSettle", () {
        bool callbackExecuted = false;
        final action = GoldenPlayAction(
          name: "validate pump and settle execution",
          callback: (tester, find) async {
            callbackExecuted = true;
          },
        );
        final properties = WidgetbookGoldenTestsProperties();
        final useCase = WidgetbookUseCase(
          name: "pump and settle test",
          builder: (_) => SizedBox.shrink(),
        );

        final renderer = WidgetbookGoldenAlchemistRenderer();
        renderer.renderGoldenPlayActionTest(
          action: action,
          useCase: useCase,
          goldenPath: "./snaphots/",
          properties: properties,
          skip: false,
        );

        tearDownAll(() {
          expect(callbackExecuted, true);
        });
      });

      group("executes pumpBeforeImagePrecache and pumpAfterImagePrecache", () {
        bool pumpBeforeExecuted = false;
        bool pumpAfterExecuted = false;
        final action = GoldenPlayAction(
          name: "pump hooks action",
          callback: (tester, find) async {},
        );
        final properties = WidgetbookGoldenTestsProperties();
        final useCase = WidgetbookUseCase(
          name: "pump hooks action test",
          builder: (_) => SizedBox.shrink(),
        );

        final renderer = WidgetbookGoldenAlchemistRenderer();
        renderer.renderGoldenPlayActionTest(
          action: action,
          useCase: useCase,
          goldenPath: "./snaphots/",
          properties: properties,
          skip: false,
          goldenTestBuilder: WidgetbookGoldenTestBuilder(
            builder: (context) => SizedBox.shrink(),
            pumpBeforeImagePrecache: (tester) async {
              pumpBeforeExecuted = true;
            },
            pumpAfterImagePrecache: (tester) async {
              pumpAfterExecuted = true;
            },
          ),
        );

        tearDownAll(() {
          expect(pumpBeforeExecuted, true);
          expect(pumpAfterExecuted, true);
        });
      });

      group("executes with addons and constraints without error", () {
        bool addonBuilderExecuted = false;
        final action = GoldenPlayAction(
          name: "addons action",
          callback: (tester, find) async {},
        );
        final properties = WidgetbookGoldenTestsProperties();
        final useCase = WidgetbookUseCase(
          name: "addons action test",
          builder: (_) => SizedBox.shrink(),
        );

        final renderer = WidgetbookGoldenAlchemistRenderer();
        renderer.renderGoldenPlayActionTest(
          action: action,
          useCase: useCase,
          goldenPath: "./snaphots/",
          properties: properties,
          skip: false,
          goldenTestBuilder: WidgetbookGoldenTestBuilder(
            builder: (context) => SizedBox.shrink(),
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
            addons: [
              ThemeAddon(
                themes: [
                  WidgetbookTheme(name: 'Dark', data: ThemeData.dark()),
                ],
                initialTheme: WidgetbookTheme(
                  name: 'Dark',
                  data: ThemeData.dark(),
                ),
                themeBuilder: (context, theme, child) {
                  addonBuilderExecuted = true;
                  return Theme(data: theme, child: child);
                },
              ),
            ],
          ),
        );

        tearDownAll(() {
          expect(addonBuilderExecuted, true);
        });
      });
    });
  });
}
