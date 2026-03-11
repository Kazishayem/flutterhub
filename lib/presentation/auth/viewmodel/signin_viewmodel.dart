import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutterhub/data/repositories/auth_repository.dart';
import 'package:flutterhub/data/sources/remote/auth_api_service.dart';

import '../../../core/network/api_clients.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(remoteSource: AuthApiService(apiClient: ApiClient())),
);

final signinLoadingProvider = StateProvider<bool>((ref) => false);
