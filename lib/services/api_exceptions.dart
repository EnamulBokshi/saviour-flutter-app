class ApiException implements Exception {
  final String message;
  final int? code;
  ApiException(this.message, {this.code});

  @override
  String toString() => code != null ? '[$code] $message' : message;
}
