import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

class TestWidgetbookGoldenRenderer implements WidgetbookGoldenRenderer {
  final Function(
    WidgetbookUseCase,
    String,
    WidgetbookGoldenTestsProperties,
    GoldenPlayAction,
    bool,
    WidgetbookGoldenTestBuilder?,
  )?
  renderGoldenPlayActionTestCallback;
  final Function(
    WidgetbookUseCase,
    String,
    WidgetbookGoldenTestsProperties,
    bool,
    WidgetbookGoldenTestBuilder?,
  )?
  renderSimpleGoldenTestCallback;

  TestWidgetbookGoldenRenderer({
    this.renderGoldenPlayActionTestCallback,
    this.renderSimpleGoldenTestCallback,
  });

  @override
  void renderGoldenPlayActionTest({
    required WidgetbookUseCase useCase,
    required String goldenPath,
    required WidgetbookGoldenTestsProperties properties,
    required GoldenPlayAction action,
    required bool skip,
    required WidgetbookGoldenTestBuilder? goldenTestBuilder,
  }) {
    renderGoldenPlayActionTestCallback?.call(
      useCase,
      goldenPath,
      properties,
      action,
      skip,
      goldenTestBuilder,
    );
  }

  @override
  void renderSimpleGoldenTest({
    required WidgetbookUseCase useCase,
    required String goldenPath,
    required WidgetbookGoldenTestsProperties properties,
    required bool skip,
    required WidgetbookGoldenTestBuilder? goldenTestBuilder,
  }) {
    renderSimpleGoldenTestCallback?.call(
      useCase,
      goldenPath,
      properties,
      skip,
      goldenTestBuilder,
    );
  }
}

void main() {
  group(WidgetbookGoldenTestGenerator, () {
    group('should generate test case with simple use case', () {
      bool executed = false;
      final useCase = WidgetbookUseCase(
        name: "Test use case",
        builder: (context) => Text("Hello world"),
      );
      final renderer = TestWidgetbookGoldenRenderer(
        renderSimpleGoldenTestCallback:
            (useCase, goldenPath, properties, skip, goldenTestBuilder) {
              test('generated test for use case', () async {
                executed = true;
                expect(goldenPath, ".");
                expect(skip, false);
                expect(useCase.name, "Test use case");
                expect(goldenTestBuilder, null);
              });
            },
      );

      WidgetbookGoldenTestGenerator(
        properties: WidgetbookGoldenTestsProperties(),
        renderer: renderer,
      ).generate(nodes: [useCase]);

      tearDownAll(() => expect(executed, true));
    });

    group('should generate test case with simple nested use case', () {
      bool executed = false;
      final useCase = WidgetbookUseCase(
        name: "Nested test use case",
        builder: (context) => Text("Hello world"),
      );
      final renderer = TestWidgetbookGoldenRenderer(
        renderSimpleGoldenTestCallback:
            (useCase, goldenPath, properties, skip, goldenTestBuilder) {
              test('generated test for nested use case', () async {
                executed = true;
                expect(goldenPath, "./Test folder/Test component");
                expect(skip, false);
                expect(useCase.name, "Nested test use case");
                expect(goldenTestBuilder, null);
              });
            },
      );

      WidgetbookGoldenTestGenerator(
        properties: WidgetbookGoldenTestsProperties(),
        renderer: renderer,
      ).generate(
        nodes: [
          WidgetbookFolder(
            name: "Test folder",
            children: [
              WidgetbookComponent(name: "Test component", useCases: [useCase]),
            ],
          ),
        ],
      );

      tearDownAll(() => expect(executed, true));
    });

    group('should generate golden test with golden test builder', () {
      bool executedMainTest = false;
      bool executedGoldenTest = false;
      bool executedGoldenCallback = false;
      final useCase = WidgetbookUseCase(
        name: "Test use case",
        builder: (context) => WidgetbookGoldenTestBuilder(
          builder: (context) => Text("Hello world"),
          goldenActions: [
            GoldenPlayAction(
              name: "callback",
              callback: (_, _) async {
                executedGoldenCallback = true;
              },
            ),
          ],
        ),
      );
      final renderer = TestWidgetbookGoldenRenderer(
        renderSimpleGoldenTestCallback:
            (useCase, goldenPath, properties, skip, goldenTestBuilder) {
              test('generated main test for use case', () async {
                executedMainTest = true;
                expect(goldenPath, ".");
                expect(skip, false);
                expect(useCase.name, "Test use case");
                expect(goldenTestBuilder, isA<WidgetbookGoldenTestBuilder>());
              });
            },
        renderGoldenPlayActionTestCallback:
            (useCase, goldenPath, properties, action, skip, goldenTestBuilder) {
              testWidgets('generated golden test for use case', (tester) async {
                executedGoldenTest = true;
                action.callback(tester, find);
                expect(goldenPath, ".");
                expect(skip, false);
                expect(useCase.name, "Test use case");
                expect(goldenTestBuilder, isA<WidgetbookGoldenTestBuilder>());
              });
            },
      );

      WidgetbookGoldenTestGenerator(
        properties: WidgetbookGoldenTestsProperties(),
        renderer: renderer,
      ).generate(nodes: [useCase]);

      tearDownAll(() {
        expect(executedMainTest, true);
        expect(executedGoldenTest, true);
        expect(executedGoldenCallback, true);
      });
    });
  });
}
