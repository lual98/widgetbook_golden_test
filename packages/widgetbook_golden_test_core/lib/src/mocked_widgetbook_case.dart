import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_golden_test_core/src/merge_addons.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';
// ignore: implementation_imports
import 'package:widgetbook/src/addons/addons.dart';

class _WidgetbookStateMock extends Mock implements WidgetbookState {}

/// Builds a [WidgetbookUseCase] with mocked dependencies to be used in golden tests.
/// The built widget is wrapped with the necessary parents to be pumped properly
/// like a [WidgetbookScope], a [MaterialApp] and a [Scaffold].
class MockedWidgetbookCase extends StatefulWidget {
  /// Creates a [MockedWidgetbookCase].
  const MockedWidgetbookCase({
    required this.properties,
    required this.builderAddons,
    required this.useCase,
    this.constraints,
    this.includeScaffold = true,
    super.key,
  });

  /// Properties for configuring the golden tests.
  final WidgetbookGoldenTestsProperties properties;

  /// Optional list of addons from the [WidgetbookGoldenTestBuilder].
  final List<WidgetbookAddon>? builderAddons;

  /// Whether to include a [Scaffold] in the widget tree.
  final bool includeScaffold;

  /// The Widgetbook use case to be rendered.
  final WidgetbookUseCase useCase;

  /// Optional constraints to be applied to the widget.
  final BoxConstraints? constraints;

  @override
  State<MockedWidgetbookCase> createState() => MockedWidgetbookCaseState();
}

class MockedWidgetbookCaseState extends State<MockedWidgetbookCase> {
  Widget? _widgetToTest;

  /// The widget that is currently being tested.
  /// Used by the renderer to identify the widget for taking the golden snapshot.
  Widget? get widgetToTest => _widgetToTest;

  @override
  Widget build(BuildContext context) {
    var widgetbookStateMock = _WidgetbookStateMock();
    when(() => widgetbookStateMock.queryParams).thenReturn({});
    when(
      () => widgetbookStateMock.knobs,
    ).thenReturn(KnobsRegistry(onLock: () {}));
    when(() => widgetbookStateMock.addons).thenReturn(widget.properties.addons);
    when(() => widgetbookStateMock.previewMode).thenReturn(true);
    final multiAddonBuilder = MultiAddonBuilder(
      addons: mergeAddons(
        widget.properties.addons,
        widget.builderAddons,
        widget.properties.addonsMergeStrategy,
      ),
      builder: (context, addon, child) {
        final newSetting = addon.valueFromQueryGroup({});
        return addon.buildUseCase(context, child, newSetting);
      },
      child: ConstrainedBox(
        constraints: widget.constraints ?? const BoxConstraints(),
        child: Builder(
          builder: (context) {
            _widgetToTest = widget.useCase.builder(context);
            return _widgetToTest!;
          },
        ),
      ),
    );
    return WidgetbookScope(
      state: widgetbookStateMock,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // ignore: deprecated_member_use_from_same_package
        locale: widget.properties.locale,
        // ignore: deprecated_member_use_from_same_package
        localizationsDelegates: widget.properties.localizationsDelegates,
        // ignore: deprecated_member_use_from_same_package
        supportedLocales: widget.properties.supportedLocales,
        theme: widget.properties.theme,
        home: widget.includeScaffold
            ? Scaffold(body: multiAddonBuilder)
            : Material(child: multiAddonBuilder),
      ),
    );
  }
}
