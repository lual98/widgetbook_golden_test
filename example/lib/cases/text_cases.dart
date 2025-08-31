import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:example/l10n/app_localizations.dart';

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
