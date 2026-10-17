


class AppExceptions implements Exception {
  final String? _message;
  final String? _prefix;

  AppExceptions([this._message, this._prefix]);

  @override
  String toString() => "$_prefix$_message";

}

class InternetException extends AppExceptions {

  InternetException([String? message]) : super(message, "No Internet: ");

}

class RequestTimeOut extends AppExceptions {

  RequestTimeOut([String? message]) : super(message, "Request Timeout: ");
}

class ServerException extends AppExceptions {

  ServerException([String? message]) : super(message, "Internal Server Error: ");
}

class InvalidUrlException extends AppExceptions {

  InvalidUrlException([String? message]) : super(message, "Invalid URL: ");
}

class FetchDataException extends AppExceptions {

  FetchDataException([String? message]) : super(message, "");
}

class UnauthorisedException extends AppExceptions {

  UnauthorisedException([String? message]) : super(message, "Unauthorized: ");
}

class ForbiddenException extends AppExceptions {

  ForbiddenException([String? message]) : super(message, "Forbidden: ");
}

class NotFoundException extends AppExceptions {

  NotFoundException([String? message]) : super(message, "Not Found: ");
}

class ServiceUnavailableException extends AppExceptions {

  ServiceUnavailableException([String? message]) : super(message, "Service Unavailable: ");
}
