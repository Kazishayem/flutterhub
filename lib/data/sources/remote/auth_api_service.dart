import 'dart:developer';

import '../../../core/network/api_clients.dart';
import '../../../core/network/api_endpoints.dart';
import '../local/shared_preference/shared_preference.dart';

class AuthApiService {
  final ApiClient apiClient;

  AuthApiService({required this.apiClient});

  Future<bool> register() async {
    await apiClient.postRequest(endpoints: ApiEndpoints.register);
    return true;
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      final body = {
        'username': username,
        'password': password,
        'expiresInMins': 30,
      };

      final dynamic response = await apiClient.postRequest(
        body: body,
        endpoints: ApiEndpoints.login,
      );

      if (response is Map<String, dynamic> &&
          response['accessToken'] != null &&
          response['id'] != null) {
        final accessToken = response['accessToken'].toString();
        await SharedPreferenceData.setToken(accessToken);
        await SharedPreferenceData.setUserData(response);
        await ApiClient.headerSet(accessToken);
        return true;
      }

      return false;
    } catch (error) {
      log('Login failed: $error');
      rethrow;
    }
  }
}
