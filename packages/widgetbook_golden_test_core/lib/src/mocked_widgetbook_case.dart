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
class MockedWidgetbookCase extends StatelessWidget {
  MockedWidgetbookCase({
    required this.properties,
    required this.builderAddons,
    required this.useCase,
    super.key,
  });

  final WidgetbookGoldenTestsProperties properties;
  final List<WidgetbookAddon>? builderAddons;
  final WidgetbookUseCase useCase;
  Widget? _widgetToTest;

  Widget? get widgetToTest => _widgetToTest;

  @override
  Widget build(BuildContext context) {
    var widgetbookStateMock = _WidgetbookStateMock();
    when(() => widgetbookStateMock.queryParams).thenReturn({});
    when(
      () => widgetbookStateMock.knobs,
    ).thenReturn(KnobsRegistry(onLock: () {}));
    when(() => widgetbookStateMock.addons).thenReturn(properties.addons);
    when(() => widgetbookStateMock.previewMode).thenReturn(true);
    return WidgetbookScope(
      state: widgetbookStateMock,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // ignore: deprecated_member_use_from_same_package
        locale: properties.locale,
        // ignore: deprecated_member_use_from_same_package
        localizationsDelegates: properties.localizationsDelegates,
        // ignore: deprecated_member_use_from_same_package
        supportedLocales: properties.supportedLocales,
        theme: properties.theme,
        home: Material(
          child: MultiAddonBuilder(
            addons: mergeAddons(
              properties.addons,
              builderAddons,
              properties.addonsMergeStrategy,
            ),
            builder: (context, addon, child) {
              final newSetting = addon.valueFromQueryGroup({});
              return addon.buildUseCase(context, child, newSetting);
            },
            child: Builder(
              builder: (context) {
                _widgetToTest = useCase.builder(context);
                return _widgetToTest!;
              },
            ),
          ),
        ),
      ),
    );
  }
}
