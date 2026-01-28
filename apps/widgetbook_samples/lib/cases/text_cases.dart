import 'package:widgetbook_samples/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Custom text with initial value', type: Text)
Widget buildTextUseCase(BuildContext context) {
  return Text(context.knobs.string(label: "My text", initialValue: "Default"));
}

@widgetbook.UseCase(name: 'Custom text without initial value', type: Text)
Widget buildTextWithoutInitialValueUseCase(BuildContext context) {
  return Text(context.knobs.string(label: "My text"));
}

@widgetbook.UseCase(name: 'Localized text', type: Text)
Widget buildTextLocalizedUseCase(BuildContext context) {
  return Text(
    AppLocalizations.of(context)?.ambiguosLengthText ?? "Not localized",
  );
}

@widgetbook.UseCase(name: 'Custom theme extension text', type: Text)
Widget buildTextWithCustomThemeExtensionUseCase(BuildContext context) {
  return Text(
    "This text should be italic",
    style: Theme.of(context).myCustomTheme.someTextStyle,
  );
}

extension MyCustomThemeExtension on ThemeData {
  MyCustomTheme get myCustomTheme =>
      extension<MyCustomTheme>() ?? MyCustomTheme(const TextStyle());
}

class MyCustomTheme extends ThemeExtension<MyCustomTheme> {
  final TextStyle someTextStyle;

  MyCustomTheme(this.someTextStyle);

  MyCustomTheme.dark()
    : someTextStyle = const TextStyle(fontStyle: FontStyle.italic);

  @override
  ThemeExtension<MyCustomTheme> copyWith({TextStyle? someTextStyle}) {
    return MyCustomTheme(someTextStyle ?? this.someTextStyle);
  }

  @override
  ThemeExtension<MyCustomTheme> lerp(
    covariant ThemeExtension<MyCustomTheme>? other,
    double t,
  ) {
    if (other is! MyCustomTheme) {
      return this;
    }
    return MyCustomTheme(
      TextStyle.lerp(someTextStyle, other.someTextStyle, t)!,
    );
  }
}
