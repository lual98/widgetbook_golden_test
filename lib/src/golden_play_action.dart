import 'package:flutter_test/flutter_test.dart';

/// A callback function to execute a play action.
typedef WidgetPlayCallback =
    Future<void> Function(WidgetTester tester, CommonFinders find);

/// A finder callback to locate a widget for a golden snapshot.
typedef WidgetFinderCallback = Finder Function(CommonFinders find);

/// Represents a single play action to be performed during a golden test.
///
/// Each [GoldenPlayAction] defines a [name], a [callback] to execute, and an optional [goldenFinder]
/// to locate the widget for the golden snapshot. These actions can be used to simulate user
/// interactions or state changes before capturing a golden image.
class GoldenPlayAction {
  /// The name of the play action, used for identification and golden snapshot generation.
  /// Should not be repeated in the same case.
  final String name;

  /// The callback function to execute the play action.
  ///
  /// Receives a [WidgetTester] and [CommonFinders] for widget interaction.
  final WidgetPlayCallback callback;

  /// Optional finder callback to locate the widget for the golden snapshot.
  final WidgetFinderCallback? goldenFinder;

  /// Creates a [GoldenPlayAction].
  ///
  /// [name] is required and should describe the action.
  /// [callback] is required and defines the action logic.
  /// [goldenFinder] is optional and can be used to specify a custom finder for the golden image.
  const GoldenPlayAction({
    required this.name,
    required this.callback,
    this.goldenFinder,
  });
}
