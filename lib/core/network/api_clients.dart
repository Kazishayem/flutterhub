import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/sources/local/shared_preference/shared_preference.dart'
    show SharedPreferenceData;
import 'api_endpoints.dart';
import 'error_handle.dart';
import 'respose_handle.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Map<String, String>? headers;

  static Future<void> headerSet(String? token) async {
    final cachedToken = await SharedPreferenceData.getToken();
    headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (cachedToken != null) 'Authorization': 'Bearer $cachedToken',
    };
  }

  Future<dynamic> getRequest({required String endpoints}) async {
    try {
      log('url: ${ApiEndpoints.baseUrl}/$endpoints');
      final response = await _dio.get(
        '/$endpoints',
        options: Options(
          headers: headers ?? {'Content-Type': 'application/json'},
        ),
      );
      return ResposeHandle.handleResponse(response);
    } catch (e) {
      _rethrowHandledError(e);
    }
  }

  Future<dynamic> postRequest({
    required String endpoints,
    Map<String, dynamic>? body,
    FormData? formData,
  }) async {
    try {
      log('url: ${ApiEndpoints.baseUrl}/$endpoints');
      final response = await _dio.post(
        '/$endpoints',
        data: body ?? formData,
        options: Options(
          headers: headers ?? {'Content-Type': 'application/json'},
        ),
      );
      return ResposeHandle.handleResponse(response);
    } catch (e) {
      _rethrowHandledError(e);
    }
  }

  static Future<dynamic> putRequest({
    required String endpoints,
    required Map<String, dynamic> body,
  }) async {
    try {
      log('url: ${ApiEndpoints.baseUrl}/$endpoints');
      final response = await _dio.put(
        '/$endpoints',
        data: body,
        options: Options(
          headers: headers ?? {'Content-Type': 'application/json'},
        ),
      );
      return ResposeHandle.handleResponse(response);
    } catch (e) {
      _rethrowHandledError(e);
    }
  }

  static Future<dynamic> patchRequest({
    required String endpoints,
    Map<String, dynamic>? body,
    FormData? formData,
  }) async {
    try {
      log('url: ${ApiEndpoints.baseUrl}/$endpoints');
      final response = await _dio.patch(
        '${ApiEndpoints.baseUrl}/$endpoints',
        data: body ?? formData,
        options: Options(
          headers: headers ?? {'Content-Type': 'multipart/form-data'},
        ),
      );

      debugPrint('PATCH request successful');
      return ResposeHandle.handleResponse(response);
    } catch (e) {
      _rethrowHandledError(e);
    }
  }

  static Future<dynamic> deleteRequest({required String endpoints}) async {
    try {
      log('url: ${ApiEndpoints.baseUrl}/$endpoints');
      final response = await _dio.delete(
        '/$endpoints',
        options: Options(
          headers: headers ?? {'Content-Type': 'multipart/form-data'},
        ),
      );

      debugPrint('DELETE request successful');
      return ResposeHandle.handleResponse(response);
    } catch (e) {
      _rethrowHandledError(e);
    }
  }

  static Never _rethrowHandledError(Object error) {
    if (error is DioException) {
      ErrorHandle.handleDioError(error);
    }

    throw Exception('Unexpected error occurred. Please try again.');
  }
}
