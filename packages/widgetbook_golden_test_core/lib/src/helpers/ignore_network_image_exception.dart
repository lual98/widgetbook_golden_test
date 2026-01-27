/// Custom exception thrown to simulate Network Errors during golden tests.
///
/// This exception is specifically caught and ignored by [handleError] to prevent
/// tests from failing due to intentional network error simulations.
class IgnoreNetworkImageException implements Exception {
  @override
  String toString() => 'Ignore network image exception';
}
