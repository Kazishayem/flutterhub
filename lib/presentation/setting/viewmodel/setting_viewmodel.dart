import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../data/sources/local/shared_preference/shared_preference.dart';

final cachedUserProvider = FutureProvider<Map<String, dynamic>?>(
  (ref) => SharedPreferenceData.getUserData(),
);

final logoutLoadingProvider = StateProvider<bool>((ref) => false);
