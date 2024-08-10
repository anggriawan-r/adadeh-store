class ErrorHandling implements Exception {
  final String message;
  ErrorHandling(this.message);

  @override
  String toString() => message;
}
