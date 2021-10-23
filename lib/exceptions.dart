class NetworkException implements Exception {}

class InvalidAccessToken implements Exception {
  final String message;

  // Passed as an argument so it can be overridden
  InvalidAccessToken(
      [this.message = "The resource you tried to access is forbidden. "
          "Please confirm that the authentication token is correctly "
          "set up in the 'X-Access-Token' header and that you have "
          "proper access rights for the resource you tried to access."]);

  @override
  String toString() {
    return "InvalidAccessToken: $message";
  }
}

class ResourceNotFoundError implements Exception {
  final String message;

  // Passed as an argument so it can be overridden
  ResourceNotFoundError(
      [this.message = "The requested resource was not found. "
          "Please confirm that the identifier used is valid."]);
}

class TooManyRequests implements Exception {
  final String message;

  // Passed as an argument so it can be overridden
  TooManyRequests(
      [this.message =
          "Your rate limit was exceeded. Please hold on a bit and try again"]);
}

class UnknownException implements Exception {
  final String message;

  // Passed as an argument so it can be overridden
  UnknownException(
      [this.message =
          "The source of the error cannot be identified at this time."]);
}
