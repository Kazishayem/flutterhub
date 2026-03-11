import '../sources/remote/auth_api_service.dart';

class AuthRepository {
  final AuthApiService remoteSource;

  AuthRepository({required this.remoteSource});

  Future<bool> register() async {
    return await remoteSource.register();
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    return await remoteSource.login(username: username, password: password);
  }
}
