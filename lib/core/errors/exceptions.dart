/// 앱에서 사용하는 커스텀 예외 클래스들

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({
    this.message = 'User is not authorized',
  });

  @override
  String toString() => 'UnauthorizedException: $message';
}

class ValidationException implements Exception {
  final String message;

  const ValidationException({required this.message});

  @override
  String toString() => 'ValidationException: $message';
}