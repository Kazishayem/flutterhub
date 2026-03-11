import 'dart:io';

import 'package:dio/dio.dart';

class ErrorHandle {
  static Never handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
        throw Exception(
          'No internet connection. Please check your network and try again.',
        );
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw Exception(
          'The server is taking too long to respond. Please try again.',
        );
      case DioExceptionType.badResponse:
        final message = _extractServerMessage(e);
        throw Exception(message);
      case DioExceptionType.badCertificate:
        throw Exception('Secure connection failed. Please try again later.');
      case DioExceptionType.cancel:
        throw Exception('Request was cancelled. Please retry.');
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          throw Exception(
            'No internet connection. Please check your network and try again.',
          );
        }
        throw Exception('Something went wrong. Please try again.');
    }
  }

  static String _extractServerMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final directMessage = data['message'];
      if (directMessage is String && directMessage.trim().isNotEmpty) {
        return directMessage;
      }

      if (directMessage is Map<String, dynamic>) {
        final nestedMessage = directMessage['message'];
        if (nestedMessage is String && nestedMessage.trim().isNotEmpty) {
          return nestedMessage;
        }
      }

      final errorMessage = data['error'];
      if (errorMessage is String && errorMessage.trim().isNotEmpty) {
        return errorMessage;
      }
    }

    final statusCode = e.response?.statusCode;
    if (statusCode != null) {
      return 'Request failed (status $statusCode). Please try again.';
    }

    return 'Request failed. Please try again.';
  }
}
