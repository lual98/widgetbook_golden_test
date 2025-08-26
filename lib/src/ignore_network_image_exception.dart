/// Custom exception thrown to simulate Network Errors.
/// This exception will be ignored from test cases so they don't fail.
class IgnoreNetworkImageException implements Exception {
  @override
  String toString() => 'Ignore network image exception';
}
